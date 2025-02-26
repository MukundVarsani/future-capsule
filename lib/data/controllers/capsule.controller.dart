import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:future_capsule/core/widgets/snack_bar.dart';
import 'package:future_capsule/data/controllers/user.controller.dart';
import 'package:future_capsule/data/models/capsule_model.dart';
import 'package:future_capsule/data/models/user_model.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:velocity_x/velocity_x.dart';

class CapsuleController extends GetxController {
  static final CapsuleController _instance = CapsuleController._internal();
  CapsuleController._internal();

  factory CapsuleController() => _instance;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();
  final UserController _userController = Get.put(UserController());

//*  Capsule variable

  var capsules = <CapsuleModel>[].obs;
  var sentCapsules = <CapsuleModel>[].obs;
  var capsuleSentUsers = <UserModel>[].obs;
  var isCapsuleLoading = false.obs;
  var isCapsuleDeleting = false.obs;
  var isRecipientLoading = false.obs;
  var isAvailableUserLoading = false.obs;

  RxInt selectedUser = (-1).obs;
  RxList<UserModel> usersList = <UserModel>[].obs;
  var recipientCapsuleMap = <String, List<CapsuleModel>>{}.obs;

//^  Capsule Methods
  @override
  void onInit() {
    super.onInit();
    getUserSentCapsule();
    // Vx.log("Capsule Controller Initialize.................");
  }

  String _extractMediaIdFromUrl(String url) {
    // Define a regular expression to extract the value
    final regex = RegExp(r'capsule_media%2F[^%]*%2F([^;%]*)%2F');

    // Match the regex with the input URL
    final match = regex.firstMatch(url);

    // If a match is found, return the extracted value, otherwise return an empty string
    return match != null ? match.group(1) ?? '' : '';
  }

  void createCapsule(Map<String, dynamic> capsuleData) async {
    String? creatorId = _userController.getUser?.uid;

    if (creatorId == null) return;

    String mediaId = _extractMediaIdFromUrl(capsuleData['mediaURL']);
    DateTime now = DateTime.now();
    String capsuleId = _uuid.v4();

    CapsuleModel capsuleModel = CapsuleModel(
      capsuleId: capsuleId,
      creatorId: creatorId,
      title: capsuleData['title'],
      description: capsuleData['description'],
      media: [
        Media(
          thumbnail: capsuleData['thumbnail'],
          mediaId: mediaId,
          type: capsuleData['type'],
          url: capsuleData['mediaURL'],
        ),
      ],
      openingDate: capsuleData['openingDate'],
      recipients: [],
      privacy: Privacy(
        isTimePrivate: capsuleData['isTimePrivate'],
        isCapsulePrivate: capsuleData['isCapsulePrivate'],
        sharedWith: [],
      ),
      createdAt: now,
      updatedAt: now,
      status: "Locked",
    );

    try {
      await _firebaseFirestore
          .collection("Users_Capsules")
          .doc(capsuleId)
          .set(capsuleModel.toJson());

      await getUserCapsule();
    } catch (e) {
      Vx.log("Error while creating capsule: $e");
      rethrow;
    } finally {
      isCapsuleLoading(false);
    }
  }

