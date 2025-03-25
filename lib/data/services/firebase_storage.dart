import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:future_capsule/config/firebase_auth_service.dart';
import 'package:velocity_x/velocity_x.dart';

class FirebaseStore {
  static final FirebaseStore _instance = FirebaseStore._internal();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  
  User? user = FirebaseAuthService.getCurrentUser();

  // Private constructor to prevent direct initialization
  FirebaseStore._internal() {
    FirebaseAuth.instance.authStateChanges().listen((User? currentUser) {
      user = currentUser;
    });
  }

  // Public getter for accessing the shared instance
  factory FirebaseStore() {
    return _instance;
  }

  Future<String?> uploadImageToCloud(
      {required String filePath,
      required File file,
      String mediaId = "",
      String fileName = '',
      bool isProfile = true}) async {
    try {
      if (user == null) return null;

      if (!isProfile && fileName.isEmpty) {
        throw ArgumentError.notNull(
            "File Name must be provided when isProfile is set to false.");
      }

      Reference ref = _firebaseStorage
          .ref("Future_capsule")
          .child(filePath)
          .child(user!.uid);

      if (!isProfile) {
        ref = ref.child(mediaId).child(fileName);
      }

      // Upload the file data
      final TaskSnapshot snapshot = await ref.putFile(file);

      // Get the download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      Vx.log("Error in uploadImageToCloud : $e");
      return null;
    }
  }

  Future<void> deleteFileFromCloud({
    required String filePath,
    required String userId,
    required bool isProfile,
    required String mediaId,
  }) async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref("Future_capsule")
          .child(filePath)
          .child(userId);

      if (!isProfile) {
        ref = ref.child(mediaId).child('$mediaId-data');
      }

      await ref.delete();
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        Vx.log("File does not exist at the given path.");
      } else {
        Vx.log("Error deleting file: ${e.message}");
      }
    }
  }
}
