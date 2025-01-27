import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:future_capsule/data/models/capsule_model.dart';
import 'package:future_capsule/data/services/user_service.dart';
import 'package:uuid/uuid.dart';
import 'package:velocity_x/velocity_x.dart';

class CapsuleService {
  static final CapsuleService _instance = CapsuleService._internal();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();
  final  Uuid _uuid = const Uuid();

  CapsuleService._internal();

  factory CapsuleService() => _instance;
                                              
  String _extractMediaIdFromUrl(String url) {
  // Define a regular expression to extract the value
  final regex = RegExp(r'capsule_media%2F[^%]*%2F([^%]*)%2F');
  
  // Match the regex with the input URL
  final match = regex.firstMatch(url);

  // If a match is found, return the extracted value, otherwise return an empty string
  return match != null ? match.group(1) ?? '' : '';
}



  void createCapsule(Map<String, dynamic> capsuleData) async {
    String? creatorId = _userService.userId;

    if (creatorId == null) return;

    DateTime now = DateTime.now();
    String capsuleId = _uuid.v4();
    String mediaId = _extractMediaIdFromUrl(capsuleData['mediaURL']);

    CapsuleModel capsuleModel = CapsuleModel(
      capsuleId: capsuleId,
      creatorId: creatorId,
      title: capsuleData['title'],
      description: capsuleData['description'],
      media: [
        Media(
          thumbnail:capsuleData['thumbnail'] ,
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
    } catch (e) {
      Vx.log("Error while creating capsule: $e");
    }
  }

  Future<List<CapsuleModel>> getUserCreateCapsule(String userId) async {
    try {
      CollectionReference reference =
          _firebaseFirestore.collection("Users_Capsules");

      final querySnapshot =
          await reference.where('creatorId', isEqualTo: userId).get();

      List<CapsuleModel> usersCapsules = querySnapshot.docs.map((doc) {
        return CapsuleModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return usersCapsules;

    } catch (e) {
      Vx.log("Error while getting User Created capsule: $e");
      throw "Error while getting User Created capsule: $e ";
    }
  }
}
