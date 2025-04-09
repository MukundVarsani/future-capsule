import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:future_capsule/core/widgets/snack_bar.dart';
import 'package:future_capsule/data/controllers/user.controller.dart';
import 'package:future_capsule/data/models/capsule_modal.dart';
import 'package:future_capsule/data/models/user_modal.dart';
import 'package:future_capsule/data/services/firebase_storage.dart';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:velocity_x/velocity_x.dart';

class CapsuleController extends GetxController {
  static final CapsuleController _instance = CapsuleController._internal();
  CapsuleController._internal();

  factory CapsuleController() => _instance;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  final FirebaseStore cloudFirestore = FirebaseStore();
  final UserController _userController = Get.put(UserController());

//*  Capsule variable
  var capsuleSentUsers = <UserModel>[].obs;
  var mySentCapsules = <CapsuleModel>[].obs;
  RxMap<String, List<UserModel>> capsuleRecipientsMap =
      <String, List<UserModel>>{}.obs;

  var isCapsuleLoading = false.obs;
  var isCapsuleDeleting = false.obs;
  var isMyCapsuleSentLoading = false.obs;
  var isCapsuleUpdating = false.obs;

//^  Capsule Methods

//* Extract Media ID from Medial URL
  String _extractMediaIdFromUrl(String url) {
    // Define a regular expression to extract the value
    final regex = RegExp(r'capsule_media%2F[^%]*%2F([^;%]*)%2F');

    // Match the regex with the input URL
    final match = regex.firstMatch(url);

    // If a match is found, return the extracted value, otherwise return an empty string
    return match != null ? match.group(1) ?? '' : '';
  }

//* Create a Capsule
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
      status: "locked",
    );

    try {
      await _firebaseFirestore
          .collection("Users_Capsules")
          .doc(capsuleId)
          .set(capsuleModel.toJson());

      // await getUserCapsule();
    } catch (e) {
      Vx.log("Error while creating capsule: $e");
      rethrow;
    } finally {
      isCapsuleLoading(false);
    }
  }

//* Update My capsule Store which is not sent to anyone
  Stream<List<CapsuleModel>> getUserCapsuleStream() {
    CollectionReference reference =
        _firebaseFirestore.collection("Users_Capsules");

    String? currentUserId = _userController.getUser?.uid;
    if (currentUserId == null) return const Stream.empty();

    return reference
        .where('creatorId', isEqualTo: currentUserId)
        .snapshots() // ✅ Real-time updates
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) =>
                CapsuleModel.fromJson(doc.data() as Map<String, dynamic>))
            .where(
                (capsule) => capsule.recipients.isEmpty) // ✅ Filter condition
            .toList());
  }

//* Update My capsule
  Future<void> editCapsule(Map<String, dynamic> updateData) async {
    String? creatorId = _userController.getUser?.uid;

    if (creatorId == null) return;

    DateTime now = DateTime.now();
    updateData['updatedAt'] = now.toIso8601String();
    isCapsuleLoading(true);
    try {
      DocumentSnapshot capsuleDoc = await _firebaseFirestore
          .collection("Users_Capsules")
          .doc(updateData['capsuleId'])
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
          .doc(updateData['capsuleId'])
          .update(updateData);

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

//* Delete MY capsule
  void deleteCapsule(
      {required String capsuleId, required String mediaId}) async {
    String? creatorId = _userController.getUser?.uid;
    if (creatorId == null) return;

    try {
      isCapsuleDeleting(true);

      await Future.wait([
        FirebaseFirestore.instance
            .collection("Users_Capsules")
            .doc(capsuleId)
            .delete(),
        cloudFirestore.deleteFileFromCloud(
            filePath: "capsule_media",
            userId: creatorId,
            isProfile: false,
            mediaId: mediaId)
      ]);

      Get.back();
      appBar(text: "Capsule deleted Successfully");
    } catch (e) {
      Vx.log("Error while deleting Capsule : $e");
    } finally {
      isCapsuleDeleting(false);
    }
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

//* Get  My Sent Capusles Stream
  void listenToMySentCapsules() {
    String? creatorId = _userController.getUser?.uid;
    if (creatorId == null) return;

    try {
      _firebaseFirestore
          .collection('Users_Capsules')
          .where('creatorId', isEqualTo: creatorId)
          .snapshots() // Real-time updates
          .listen((capsuleSnap) async {
        isMyCapsuleSentLoading(true);

        if (capsuleSnap.docs.isEmpty) {
          mySentCapsules.clear();
          capsuleRecipientsMap.clear();
          return;
        }

        List<CapsuleModel> capsules = [];
        Map<String, List<UserModel>> tempRecipientsMap = {};

        for (var doc in capsuleSnap.docs) {
          CapsuleModel capsule = CapsuleModel.fromJson(doc.data());
          if (capsule.recipients.isNotEmpty) {
            List<String> recipientIds = capsule.recipients
                .map((recipient) => recipient.recipientId)
                .toList();
            List<UserModel> recipients = await _fetchUsersByIds(recipientIds);

            capsules.add(capsule);
            tempRecipientsMap[capsule.capsuleId] = recipients;
          }
        }

        mySentCapsules.assignAll(capsules);
        capsuleRecipientsMap.assignAll(tempRecipientsMap);
        isMyCapsuleSentLoading(false);
      });
    } catch (e) {
      Vx.log("Error in listenToMySentCapsules: $e");
    } finally {
      isMyCapsuleSentLoading(false);
    }
  }

//* Get sent date by capsule id

  Future<DateTime?> getSentDateByCapsuleId({required String capsuleId}) async {
    try {
      DocumentSnapshot querySnapshot = await _firebaseFirestore
          .collection("SharedCapsules")
          .where('capsuleId', isEqualTo: capsuleId)
          .limit(1) // Ensures only one document is fetched
          .get()
          .then((snapshot) => snapshot.docs.first); // Get the first document

      DateTime shareDate = DateTime.parse(querySnapshot['shareDate']);

      return shareDate;
    } catch (e) {
      Vx.log("Error in getSentDateByCapsuleId $e");
      return null;
    }
  }
}
