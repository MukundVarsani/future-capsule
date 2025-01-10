import 'package:firebase_auth/firebase_auth.dart';


class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  static final  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseAuthService._internal();

  factory FirebaseAuthService() {
    return _instance;
  }

 static User? getCurrentUser() {
    try {
      return _firebaseAuth.currentUser;
    } catch (e) {
      print("Error while getting current User=============== $e");
      return null;
    }
  }

  Future<User?> createNewUser({
    required String userEmail,
    required String userPassword,
  }) async {
    try {
      final UserCredential credentials =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      final User? user = credentials.user;
      if (user == null) return null;
      return user;
    } on FirebaseAuthException catch (e) {
      String error = e.code;

      if (error == "email-already-in-use") {
        throw FirebaseAuthException(
            code: "401", message: "Email already registered");
      } else {
        throw FirebaseAuthException(
            code: "404", message: "Internal Server Error");
      }
    }
  }

  Future<void> sendEmailVerification(User user) async {
    try {
      await user.sendEmailVerification();
    } catch (e) {
      throw Exception('Unable to send verification email.');
    }
  }

  Future<void> login({
    required String userEmail,
    required String userPassword,
  }) async {
    try {
      final UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: userEmail, password: userPassword);

      final User? user = credential.user;
      if (user == null) return;
    } on FirebaseAuthException catch (e) {
      String error = e.code;
      if (error == "invalid-credential") {
        throw FirebaseAuthException(
            code: "402", message: "Invalid Credintials");
      } else {
        throw FirebaseAuthException(
            code: "404", message: "Internal Server Error");
      }
    }
  }

  Future<void> forgetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception("Email is not registered");
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
