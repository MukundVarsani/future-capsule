import 'dart:io';
// import 'dart:typed_data';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseStore {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadImageToCloud(
      {required String name, required File file}) async {
    try {
      // Reference with file name included
      // User? user = FirebaseAuth.instance.currentUser;

      
      Reference ref =
          _firebaseStorage.ref().child("childName").child(name);

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
}
