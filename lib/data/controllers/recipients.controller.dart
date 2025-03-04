import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:future_capsule/core/widgets/snack_bar.dart';
import 'package:future_capsule/data/controllers/capsule.controller.dart';
import 'package:future_capsule/data/controllers/user.controller.dart';
import 'package:future_capsule/data/models/capsule_modal.dart';
import 'package:future_capsule/data/models/shared_capsule_modal.dart';
import 'package:future_capsule/data/models/user_modal.dart';
import 'package:future_capsule/data/services/notification_service.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:velocity_x/velocity_x.dart';

class RecipientController extends GetxController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();
  final UserController _userController = Get.put(UserController());
  final CapsuleController _capsuleController = Get.put(CapsuleController());

  RxInt selectedUser = (-1).obs;
  var availableRecipientIds = <int>[].obs;
  RxList<UserModel> availableRecipients = <UserModel>[].obs;
  RxList<CapsuleModel> recipientsCapsules = <CapsuleModel>[].obs;
  RxList<String> recipientUserIds = <String>[].obs;
  RxList<DateTime> recipientUserSendDate = <DateTime>[].obs;
  RxList<UserModel> recipientUser = <UserModel>[].obs;
  var recipientCapsulesMap = <String, List<CapsuleModel>>{}.obs;

  var isRecipientLoading = false.obs;
  var isCapsuleSending = false.obs;
  var isCapsuleLoading = false.obs;

  //* Add a recipient to the list
  void addRecipient(int userId) {
    if (!availableRecipientIds.contains(userId)) {
      availableRecipientIds.add(userId);
    }
  }

  //* Remove a recipient from the list
  void removeRecipient(int userId) {
    availableRecipientIds.remove(userId);
  }

//* Clear the list
  void clearRecipients() {
    availableRecipientIds.clear();
  }

//* get all the available recipient user
  void getAvailableRecipients() async {
    String? currentUserId = _userController.getUser?.uid;
    if (currentUserId == null) return;

    isRecipientLoading(true);
    try {
      QuerySnapshot snapshot = await _firebaseFirestore
          .collection('Future_Capsule_Users')
          .where('userId', isNotEqualTo: currentUserId) // Exclude current user
          .get();

      List<UserModel> fetchedUsers = snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      availableRecipients.assignAll(fetchedUsers);
    } catch (e) {
      Vx.log("Error while getting available User $e");
    } finally {
      isRecipientLoading(false);
    }
  }

//* send capsule to other User
  void sendCapsule({required CapsuleModel capsule}) async {
    String? currentUserId = _userController.getUser?.uid;

    if (currentUserId == null) return;

    try {
      isCapsuleSending(true);
      WriteBatch batch =
          FirebaseFirestore.instance.batch(); // Batch for efficiency

      for (int index in availableRecipientIds.value) {
        String recipientId = availableRecipients.value[index].userId;

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('SharedCapsules')
            .where('capsuleId', isEqualTo: capsule.capsuleId)
            .where('senderId', isEqualTo: currentUserId)
            .where('recipientId', isEqualTo: recipientId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          Vx.log('Capsule already shared with $recipientId');
          continue; // Skip if already shared
        }

        String sharedId = _uuid.v4();
        DocumentReference docRef = FirebaseFirestore.instance
            .collection('SharedCapsules')
            .doc(sharedId);

        batch.set(
            docRef,
            SharedCapsule(
              sharedId: sharedId,
              capsuleId: capsule.capsuleId,
              senderId: currentUserId,
              recipientId: recipientId,
              status: capsule.status,
              shareDate: DateTime.now(),
            ).toJson());

        DocumentReference capsuleRef = _firebaseFirestore
            .collection('Users_Capsules')
            .doc(capsule.capsuleId);

        await capsuleRef.update({
          "recipients": FieldValue.arrayUnion([recipientId])
        });
      }

      await batch.commit();

      appBar(text: 'Capsule sent to ${availableRecipientIds.length} users.');

      await _capsuleController.getUserCapsule();
      getCapsulesSentToUser();
      getUsersYouSentCapsulesTo();

  
      for (int recipientId in availableRecipientIds) {
        String userName = availableRecipients[recipientId].name;
        NotificationService.sendNotification(
            userId: availableRecipients[recipientId].userId,
            userName: userName,
            capsuleTitle: capsule.title);
      }
    } catch (e) {
      Vx.log("Error while sending capsule $e");
    } finally {
      isCapsuleSending(false);
      clearRecipients();
    }
  }

//* Get recipients sorted by last capsule sent
  Future<void> getUsersYouSentCapsulesTo() async {
    String? currentUserId = _userController.getUser?.uid;
    if (currentUserId == null) return;

    try {
      isCapsuleLoading(true);
      await getRecipientIds();

      recipientUser.value = (await Future.wait(
        recipientUserIds
            .map((userId) => _userController.getUserById(userId: userId)),
      ))
          .whereType<UserModel>() // Remove null users
          .toList();
    } catch (e) {
      Vx.log("Error getting users you sent capsules to: $e");
    } finally {
      isCapsuleLoading(false);
    }
  }

//* Get recipients Id sorted by last capsule sent

  Future<void> getRecipientIds() async {
    String? currentUserId = _userController.getUser?.uid;
    if (currentUserId == null) return;

    QuerySnapshot snap = await _firebaseFirestore
        .collection("SharedCapsules")
        .where(
          "senderId",
          isEqualTo: currentUserId,
        )
        .get();

    List<SharedCapsule> data = snap.docs.map((doc) {
      return SharedCapsule.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();

    data.sort((a, b) => b.shareDate.compareTo(a.shareDate));

    recipientUserIds.value =
        data.map((capsule) => capsule.recipientId).toSet().toList();
    recipientUserSendDate.value =
        data.map((capsule) => capsule.shareDate).toSet().toList();

    await getCapsulesSentToUser();
  }


  Future<void> getCapsulesSentToUser() async {
    String? currentUserId = _userController.getUser?.uid;
    if (currentUserId == null) return;
    if (recipientUserIds.value.isEmpty) return;
    try {
      QuerySnapshot snap = await _firebaseFirestore
          .collection("SharedCapsules")
          .where("senderId", isEqualTo: currentUserId)
          .get();

      List<String> capsuleIds = (snap.docs
              .map((doc) =>
                  SharedCapsule.fromJson(doc.data() as Map<String, dynamic>))
              .toList()
            ..sort((a, b) => b.shareDate.compareTo(a.shareDate)))
          .map((capsule) => capsule.capsuleId)
          .toList();

      CollectionReference collectionReference =
          _firebaseFirestore.collection('Users_Capsules');

      QuerySnapshot querySnapshot = await collectionReference
          .where(FieldPath.documentId, whereIn: capsuleIds)
          .get();

      List<CapsuleModel> capsules = querySnapshot.docs.map((m) {
        return CapsuleModel.fromJson(m.data() as Map<String, dynamic>);
      }).toList();

      for (var userId in recipientUserIds) {
        recipientCapsulesMap[userId] =
            capsules.where((c) => c.recipients.contains(userId)).toList();
      }
    } catch (e) {
      Vx.log("Error getting capsules sent to user: $e");
    }
  }



}