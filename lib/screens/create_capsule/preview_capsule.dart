import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/widgets/app_button.dart';
import 'package:future_capsule/screens/create_capsule/toggle.dart';
import 'package:intl/intl.dart';

class PreviewCapsule extends StatelessWidget {
 const PreviewCapsule({
    super.key,
    required this.capsuleName,
    required this.capsuleDescription,
    required this.isCapsulePrivate,
    required this.isTimePrivate,
    required this.isImageFile,
    required this.isVideoFile,
    required this.dateTime,
    required this.file,
  });

  final String capsuleName;
  final String capsuleDescription;
  final bool isCapsulePrivate;
  final bool isTimePrivate;
  final bool isImageFile;
  final bool isVideoFile;
  final DateTime dateTime;
  final Uint8List? file;

  Map<String, String> _formatDateTime(DateTime dateTime) {
    return {
      'period': DateFormat('a').format(dateTime),
      'month': DateFormat('MMMM').format(dateTime),
      'weekDay': DateFormat('EEEE').format(dateTime),
      'year': dateTime.year.toString(),
      'min': dateTime.minute.toString().padLeft(2, "0"),
      'hour12': (dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12).toString(),
      'date': dateTime.day.toString(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatDateTime(dateTime);
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
            _buildTitleField(capsuleName),
            const SizedBox(height: 10),
            _buildFilePreview(file, isCapsulePrivate),
            const SizedBox(height: 10),
            _buildDescriptionField(capsuleDescription),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildDateTimePreview(formattedDate, isTimePrivate),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: _buildPrivacyToggles(),
                ),
              ],
            ),
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

  Widget _buildFilePreview(Uint8List? file, bool isCapsulePrivate) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.kWarmCoralColor, width: 2),
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          if (file != null)
            Image.memory(
              file,
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

  Widget _buildDateTimePreview(
      Map<String, String> dateData, bool isTimePrivate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Future Date",
          style: TextStyle(
              fontWeight: FontWeight.w500, color: AppColors.kPrimaryTextColor),
        ),
        const SizedBox(height: 5),
        Stack(
          children: [
            Container(
              height: 150,
              width: 150,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${dateData['hour12']}:${dateData['min']}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.kWhiteColor,
                          ),
                        ),
                        TextSpan(
                          text: ' ${dateData['period']}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.kWhiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${dateData['date']} ${dateData['month']} ${dateData['year']}, \n ${dateData['weekDay']}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.kWhiteColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (isTimePrivate)
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.kWarmCoralColor06,
                ),
                child: Icon(
                  Icons.lock,
                  size: 38,
                  color: AppColors.kWhiteColor,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrivacyToggles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Is Capsule Private?",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.kPrimaryTextColor,
              ),
            ),
            const SizedBox(height: 5),
            AnimatedToggle(
              isToggled: isCapsulePrivate,
              onIcon: Icons.lock,
              offIcon: Icons.lock_open,
            ),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Want Time Private?",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.kPrimaryTextColor,
              ),
            ),
            const SizedBox(height: 5),
            AnimatedToggle(
              isToggled: isTimePrivate,
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
            onPressed: () {},
            radius: 24,
            child: Center(
              child: Text(
                "Save",
                style: TextStyle(
                  color: AppColors.kWhiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
