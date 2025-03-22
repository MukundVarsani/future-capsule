import 'dart:io';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/widgets/app_button.dart';
import 'package:future_capsule/core/widgets/snack_bar.dart';
import 'package:future_capsule/data/controllers/capsule.controller.dart';
import 'package:future_capsule/data/services/firebase_storage.dart';
import 'package:future_capsule/screens/create_capsule/toggle.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:uuid/uuid.dart';
import 'package:velocity_x/velocity_x.dart';

class PreviewCapsule extends StatefulWidget {
  const PreviewCapsule({
    super.key,
    required this.capsuleName,
    required this.capsuleDescription,
    required this.isCapsulePrivate,
    required this.isTimePrivate,
    required this.isImageFile,
    required this.isVideoFile,
    required this.openDateTime,
    required this.file,
    required this.xFile,
    this.media,
  });

  final String capsuleName;
  final String capsuleDescription;
  final bool isCapsulePrivate;
  final bool isTimePrivate;
  final bool isImageFile;
  final bool isVideoFile;
  final DateTime openDateTime;
  final File? file;
  final XFile? xFile;
  final String? media;

  @override
  State<PreviewCapsule> createState() => _PreviewCapsuleState();
}

class _PreviewCapsuleState extends State<PreviewCapsule> {
  late Duration openDate;
  final CapsuleController _capsuleController = Get.put(CapsuleController());
  late FirebaseStore _firebaseStore;
  String uid = const Uuid().v4();

  @override
  void initState() {
    _firebaseStore = FirebaseStore();
    openDate = widget.openDateTime.difference(DateTime.now());

    super.initState();
  }

  Future<String?> uploadCapsuleFile() async {
    if (widget.xFile == null) return null;
    File mediaFile = File(widget.xFile!.path);
    return await _firebaseStore.uploadImageToCloud(
      filePath: "capsule_media",
      file: mediaFile,
      mediaId: uid,
      isProfile: false,
      fileName: "$uid-data",
    );
  }

  Future<String?> uploadThumbNailImage() async {
    if (widget.file == null) return null;
    return await _firebaseStore.uploadImageToCloud(
        filePath: "capsule_media",
        file: widget.file!,
        isProfile: false,
        mediaId: uid,
        fileName: "thumbnail");
  }

