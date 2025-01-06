import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectFiles {
  late ImagePicker _imagePicker;

  SelectFiles() {
    _imagePicker = ImagePicker();
  }

  Future<XFile?> selectImage(
      {ImageSource imageSource = ImageSource.gallery}) async {
    try {
      return await _imagePicker.pickImage(
        source: imageSource,
      );
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
      return await _imagePicker.pickMedia();
    } catch (e) {
      debugPrint("Error while getting Video File : $e");
      return null;
    }
  }
}
