import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/widgets/app_button.dart';
import 'package:future_capsule/screens/create_capsule/toggle.dart';
import 'package:intl/intl.dart';


class PreviewCapsule extends StatefulWidget {
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

  @override
  State<PreviewCapsule> createState() => _PreviewCapsuleState();
}

class _PreviewCapsuleState extends State<PreviewCapsule> {

  late int hour12;
  late int hour24;
  late int date;

  late String year;
  late String min;
  late String period;
  late String month;
  late String weekDay;

  @override
  void initState() {
   
    DateTime selectedDateTime = widget.dateTime;
    period = DateFormat('a').format(selectedDateTime);
    month = DateFormat('MMMM').format(selectedDateTime);
    year = selectedDateTime.year.toString();
    weekDay = DateFormat('EEEE').format(selectedDateTime);
    period = DateFormat('a').format(selectedDateTime);
    min = selectedDateTime.minute.toString().padLeft(2, "0");
    hour24 = selectedDateTime.hour;
    hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    date = selectedDateTime.day;
    super.initState();
  }

  @override
  void dispose() {
    print("=================================dispose");// TODO: implement dispose
    super.dispose();
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              " Name",
              style: TextStyle(fontSize: 18),
            ),
            TextFormField(
              readOnly: true,
              initialValue: widget.capsuleName,
              decoration: InputDecoration(
                hintText: "Write Capsule Name",
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
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border:
                      Border.all(color: AppColors.kWarmCoralColor, width: 2),
                ),
                child: Stack(alignment: AlignmentDirectional.center, children: [
                  if (widget.file != null) Image.memory(widget.file!),
                  if (widget.isCapsulePrivate)
                    SizedBox(
                      child: Container(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: AppColors.kTealGreenColor07),
                        child: Icon(
                          Icons.lock,
                          size: 50,
                          color: AppColors.kWarmCoralColor,
                        ),
                      ),
                    ),
                ]),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              " Description",
              style: TextStyle(fontSize: 18),
            ),
            TextFormField(
              maxLines: 5,
              minLines: 1,
              readOnly: true,
              keyboardType: TextInputType.multiline,
              initialValue: widget.capsuleDescription,
              decoration: InputDecoration(
                hintText: "Decribe capsule",
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
            const SizedBox(height: 30),
            SizedBox(
              height: 180,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Selected Future date",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.kPrimaryTextColor),
                      ),
                      const Spacer(),
                      Stack(children: [
                        Container(
                          height: 150,
                          width: 150,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 4),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red // Darker shade
                              ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '$hour12:$min', // Main time
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.kWhiteColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' $period', // Small AM/PM
                                        style: TextStyle(
                                          fontSize: 14, // Smaller font size
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.kWhiteColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$date $month $year, \n $weekDay',
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
                        ),
                        if (widget.isTimePrivate)
                          Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.kWarmCoralColor06),
                              child: Icon(
                                Icons.lock,
                                size: 38,
                                color: AppColors.kWhiteColor,
                              ))
                      ]),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Is Capsule private?",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.kPrimaryTextColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      AnimatedToggle(
                        isToggled: widget.isCapsulePrivate,
                        onIcon: Icons.lock,
                        offIcon: Icons.lock_open,
                      ),
                      const Spacer(),
                      Text(
                        "Want Time private?",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.kPrimaryTextColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      AnimatedToggle(
                        isToggled: widget.isTimePrivate,
                        onIcon: Icons.check,
                        offIcon: Icons.close,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      radius: 24,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        constraints: const BoxConstraints(minWidth: 150),
                        child: Center(
                          child: Text(
                            "Edit",
                            style: TextStyle(
                              color: AppColors.kWhiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )),
                  const Spacer(),
                  AppButton(
                      onPressed: () {},
                      radius: 24,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        constraints: const BoxConstraints(minWidth: 150),
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
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }

  
}
