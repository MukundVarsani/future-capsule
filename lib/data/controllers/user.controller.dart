import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:future_capsule/data/models/settings_modal.dart';
import 'package:future_capsule/data/models/user_modal.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class UserController extends GetxController {
  static final UserController _instance = UserController._internal();
  UserController._internal();

  factory UserController() => _instance;

  // Initailization
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //Observable Current User

  final _currentUser = Rxn<User>();
  RxInt userLike = 0.obs;

  set setUser(User? user) {
    _currentUser.value = user;
  }

  User? get getUser => _currentUser.value;

  @override
  void onInit() {
    _currentUser(_firebaseAuth.currentUser);
    super.onInit();
  }

  Future<void> createNewUser(Map<String, dynamic> newUser) async {
    User? user = _currentUser.value;
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
      fcmToken: null,
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
          getUserTotalLikes();
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
    if (_currentUser.value?.uid == null) return;
    DateTime now = DateTime.now();

    updatedData['updatedAt'] = now.toIso8601String();

    try {
      await _firebaseFirestore
          .collection("Future_Capsule_Users")
          .doc(_currentUser.value?.uid)
          .update(updatedData)
          .then((value) => Vx.log("User data updated successfully."));
    } catch (e) {
      Vx.log("Failed to update user data: $e");

      if (e.toString().contains('NOT_FOUND')) {
        Vx.log("Document not found, creating a new one.");
        await _firebaseFirestore
            .collection("Future_Capsule_Users")
            .doc(_currentUser.value?.uid)
            .set(updatedData);
      }
    }
  }

  Future<UserModel?> getUserById({required String userId}) async {
    try {
      DocumentSnapshot doc = await _firebaseFirestore
          .collection('Future_Capsule_Users')
          .doc(userId)
          .get();

      if (!doc.exists) {
        Vx.log("User not found by Id : $userId");
        return null;
      }
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      Vx.log('Error while getting user By id : $e');
      return null;
    }
  }

  Future<void> updateUserHintCount(String userId) async {
    final userRef = FirebaseFirestore.instance
        .collection("Future_Capsule_Users")
        .doc(userId);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(userRef);

        if (!snapshot.exists) {
          throw Exception("User document does not exist.");
        }

        final currentHintCount = snapshot.data()?['hintCount'] ?? 0;
        final updatedHintCount = currentHintCount - 1;

        transaction.update(userRef, {'hintCount': updatedHintCount});
      });
    } catch (e) {
      Vx.log("Error in updateUserHintCount $e");
    }
  }

  void getUserTotalLikes() async {
    if (_currentUser.value == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Users_Capsules')
          .where('creatorId', isEqualTo: _currentUser.value?.uid)
          .get();
      userLike(0);
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final likes = List<Map<String, dynamic>>.from(data['likes'] ?? []);
        userLike.value += likes.length;
      }
    } catch (e) {
      Vx.log("Error in getUserTotalLikes $e");
    }
  }
}
