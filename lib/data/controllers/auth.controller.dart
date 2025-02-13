import 'package:firebase_auth/firebase_auth.dart';
import 'package:future_capsule/core/widgets/snack_bar.dart';
import 'package:future_capsule/data/controllers/user.controller.dart';
import 'package:future_capsule/screens/auth/verification/verification_screen.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  final UserController _userController = Get.put(UserController());
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    _userController.setUser = _firebaseAuth.currentUser; // Set initial value
    _firebaseAuth.authStateChanges().listen((User? user) {
      _userController.setUser = user;
    });
  }

  Future<void> login({
    required String userEmail,
    required String userPassword,
  }) async {
    try {
      isLoading(true);

      final UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: userEmail, password: userPassword);
      final User? user = credential.user;
      if (user == null) return;
      _userController.setUser = user;
    } on FirebaseAuthException catch (e) {
      String error = e.code;
      if (error == "invalid-credential") {
        throw "Invalid Credintials";
      } else {
        throw "Internal Server Error";
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> createNewUser({
    required String userEmail,
    required String userPassword,
    required String userName,
  }) async {
    try {
      isLoading(true);
      final UserCredential credentials =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      final User? newUser = credentials.user;
      if (newUser == null) {
        appBar(text: "Registeration Fail Try again");
        return;
      }
      Map<String, dynamic> user = {"name": userName};

      await _userController.createNewUser(user);

      Get.off(VerificationScreen(verificationEmail: newUser.email ?? ""));
    } on FirebaseAuthException catch (e) {
      String error = e.code;

      if (error == "email-already-in-use") {
        throw "Email already registered";
      } else {
        Vx.log("Error while creating new User :  ${e.toString}");
        throw "Internal Server Error";
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      if (_userController.getUser == null) return;
      await _userController.getUser?.sendEmailVerification();
    } catch (e) {
      throw Exception('Unable to send verification email.');
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      _userController.setUser = null;
    } catch (e) {
      Vx.log("Error while signing out user : $e");
      throw "Sign-out Failed";
    }
  }

  Future<void> forgetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw "Email is not registered";
    }
  }
}
