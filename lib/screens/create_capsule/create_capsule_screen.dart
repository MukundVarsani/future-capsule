import 'dart:io';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/core/widgets/app_button.dart';
import 'package:future_capsule/core/widgets/snack_bar.dart';
import 'package:future_capsule/features/compress_file.dart';
import 'package:future_capsule/features/select_files.dart';
import 'package:future_capsule/screens/create_capsule/custom_picker.dart';
import 'package:future_capsule/screens/create_capsule/preview_capsule.dart';
import 'package:future_capsule/screens/create_capsule/toggle.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:video_player/video_player.dart';
import 'package:slide_countdown/slide_countdown.dart';

class CreateCapsuleScreen extends StatefulWidget {
  const CreateCapsuleScreen({super.key});
  @override
  State<CreateCapsuleScreen> createState() => _CreateCapsuleScreenState();
}

class _CreateCapsuleScreenState extends State<CreateCapsuleScreen> {
  final SelectFiles _files = SelectFiles();

  VideoPlayerController? _controller;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late final CompressFile _compressFile;

  File? _file;
  XFile? xFile;

  late Duration openDate;
  DateTime _selectedDate = DateTime.now();

  bool isCapsuleToggled = true;
  bool isTimeToggled = true;
  bool isMediaLoading = false;

  bool isImageFile = false;
  bool isVideoFile = false;
  bool isOtherFile = false;