  Future<void> getUserCapsule() async {
    CollectionReference reference =
        _firebaseFirestore.collection("Users_Capsules");

    String? currentUserId = _userController.getUser?.uid;
    if (currentUserId == null) return;

    try {
      isCapsuleLoading(true);
      final querySnapshot =
          await reference.where('creatorId', isEqualTo: currentUserId).get();

      List<CapsuleModel> usersCapsules = querySnapshot.docs.map((doc) {
        return CapsuleModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      capsules(usersCapsules);
    } catch (e) {
      Vx.log("Error while getting User Created capsule: $e");
      appBar(text: "Error in getting Capsule : $e");
    } finally {
      isCapsuleLoading(false);
    }
  }

  void editCapsule(Map<String, dynamic> updateData) async {
    String? creatorId = _userController.getUser?.uid;

    if (creatorId == null) return;

    DateTime now = DateTime.now();
    updateData['updatedAt'] = now.toIso8601String();
    isCapsuleLoading(true);
    try {
      DocumentSnapshot capsuleDoc = await _firebaseFirestore
          .collection("Users_Capsules")
          .doc(updateData['capsule_Id'])
          .get();

      if (!capsuleDoc.exists) {
        appBar(text: "Capsule does not exist");
        return;
      }
      Map<String, dynamic> existingData =
          capsuleDoc.data() as Map<String, dynamic>;

      updateData['privacy'] = {
        "isCapsulePrivate": updateData['privacy']["isCapsulePrivate"],
        "isTimePrivate": updateData['privacy']["isTimePrivate"],
        "sharedWith": updateData['privacy']['sharedWith'] ??
            existingData['privacy']?['sharedWith'] ??
            []
      };

      await _firebaseFirestore
          .collection("Users_Capsules")
          .doc(updateData['capsule_Id'])
          .update(updateData);

      await getUserCapsule();
      Get.back();
      Get.back();
      appBar(text: "Capsule Updated");
    } catch (e) {
      Vx.log("Error while updating capsule: $e");
      appBar(text: "Error in updating Capsule : $e");
    } finally {
      isCapsuleLoading(false);
    }
  }

  void deleteCapsule({required String capsuleId}) async {
    String? creatorId = _userController.getUser?.uid;
    if (creatorId == null) return;

    try {
      isCapsuleDeleting(true);
      await FirebaseFirestore.instance
          .collection("Users_Capsules")
          .doc(capsuleId)
          .delete();

      await getUserCapsule();
      Get.back();
      appBar(text: "Capsule deleted Successfully");
    } catch (e) {
      Vx.log("Error while deleting Capsule : $e");
    } finally {
      isCapsuleDeleting(false);
    }
  }

  void getAvailableUser() async {
    String? currentUserId = _userController.getUser?.uid;
    if (currentUserId == null) return;

    try {
      isAvailableUserLoading(true);
      QuerySnapshot snapshot = await _firebaseFirestore
          .collection('Future_Capsule_Users')
          .where('userId', isNotEqualTo: currentUserId) // Exclude current user
          .get();

      List<UserModel> fetchedUsers = snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      // Update the GetX observable list
      usersList.assignAll(fetchedUsers);
    } catch (e) {
      Vx.log(e.toString());
    } finally {
      isAvailableUserLoading(false);
    }
  }

  void sendCapsuleToUser({
    required CapsuleModel capsule,
  }) async {
    String? currentUserId = _userController.getUser?.uid;

    String? recipientId = usersList.value[selectedUser.value].userId;
    if (currentUserId == null) return;

    DocumentReference capsuleRef =
        _firebaseFirestore.collection('Users_Capsules').doc(capsule.capsuleId);
    Map<String, dynamic> recipientData = {
      "recipientId": recipientId,
      "status": capsule.status,
      "createdAt" : DateTime.now().toIso8601String()
    };

    try {
      await capsuleRef.update({
        "privacy.sharedWith": FieldValue.arrayUnion([recipientId]),
        "recipients": FieldValue.arrayUnion([recipientData])
      });

      appBar(text: 'Capsule sent');
      selectedUser(-1);
    } catch (e) {
      Vx.log(e.toString());
    }
  }

 void getUserSentCapsule() async {
  String? currentUserId = _userController.getUser?.uid;
  if (currentUserId == null) return;

  try {
    isRecipientLoading(true);
    capsuleSentUsers.clear();
    recipientCapsuleMap.clear();

    QuerySnapshot snapshot = await _firebaseFirestore
        .collection('Users_Capsules')
        .where('creatorId', isEqualTo: currentUserId)
        .get();

    //* Get the current user capsule that he has sent to someone
    List<CapsuleModel> sentCapsules = snapshot.docs
        .map((doc) => CapsuleModel.fromJson(doc.data() as Map<String, dynamic>))
        .where((capsule) => capsule.recipients.isNotEmpty)
        .toList();

    //* Get all recipients user Id
    Set<String> recipientIds = sentCapsules
        .expand((capsule) => capsule.privacy.sharedWith)
        .where((id) => id != null)
        .cast<String>()
        .toSet();

    //* Get all recipients user Data
    List<UserModel?> users = await Future.wait(
      recipientIds.map(
        (id) => _userController.getUserById(userId: id),
      ),
    );

    //* Map all recipient's Id with their capsules (sorted by time)
    for (var recipientId in recipientIds) {
      List<CapsuleModel> filteredCapsules = sentCapsules
          .where((capsule) =>
              capsule.recipients.any((r) => r?.recipientId == recipientId))
          .toList();

    //* Sort capsules by openingDate in descending order (latest first)
      filteredCapsules.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      recipientCapsuleMap[recipientId] = filteredCapsules;
    }

    capsuleSentUsers.addAll(users.whereType<UserModel>());
  } catch (e) {
    Vx.log("error while getting user sent capsule: $e");
  } finally {
    isRecipientLoading(false);
  }
}

}
