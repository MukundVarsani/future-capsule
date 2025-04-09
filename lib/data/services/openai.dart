import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

class Openai {
  static String ipAddress = "192.168.0.112";
  Future<Map<String, dynamic>?> generateCapsuleContent(
      {required File image, String? userPrompt}) async {
    final bytes = image.readAsBytesSync();
    String img64 = base64Encode(bytes);

    var url = Uri.http('$ipAddress:3001', '/generate-capsule');
    try {
      var response = await http.post(url,
          body: {'base64Image': img64, "userPrompt": userPrompt ?? ""});

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (jsonData['success']) {
        return jsonData['content'];
      }
    } catch (e) {
      Vx.log("Error in generateCapsuleContent : $e");
    }
    return null;
  }

  Future<Map<String, dynamic>?> getHintFromAI({required String imgURL}) async {
    http.Response response = await http.get(Uri.parse(imgURL));

    final bytes = response.bodyBytes;
    String img64 = base64Encode(bytes);

    var url = Uri.http('$ipAddress:3001', '/hint-capsule');
    try {
      var response = await http.post(url, body: {
        'base64Image': img64,
      });

      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (jsonData['success']) {
        return jsonData['content'];
      }
    } catch (e) {
      Vx.log("Error in generateCapsuleContent : $e");
    }
    return null;
  }
}