  Future<void> _selectVideo(BuildContext context) async {
    xFile = await _files.selectVideo();
    if (xFile == null) return;
    Navigator.of(context).pop();

    File? thumbnailFile =
        await CompressFile.getThumbnailfromVideo(filePath: xFile!.path);

    _file = thumbnailFile;
    setState(() {
      isMediaLoading = true;
    });

    isImageFile = false;
    isVideoFile = true;
    isOtherFile = false;

    _controller?.dispose();
    _controller = VideoPlayerController.file(File(xFile!.path))
      ..initialize().then((_) {});

    await compressVideo(xFile!.path);
    setState(() {
      isMediaLoading = false;
    });
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> compressVideo(String path) async {
    File? compressFile = await _compressFile.compressVideo(filePath: path);
    if (compressFile != null) {
      xFile = XFile(compressFile.path);
    }
  }

  Future<void> _selectImage(BuildContext context) async {
    xFile = await _files.selectImage();
    if (xFile == null) return;
    Navigator.of(context).pop();
    setState(() {
      isMediaLoading = true;
    });
    _file = File(xFile!.path);
    
    setState(() {
      isImageFile = true;
      isVideoFile = false;
      isOtherFile = false;
      isMediaLoading = false;
    });
    FocusManager.instance.primaryFocus?.unfocus();
  }


  void _resetData() {
    titleController.clear();
    descriptionController.clear();
    _file = null;
    _controller?.dispose();
    _controller = null;
    isCapsuleToggled = true;
    isTimeToggled = true;
    isMediaLoading = false;
    isImageFile = false;
    isVideoFile = false;
    isOtherFile = false;
    openDate = const Duration(hours: 1);
    _selectedDate = DateTime.now();
  }
  @override
  void initState() {
    openDate = const Duration(hours: 1);
    _compressFile = CompressFile();
    super.initState();
  }

  @override
  void dispose() {
    _compressFile.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            const SizedBox(height: 10),
            _buildTextField(),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _showSelectFileDialodBox,
              child: Container(
                constraints: const BoxConstraints(minHeight: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border:
                      Border.all(color: AppColors.kWarmCoralColor, width: 2),
                ),
                child: Stack(alignment: AlignmentDirectional.center, children: [
                  _buildMediaPreview(),
                  if (isMediaLoading)
                    Center(
                        child: CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.kWarmCoralColor),
                    )),
                  if (!isImageFile && !isVideoFile && !isOtherFile)
                    Positioned(
                      bottom: 20,
                      left: MediaQuery.sizeOf(context).width / 2 - 20,
                      child: const Icon(
                        Icons.upload_outlined,
                        size: 40,
                      ),
                    ),
                ]),
              ),
            ),
            const SizedBox(height: 10),
            _buildDescriptionField(),
            const SizedBox(height: 20),
            _dateAndTimeBuilder(),
            const SizedBox(height: 20),
            _privacyBuilder(),
            const SizedBox(height: 20),
            _previewButton(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }



  Future<void> _selectDateTime(BuildContext context) async {
    // Step 1: Get the current date and time
    DateTime now = DateTime.now();

    DateTime oneMonthLater = now.add(const Duration(days: 30));
    // Step 2: Show date picker
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: now, // Initial date should be today's date
        firstDate: now, // The earliest selectable date is today
        lastDate: oneMonthLater,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            // Apply custom theme to the date picker
            data: ThemeData.light().copyWith(
              primaryColor: Colors.orange, // Change the header color
              buttonTheme:
                  const ButtonThemeData(textTheme: ButtonTextTheme.primary),
              dialogBackgroundColor: Colors
                  .blueGrey[50], // Change the background color of the dialog
              textTheme: TextTheme(
                  bodyMedium: TextStyle(color: AppColors.kTealGreenColor)
                  // bodyText2: TextStyle(color: Colors.black), // Change the text color
                  ),
              primaryTextTheme: TextTheme(
                  headlineLarge: TextStyle(color: AppColors.kTealGreenColor)
                  // headline6: TextStyle(color: Colors.black), // Change the header text color
                  ),
              cardColor: AppColors.kTealGreenColor,
              canvasColor: AppColors.kTealGreenColor,
            ),
            child: child!,
          );

          // Allow selecting up to one year ahead
        });

    FocusManager.instance.primaryFocus?.unfocus();
    if (pickedDate != null) {
      // Step 3: Show time picker after selecting the date
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
            hour: now.hour, minute: now.minute), // Set current time as default
      );
      if (pickedTime != null) {
        // Step 4: Combine selected date and time

        _selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Step 5: Check if the selected DateTime is in the future
        if (_selectedDate.isAfter(now)) {
          openDate = _selectedDate.difference(now);

          setState(() {});
        } else {
          // Step 6: Show error if the selected time is in the past
          appSnackBar(
              context: context, text: "Please select a future date and time!");
        }
      }
    }
  }

  Future<void> _showSelectFileDialodBox() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 200,
            padding:
                const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Select File",
                  style: TextStyle(
                    color: AppColors.kPrimaryTextColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomPicker(
                      icon: Icons.image,
                      label: "Image",
                      onTap: () => _selectImage(context),
                    ),
                    CustomPicker(
                      icon: Icons.video_file,
                      label: "Video",
                      onTap: () => _selectVideo(context),
                    ),
                    CustomPicker(
                      icon: Icons.file_upload,
                      label: "File",
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 30)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          " Title",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextFormField(
          maxLength: 20,
          controller: titleController,
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

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          " Description",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextFormField(
          maxLines: 2,
          controller: descriptionController,
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
        )
      ],
    );
  }

  Widget _buildMediaPreview() {
    if (isMediaLoading) {
      return Center(
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation(AppColors.kWarmCoralColor),
        ),
      );
    }

    if (isImageFile && _file != null) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: 
          
          Image.file(
            _file!,
            height: 200,
            filterQuality: FilterQuality.high,
            fit: BoxFit.fill,
          ),
        ),
      );
    }

    if (isVideoFile &&
        _controller != null &&
        _controller!.value.isInitialized) {
      bool isPlaying = _controller!.value.isPlaying;

      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
          ),
          Center(
            child: IconButton(
              onPressed: () {
                if (_controller == null) return;
                setState(() {
                  if (isPlaying) {
                    _controller!.pause();
                  } else {
                    _controller!.play();
                  }
                });
              },
              icon: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: AppColors.kWarmCoralColor06,
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Center(
      child: SizedBox(
        height: 200,
        child: Image.asset(
          AppImages.openCapsule,
        ),
      ),
    );
  }

  Widget _dateAndTimeBuilder() {
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
              onDone: () {
                Vx.log("Completed");
              },
            ),
          ],
        ),
        const Spacer(),
        ConstrainedBox(
          constraints: const BoxConstraints(
              maxHeight: 55, minHeight: 45, minWidth: 80, maxWidth: 80),
          child: AppButton(
            child: Text(
              "Set",
              style: TextStyle(color: AppColors.kWhiteColor),
            ),
            onPressed: () => _selectDateTime(context),
          ),
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
            GestureDetector(
              onTap: () {
                setState(() {
                  isCapsuleToggled = !isCapsuleToggled;
                });
              },
              child: AnimatedToggle(
                isToggled: isCapsuleToggled,
                onIcon: Icons.lock,
                offIcon: Icons.lock_open,
              ),
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
                  color: AppColors.kPrimaryTextColor),
            ),
            const SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isTimeToggled = !isTimeToggled;
                });
              },
              child: AnimatedToggle(
                isToggled: isTimeToggled,
                onIcon: Icons.check,
                offIcon: Icons.close,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _previewButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: AppButton(
          onPressed: () async {
            if (titleController.text.isEmpty) {
              appSnackBar(context: context, text: "Capsule title is required");
              return;
            }

            if (_file == null && xFile == null) {
              appSnackBar(context: context, text: "Capsule file is required");
              return;
            }

            var result = await PersistentNavBarNavigator.pushDynamicScreen(
              context,
              screen: MaterialPageRoute(
                builder: (context) => PreviewCapsule(
                  capsuleName: titleController.text,
                  capsuleDescription: descriptionController.text,
                  isCapsulePrivate: isCapsuleToggled,
                  isTimePrivate: isTimeToggled,
                  isImageFile: isImageFile,
                  isVideoFile: isVideoFile,
                  openDateTime: _selectedDate,
                  file: _file,
                  xFile: xFile!,
                ),
              ),
              withNavBar: false,
            );

            if (result != null) {
              _resetData();
            }
            FocusManager.instance.primaryFocus?.unfocus();
            if (mounted) setState(() {});
          },
          radius: 24,
          child: Text(
            "Preview Capsule",
            style: TextStyle(
              color: AppColors.kWhiteColor,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          )),
    );
  }
}
