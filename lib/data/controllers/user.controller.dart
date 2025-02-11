import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:future_capsule/data/models/settings_model.dart';
import 'package:future_capsule/data/models/user_model.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class UserController extends GetxController {
  static final UserController _instance = UserController._internal();
  UserController._internal();

  factory UserController() => _instance;

  // Initailization
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  //Observable Current User
  var currentUser = Rxn<User>();

  set setUser(User? user) {
    currentUser.value = user;
  }

  User? get getUser => currentUser.value;

Future<void> createNewUser(Map<String, dynamic> newUser) async {
    User? user = currentUser.value;
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
          .collection("Future_Capsule_Users")
          .doc(user.uid)
          .set(userData.toJson());
    } catch (e) {
      Vx.log("Failed to add user profile: $e");
    }
  }


   Stream<UserModel?> getUserStream(String userId) {
    return _firebaseFirestore
        .collection("Future_Capsule_Users")
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        if (snapshot.data() != null) {
          return UserModel.fromJson(
              snapshot.data()!); // Return the user data as a map
        }
      } else {
        return null; // Return null if the document doesn't exist
      }
      return null;
    });
  }

   void updateUserData(Map<String, dynamic> updatedData) async {
    if (currentUser.value?.uid == null) return;
    DateTime now = DateTime.now();

    updatedData['updatedAt'] = now.toIso8601String();

    try {
      await _firebaseFirestore
          .collection("Future_Capsule_Users")
          .doc(currentUser.value?.uid)
          .update(updatedData)
          .then((value) => Vx.log("User data updated successfully."));
    } catch (e) {
      Vx.log("Failed to update user data: $e");

      if (e.toString().contains('NOT_FOUND')) {
        Vx.log("Document not found, creating a new one.");
        await _firebaseFirestore
            .collection("Future_Capsule_Users")
            .doc(currentUser.value?.uid)
            .set(updatedData);
      }
    }
  }
}
