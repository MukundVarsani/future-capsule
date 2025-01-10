import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/config/firebase_auth_service.dart';

class FirebaseStore {
  static final FirebaseStore _instance = FirebaseStore._internal();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  
User? user = FirebaseAuthService.getCurrentUser();

// Private constructor to prevent direct initialization
  FirebaseStore._internal();

  // Public getter for accessing the shared instance
  factory FirebaseStore() {
    return _instance;
  }

  Future<String?> uploadImageToCloud(
      {required String fileName, required File file}) async {
    try {
      if (user == null) return null;

      Reference ref = _firebaseStorage.ref().child(fileName).child(user!.uid);

      // Upload the file data
      final TaskSnapshot snapshot = await ref.putFile(file);

      // Get the download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      debugPrint("Error: $e");
      return null;
    }
  }

  // Future getCloudImage() async {
  //   try {
  //     Reference ref = _firebaseStorage.ref("AllUsers");
  //     ref.getDownloadURL();
  //   } catch (e) {
  //     return;
  //   }
  // }
}
