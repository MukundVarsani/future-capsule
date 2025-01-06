import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  late FirebaseAuth _firebaseAuth;

  FirebaseService() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  void createNewUser({
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
      if (user == null) return;
      await _sendEmailVerification(user);
      // setcurrentUser = credentials.user!;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific exceptions here.
      debugPrint('FirebaseAuthException: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error during user creation: $e');
      rethrow;
    }
  }

  Future<void> _sendEmailVerification(User user) async {
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
      // setcurrentUser = user;
      // _printCurrentUser("Login");

    } catch (e) {
      debugPrint('Unexpected error during user creation: $e');
      throw ("Error while logging with user");
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
