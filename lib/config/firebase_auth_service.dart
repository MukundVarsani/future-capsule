import 'package:firebase_auth/firebase_auth.dart';
import 'package:future_capsule/screens/auth/sign_up/sign_up_screen.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseAuthService._internal();

  factory FirebaseAuthService() {
    return _instance;
  }

  static User? getCurrentUser() {
    try {
      return _firebaseAuth.currentUser;
    } catch (e) {
      Vx.log("Error while getting current User=============== $e");
      return null;
    }
  }

  Future<void> sendEmailVerification(User user) async {
    try {
      await user.sendEmailVerification();
    } catch (e) {
      Get.to(const SignUpScreen());
      throw Exception('Unable to send verification email.');
    }
  }

  Future<void> forgetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      Vx.log("Error while forgetting password : $e ");
      throw "Email is not registered";
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw ("Error while siging out user");
    }
  }
}