  String getExtensionType() {
    if (widget.xFile == null) return "null";
    String extension = widget.xFile!.path.split('.').last.toLowerCase();

    const Map<String, String> mimeTypes = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'bmp': 'image/bmp',
      'webp': 'image/webp',
      'pdf': 'application/pdf',
      'txt': 'text/plain',
      'html': 'text/html',
      'json': 'application/json',
      'mp3': 'audio/mpeg',
      'wav': 'audio/wav',
      'mp4': 'video/mp4',
      'avi': 'video/x-msvideo',
      'mov': 'video/quicktime',
      'zip': 'application/zip',
      'rar': 'application/x-rar-compressed',
    };
    return mimeTypes[extension] ?? 'application/octet-stream';
  }

  void saveCapsule() async {
    String? mediaURL;
    String? thumbnailUrl;

    try {
      _capsuleController.isCapsuleLoading(true);

      if (widget.isVideoFile) {
        List<String?> result = await Future.wait([
          uploadThumbNailImage(),
          uploadCapsuleFile(),
        ]);
        thumbnailUrl = result[0];
        mediaURL = result[1];
      } else {
        mediaURL = await uploadCapsuleFile();
      }

      String type = getExtensionType();

      _capsuleController.createCapsule({
        "title": widget.capsuleName,
        "type": type,
        "description": widget.capsuleDescription,
        "mediaURL": mediaURL,
        "thumbnail": thumbnailUrl,
        "openingDate": widget.openDateTime,
        "isTimePrivate": widget.isTimePrivate,
        "isCapsulePrivate": widget.isCapsulePrivate,
      });

      appBar(text: "Future Capsule has been created");
      Navigator.of(context).pop("result");
    } catch (e) {
      Vx.log("Error in saveCapsule: $e");
    } finally {
      _capsuleController.isCapsuleLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dDeepBackground,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.kWhiteColor,
          ),
        ),
        backgroundColor: AppColors.dDeepBackground,
        title: const Text(
          "Craft a Future Capsule",
          style: TextStyle(
              color: AppColors.dNeonCyan, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          const SizedBox(height: 20),
          _buildTitleField(widget.capsuleName),
          const SizedBox(height: 10),
          _buildFilePreview(widget.file, widget.isCapsulePrivate),
          const SizedBox(height: 10),
          _buildDescriptionField(widget.capsuleDescription),
          const SizedBox(height: 30),
          _buildDateTimePreview(),
          const SizedBox(height: 24),
          _privacyBuilder(),
          const SizedBox(height: 24),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildTitleField(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Title",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.dActiveColorSecondary),
        ),
        const SizedBox(
          height: 6,
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(10, 15, 31, 1), // Background color
            borderRadius: BorderRadius.circular(12), // Rounded corners
            boxShadow: const [
              BoxShadow(
                  color: Color.fromRGBO(0, 255, 255, 0.5), // Glow effect
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: Offset(1, 2)),
            ],
          ),
          child: TextFormField(
            style: const TextStyle(color: Colors.white), // Text color
            cursorColor: Colors.blueAccent,
            readOnly: true,
            initialValue: title,
            decoration: const InputDecoration(
              hintText: "Capsule title",
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none, // No border
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  Widget _buildFilePreview(File? fileBytes, bool isCapsulePrivate) {
    return Container(
      constraints: const BoxConstraints(minHeight: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColors.dUserTileBackground,
        boxShadow: const [
          BoxShadow(
              color: Color.fromRGBO(0, 255, 255, 0.5), // Glow effect
              blurRadius: 8,
              spreadRadius: 1,
              offset: Offset(1, 2)),
        ],
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          if (widget.media != null)
            Image.network(
              widget.media!,
              height: 200,
              filterQuality: FilterQuality.high,
              fit: BoxFit.fill,
            ),
          if (fileBytes != null)
            Image.file(
              fileBytes,
              height: 200,
              filterQuality: FilterQuality.high,
              fit: BoxFit.fill,
            ),

            Container(
              constraints: const BoxConstraints(minHeight: 200),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: const Color.fromRGBO(26, 189, 156, 0.65),
              ),
              child: const Icon(
                Icons.lock,
                size: 50,
                color: Color.fromRGBO(142, 68, 173, 1),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDescriptionField(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 4,
        ),
        const Text(
          "Description",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.dActiveColorSecondary,
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(10, 15, 31, 1),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromRGBO(0, 255, 255, 0.5), // Glow effect
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: Offset(1, 2)),
              ]),
          child: TextFormField(
            style: const TextStyle(color: Colors.white), // Text color
            cursorColor: Colors.blueAccent, // Cursor color
            maxLines: 4,
            minLines: 3,
            readOnly: true,
            initialValue: description,
            decoration: const InputDecoration(
              hintText: "Decribe capsule",
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none, // No border
            ),
          ),
        ),
        const SizedBox(
          height: 6,
        ),
      ],
    );
  }

  Widget _buildDateTimePreview() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Revealing Your Capsule In",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.dActiveColorSecondary),
            ),
            const SizedBox(
              height: 12,
            ),
            SlideCountdownSeparated(
              duration: openDate,
              slideDirection: SlideDirection.down,
              separatorStyle: const TextStyle(
                color: AppColors.dNeonCyan,
                fontSize: 20,
              ),
              separatorType: SeparatorType.symbol,
              separator: ':',
              decoration: BoxDecoration(
                  color: AppColors.dUserTileBackground,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 255, 255, 0.5), // Glow effect
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: Offset(1, 2),
                    ),
                  ]),
              padding: const EdgeInsets.all(8),
              separatorPadding: const EdgeInsets.all(6),
              style: const TextStyle(
                color: AppColors.kWhiteColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              showZeroValue: true,
              slideAnimationCurve: Curves.bounceInOut,
            ),
          ],
        ),
      ],
    );
  }

  Widget _privacyBuilder() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Capsule Privacy",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kWhiteColor),
            ),
            const Spacer(),
            AnimatedToggle(
              isToggled: widget.isCapsulePrivate,
              onIcon: Icons.lock,
              offIcon: Icons.lock_open,
              backgroundColor: const Color.fromRGBO(26, 189, 156, 1),
            )
          ],
        ),
        const SizedBox(
          height: 14,
        ),
        Row(
          children: [
            const Text(
              "Time Privacy",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kWhiteColor),
            ),
            const Spacer(),
            AnimatedToggle(
              isToggled: widget.isTimePrivate,
              onIcon: Icons.check,
              offIcon: Icons.close,
              backgroundColor: const Color.fromRGBO(142, 68, 173, 1),
            )
          ],
        )
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          constraints: const BoxConstraints(
              maxWidth: 150, minWidth: 70, maxHeight: 55, minHeight: 50),
          child: AppButton(
            backgroundColor: const Color.fromRGBO(53, 153, 219, 1),
            onPressed: () => Navigator.of(context).pop(),
            radius: 24,
            child: const Center(
              child: Text(
                "Edit",
                style: TextStyle(
                  color: AppColors.kWhiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        Container(
          constraints: const BoxConstraints(
              maxWidth: 150, minWidth: 70, maxHeight: 55, minHeight: 50),
          child: AppButton(
            backgroundColor: const Color.fromRGBO(53, 153, 219, 1),
            onPressed: saveCapsule,
            radius: 24,
            child: Center(
              child: Obx(
                () => _capsuleController.isCapsuleLoading.value
                    ? const CircularProgressIndicator.adaptive(
                        valueColor:
                            AlwaysStoppedAnimation(AppColors.kWhiteColor),
                      )
                    : const Text(
                        "Create",
                        style: TextStyle(
                          color: AppColors.kWhiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
