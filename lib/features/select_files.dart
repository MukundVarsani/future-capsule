import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/data/services/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class SelectFiles {
  late ImagePicker _imagePicker;
  final FirebaseStore _firebaseStore = FirebaseStore();
  SelectFiles() {
    _imagePicker = ImagePicker();
  }

  Future<XFile?> selectImage(
      {ImageSource imageSource = ImageSource.gallery}) async {
    try {
      return await _imagePicker.pickImage(
          source: imageSource, imageQuality: 75);
    } catch (e) {
      debugPrint("Error while getting Image File : $e");
      return null;
    }
  }

  Future<XFile?> selectVideo(
      {ImageSource imageSource = ImageSource.gallery}) async {
    try {
      return await _imagePicker.pickVideo(
        maxDuration: const Duration(seconds: 30),
        source: imageSource,
      );
    } catch (e) {
      debugPrint("Error while getting Video File : $e");
      return null;
    }
  }

  Future<XFile?> selectOtherMedia(
      {ImageSource imageSource = ImageSource.gallery}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['pdf', 'doc', 'docx'],
        type: FileType.custom,
      );

      if (result == null) return null;

      File file = File(result.files.single.path!);

      await _firebaseStore.uploadImageToCloud(
        filePath: "capsule_media",
        file: file,
        mediaId: "Test_id",
        isProfile: false,
        fileName: "Test_id-data",
      );

      Vx.log("Upload successfull");
      return result.xFiles.single;
    } catch (e) {
      debugPrint("Error while getting Video File : $e");
      return null;
    }
  }
}
