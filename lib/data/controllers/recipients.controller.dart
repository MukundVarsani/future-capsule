import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:future_capsule/core/widgets/snack_bar.dart';
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
  String? currentUserId;
  var availableRecipientIds = <int>[].obs;
  RxList<UserModel> availableRecipients = <UserModel>[].obs;

  var isRecipientLoading = false.obs;
  var isCapsuleSending = false.obs;

  @override
  void onInit() {
    currentUserId = _userController.getUser?.uid;
    super.onInit();
  }

  //^ My Future Capsule Variable
  RxList<UserModel> myFutureUserList = <UserModel>[].obs;
  var myFuture = <String, List<Map<String, dynamic>>>{}.obs;

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
            .where('senderId', isEqualTo: currentUserId!)
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
              senderId: currentUserId!,
              recipientId: recipientId,
              status: capsule.status,
              shareDate: DateTime.now(),
            ).toJson());

        DocumentReference capsuleRef = _firebaseFirestore
            .collection('Users_Capsules')
            .doc(capsule.capsuleId);

        await capsuleRef.update({
          "testRecipients": FieldValue.arrayUnion([
            {
              "recipientId": recipientId,
              "status": capsule.status,
              "createdAt": DateTime.now().toIso8601String(),
            }
          ])
        });
      }

      await batch.commit();

      appBar(text: 'Capsule sent to ${availableRecipientIds.length} users.');

      for (int recipientId in availableRecipientIds) {
        String userName = availableRecipients[recipientId].name;

        if (availableRecipients[recipientId].fcmToken != null &&
            availableRecipients[recipientId].fcmToken!.isNotEmpty) {
          NotificationService.sendNotification(
              userId: availableRecipients[recipientId].userId,
              userName: userName,
              capsuleTitle: capsule.title);
        }
      }
    } catch (e) {
      Vx.log("Error while sending capsule $e");
    } finally {
      isCapsuleSending(false);
      clearRecipients();
    }
  }

//* my Future capsules stream
  Stream<Map<String, List<Map<String, dynamic>>>>
      fetchSharedCapsulesWithUsersOPTStream() async* {
    if (currentUserId == null) return;

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await for (QuerySnapshot sharedCapsulesSnapshot in firestore
        .collection('SharedCapsules')
        .where('recipientId', isEqualTo: currentUserId)
        .orderBy('shareDate', descending: true)
        .snapshots()) {
      Set<String> senderIds = {};
      List<String> capsuleIds = [];

      for (var doc in sharedCapsulesSnapshot.docs) {
        senderIds.add(doc['senderId']);
        capsuleIds.add(doc['capsuleId']);
      }

      List<DocumentSnapshot> capsuleSnapshots = await Future.wait(
        capsuleIds.map((capsuleId) =>
            firestore.collection('Users_Capsules').doc(capsuleId).get()),
      );

      Map<String, List<Map<String, dynamic>>> tempMyFuture = {};

      for (int i = 0; i < sharedCapsulesSnapshot.docs.length; i++) {
        var doc = sharedCapsulesSnapshot.docs[i];
        String senderId = doc['senderId'];
        String sharedDate = doc['shareDate'];

        if (capsuleSnapshots[i].exists) {
          Map<String, dynamic> capsuleData =
              capsuleSnapshots[i].data() as Map<String, dynamic>;

          Map<String, dynamic> mappedData = {
            "data": capsuleData,
            "sharedDate": sharedDate,
          };

          tempMyFuture.putIfAbsent(senderId, () => []).add(mappedData);
        }
      }

      // Emit real-time updates to myFuture
      myFuture.value = tempMyFuture;

      // Fetch users in real time
      myFutureUserList.value = (await Future.wait(
        senderIds.map((userId) => _userController.getUserById(userId: userId)),
      ))
          .whereType<UserModel>()
          .toList();

      yield tempMyFuture; // Emit the new data
    }
  }

//* Update Capsule Status
  void updateCapsuleStatus({required String capsuleId}) async {
    if (currentUserId == null) return;
    try {
      final docRef =
          _firebaseFirestore.collection("Users_Capsules").doc(capsuleId);
      final snapshot = await docRef.get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final List<dynamic> recipients = data["testRecipients"];

        // Modify status of the matched recipient
        final updatedRecipients = recipients.map((recipient) {
          if (recipient["recipientId"] == currentUserId) {
            return {
              ...recipient,
              "status": "opened",
            };
          }
          return recipient;
        }).toList();

        // Update the whole recipients array
        await docRef.update({"testRecipients": updatedRecipients});
      }
      Vx.log("Status updated");
    } catch (e) {
      Vx.log("Error in updateCapsuleStatus : $e");
    }
  }

  void updateLikes({required String capsuleId}) async {
    if (currentUserId == null) return;
    final docRef =
        _firebaseFirestore.collection("Users_Capsules").doc(capsuleId);
    try {
      final snapshot = await docRef.get();
      if (!snapshot.exists) return;

      final data = snapshot.data();
      List<Map<String, dynamic>> likes = [];

      if (data?['likes'] != null) {
        likes = List<Map<String, dynamic>>.from(data!['likes']);
      }

      final alreadyLiked =
          likes.any((like) => like['recipientId'] == currentUserId);

      if (alreadyLiked) {
        likes.removeWhere((like) => like['recipientId'] == currentUserId);
      } else {
        likes.add({"recipientId": currentUserId});
      }

      await docRef.update({"likes": likes});
    } catch (e) {
      Vx.log("Error in updateLikes : $e");
    }
  }

  Stream<List<UserModel>> getStreamLikes(String capsuleId) {
    return _firebaseFirestore
        .collection("Users_Capsules")
        .doc(capsuleId)
        .snapshots()
        .asyncMap((snapshot) async {
      if (!snapshot.exists) return [];

      final data = snapshot.data();
      if (data == null || data['likes'] == null) return [];

      final likesList = List<Map<String, dynamic>>.from(data['likes']);
      final userIds =
          likesList.map((like) => like['recipientId'] as String).toList();

      // Fetch actual user data
      return await _fetchUsersByIds(userIds);
    });
  }

  //* Fetch list of Usermodal By IDs
  Future<List<UserModel>> _fetchUsersByIds(List<String?> userIds) async {
    if (userIds.isEmpty) return [];

    try {
      QuerySnapshot userSnap = await _firebaseFirestore
          .collection('Future_Capsule_Users')
          .where(FieldPath.documentId, whereIn: userIds)
          .get();

      return userSnap.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Vx.log("Error fetching user details: $e");
      return [];
    }
  }

  Stream<CapsuleModel> capsuleStream(String capsuleId) {
    return FirebaseFirestore.instance
        .collection('Users_Capsules')
        .doc(capsuleId)
        .snapshots()
        .map((doc) => CapsuleModel.fromJson(doc.data()!));
  }
}
