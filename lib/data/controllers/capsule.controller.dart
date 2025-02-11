import 'package:get/get.dart';

class CapsuleController extends GetxController {
  static final CapsuleController _instance = CapsuleController._internal();
  CapsuleController._internal();

  factory CapsuleController() => _instance;

    String _extractMediaIdFromUrl(String url) {
    // Define a regular expression to extract the value
    final regex = RegExp(r'capsule_media%2F[^%]*%2F([^%]*)%2F');

    // Match the regex with the input URL
    final match = regex.firstMatch(url);

    // If a match is found, return the extracted value, otherwise return an empty string
    return match != null ? match.group(1) ?? '' : '';
  }

  
}
