import 'dart:io';

import 'package:video_compress/video_compress.dart';

class CompressFile {
  static Future<File?> compressVideo({required String filePath}) async {
    try {
      MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        filePath,
        quality: VideoQuality.DefaultQuality,
        deleteOrigin: false,
        includeAudio: true,
      );

      if (mediaInfo == null) throw ("File is empty ");
      return mediaInfo.file;
    } catch (e) {
      print("Error while compressing video : $e");
      return null;
    }
  }

  static Future<File?> getThumbnailfromVideo({required String filePath}) async {
    File? file = await VideoCompress.getFileThumbnail(filePath, quality: 50);
    return file;
  }
}
