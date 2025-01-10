import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:future_capsule/config/firebase_auth_service.dart';
import 'package:future_capsule/data/models/settings_model.dart';
import 'package:future_capsule/data/models/user_model.dart';
import 'package:velocity_x/velocity_x.dart';

class UserService {
  static final UserService _instance = UserService._internal();

  UserService._internal();

  factory UserService() => _instance;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;


  void createNewUser(Map <String, dynamic> newUser) async {
    User? user = FirebaseAuthService.getCurrentUser();
    if (user == null) return;

    DateTime now = DateTime.now();

    UserModel userData = UserModel(
      userId: user.uid,
      bio: newUser['bio'],
      email: user.email.toString(),
      name: newUser['name'],
      profilePicture: "",
      settings: SettingsModel(
        language: "en",
        notificationsEnabled: false,
        theme: "Dark",
      ),
      updatedAt: now,
      createdAt: now,
    );

    try {
      await _firebaseFirestore
          .collection("AllUsers")
          .doc(user.uid)
          .set(userData.toJson());
    } catch (e) {
      Vx.log("Failed to add user profile: $e");
    }
  }

  void updateUserData(Map<String, dynamic> updatedData) async {
    User? user = FirebaseAuthService.getCurrentUser();
    if (user == null) return;
    DateTime now = DateTime.now();

    updatedData['updatedAt'] = now.toIso8601String();

    try {
      await _firebaseFirestore
          .collection("AllUsers")
          .doc(user.uid)
          .update(updatedData)
          .then((value) => Vx.log("User data updated successfully."));
    } catch (e) {
      Vx.log("Failed to update user data: $e");

      if (e.toString().contains('NOT_FOUND')) {
        Vx.log("Document not found, creating a new one.");
        await _firebaseFirestore
            .collection("AllUsers")
            .doc(user.uid)
            .set(updatedData);
      }
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      User? user = FirebaseAuthService.getCurrentUser();
      if (user == null) return null;

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('AllUsers')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        Vx.log("User not found with document ID");
        return null;
      }
    } catch (e) {
      Vx.log("Error while getting user data");
      return null;
    }
  }
}
