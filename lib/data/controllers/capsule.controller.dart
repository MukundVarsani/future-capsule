import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:future_capsule/core/widgets/snack_bar.dart';
import 'package:future_capsule/data/controllers/user.controller.dart';
import 'package:future_capsule/data/models/capsule_model.dart';
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

  var capsules = <CapsuleModel>[].obs;
  var isCapsuleLoading = false.obs;
  var isCapsuleDeleting = false.obs;

  String _extractMediaIdFromUrl(String url) {
    // Define a regular expression to extract the value
    final regex = RegExp(r'capsule_media%2F[^%]*%2F([^%]*)%2F');

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

  Future getUserCapsule() async {
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
      capsules.value = usersCapsules;
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
}
