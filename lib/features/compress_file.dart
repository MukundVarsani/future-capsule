import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_compress/video_compress.dart';

class CompressFile {
  static Future<File?> getThumbnailfromVideo({required String filePath}) async {
    File? file = await VideoCompress.getFileThumbnail(filePath, quality: 50);
    return file;
  }

  Future<File?> compressVideo({required String filePath}) async {
    try {
      MediaInfo? compressedVideo = await VideoCompress.compressVideo(
        filePath,
        quality: VideoQuality.DefaultQuality,
        deleteOrigin: false,
        includeAudio: true,
      );

      if (compressedVideo == null) throw ("File is empty ");

      // Retrieve the size of the compressed video

      final int sizeInBytes = compressedVideo.filesize!;
      final String formattedSize = _formatBytes(sizeInBytes);

      Vx.log("Compressed Video Size: $formattedSize");

      return compressedVideo.file;
    } catch (e) {
      Vx.log("Error while compressing video : $e");
      return null;
    }
  }

  String _formatBytes(int bytes, [int decimalPlaces = 2]) {
    if (bytes <= 0) return "0 Bytes";
    const List<String> units = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    int i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimalPlaces)} ${units[i]}';
  }

  void dispose() {
    VideoCompress.dispose();
  }
}
