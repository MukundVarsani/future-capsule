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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.kWhiteColor,
          ),
        ),
        backgroundColor: AppColors.kWarmCoralColor,
        title: Text(
          "Craft a Future Capsule",
          style: TextStyle(
              color: AppColors.kWhiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
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
      ),
    );
  }

  Widget _buildTitleField(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Title", style: TextStyle(fontSize: 18)),
        TextFormField(
          readOnly: true,
          initialValue: title,
          decoration: InputDecoration(
            hintText: "Capsule title",
            hintStyle: TextStyle(color: AppColors.kLightGreyColor),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColors.kWarmCoralColor, width: 2.0),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilePreview(File? fileBytes, bool isCapsulePrivate) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.kWarmCoralColor, width: 2),
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
          if (isCapsulePrivate)
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: AppColors.kTealGreenColor07,
              ),
              child: Icon(
                Icons.lock,
                size: 50,
                color: AppColors.kWarmCoralColor,
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
        const Text("Description", style: TextStyle(fontSize: 18)),
        TextFormField(
          maxLines: 4,
          minLines: 3,
          readOnly: true,
          initialValue: description,
          decoration: InputDecoration(
            hintText: "Describe capsule",
            hintStyle: TextStyle(color: AppColors.kLightGreyColor),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColors.kWarmCoralColor, width: 2.0),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimePreview() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Revealing Your Capsule In",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kPrimaryTextColor),
            ),
            const SizedBox(
              height: 8,
            ),
            SlideCountdownSeparated(
              duration: openDate,
              slideDirection: SlideDirection.down,
              separatorStyle:
                  TextStyle(color: AppColors.kWarmCoralColor, fontSize: 20),
              separatorType: SeparatorType.symbol,
              separator: ':',
              decoration: BoxDecoration(
                color: AppColors.kWarmCoralColor,
                borderRadius: BorderRadius.circular(8),
              ),
              style: TextStyle(
                color: AppColors.kWhiteColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              showZeroValue: true,
              slideAnimationCurve: Curves.bounceInOut,
              onChanged: (w) {
                // Vx.log(w);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _privacyBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Is Capsule private?",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.kPrimaryTextColor),
            ),
            const SizedBox(
              height: 8,
            ),
            AnimatedToggle(
              isToggled: widget.isCapsulePrivate,
              onIcon: Icons.lock,
              offIcon: Icons.lock_open,
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Want Time private?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.kPrimaryTextColor,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            AnimatedToggle(
              isToggled: widget.isTimePrivate,
              onIcon: Icons.check,
              offIcon: Icons.close,
            ),
          ],
        ),
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
            onPressed: () => Navigator.of(context).pop(),
            radius: 24,
            child: Center(
              child: Text(
                "Edit",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.kWhiteColor,
                ),
              ),
            ),
          ),
        ),
        Container(
          constraints: const BoxConstraints(
              maxWidth: 150, minWidth: 70, maxHeight: 55, minHeight: 50),
          child: AppButton(
            onPressed: saveCapsule,
            radius: 24,
            child: Center(
                child: Obx(() => _capsuleController.isCapsuleLoading.value
                    ? CircularProgressIndicator.adaptive(
                        valueColor:
                            AlwaysStoppedAnimation(AppColors.kWhiteColor),
                      )
                    : Text(
                        "Create",
                        style: TextStyle(
                          color: AppColors.kWhiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ))),
          ),
        ),
      ],
    );
  }
}
