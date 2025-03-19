import 'dart:io';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/core/widgets/app_button.dart';
import 'package:future_capsule/core/widgets/snack_bar.dart';
import 'package:future_capsule/data/controllers/capsule.controller.dart';
import 'package:future_capsule/data/models/capsule_modal.dart';
import 'package:future_capsule/features/compress_file.dart';
import 'package:future_capsule/features/select_files.dart';
import 'package:future_capsule/screens/create_capsule/custom_picker.dart';
import 'package:future_capsule/screens/create_capsule/toggle.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_player/video_player.dart';
import 'package:slide_countdown/slide_countdown.dart';

class EditCapsuleScreen extends StatefulWidget {
  const EditCapsuleScreen(
      {super.key, required this.capsuleModel, this.controller});

  final CapsuleModel capsuleModel;
  final VideoPlayerController? controller;

  @override
  State<EditCapsuleScreen> createState() => _CreateCapsuleScreenState();
}

class _CreateCapsuleScreenState extends State<EditCapsuleScreen> {
  final SelectFiles _files = SelectFiles();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final CapsuleController _capsuleController = Get.put(CapsuleController());
  late final CompressFile _compressFile;
  VideoPlayerController? _controller;

  // File? _file;
  XFile? xFile;
  String? media;

  late Duration openDate;
  DateTime? _selectedDate;

  bool isCapsuleToggled = true;
  bool isTimeToggled = true;
  bool isMediaLoading = false;

  bool isImageFile = false;
  bool isVideoFile = false;
  bool isOtherFile = false;

  
  bool isTitleFocused = false;
  bool isDesFocused = false;

  Future<void> _selectVideo(BuildContext context) async {
    xFile = await _files.selectVideo();
    if (xFile == null) return;
    Navigator.of(context).pop();

    File? thumbnailFile =
        await CompressFile.getThumbnailfromVideo(filePath: xFile!.path);

    // _file = thumbnailFile;
    if (thumbnailFile == null) return;

    xFile = XFile(thumbnailFile.path);
    if (mounted) {
      setState(() {
        isMediaLoading = true;
      });
    }

    isImageFile = false;
    isVideoFile = true;
    isOtherFile = false;

    _controller?.dispose();
    _controller = VideoPlayerController.file(File(xFile!.path))
      ..initialize().then((_) {});

    await compressVideo(xFile!.path);
    if (mounted) {
      setState(() {
        isMediaLoading = false;
      });
    }
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

    if (mounted) {
      setState(() {
        isMediaLoading = true;
        isImageFile = true;
        isVideoFile = false;
        isOtherFile = false;
        isMediaLoading = false;
      });
    }

    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _resetData() {
    titleController.clear();
    descriptionController.clear();
    // _file = null;
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

  void _updateCapsule() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (titleController.text.isEmpty) {
      appSnackBar(context: context, text: "Capsule title is required");
      return;
    }

    if (xFile == null && media == null) {
      // if (_file == null && xFile == null && media == null) {
      appSnackBar(context: context, text: "Capsule file is required");
      return;
    }

    Map<String, dynamic> updatedData = {
      "capsule_Id": widget.capsuleModel.capsuleId,
      "title": titleController.text,
      'description': descriptionController.text,
      'openingDate': _selectedDate?.toIso8601String() ??
          widget.capsuleModel.openingDate.toIso8601String(),
      'privacy': {
        "isCapsulePrivate": isCapsuleToggled,
        'isTimePrivate': isTimeToggled,
      }
    };
    _capsuleController.editCapsule(updatedData);
  }

  @override
  void initState() {
    _compressFile = CompressFile();
    titleController.text = widget.capsuleModel.title;
    media = widget.capsuleModel.media[0].url;
    descriptionController.text = widget.capsuleModel.description ?? "";
    openDate = widget.capsuleModel.openingDate.difference(DateTime.now());
    isCapsuleToggled = widget.capsuleModel.privacy.isCapsulePrivate;
    isTimeToggled = widget.capsuleModel.privacy.isTimePrivate;

    // Vx.log("Opendate : $openDate");
    // Vx.log(widget.capsuleModel.openingDate);

    if (widget.capsuleModel.media[0].type.contains("video")) {
      isImageFile = false;
      isVideoFile = true;
      _controller = widget.controller;
    } else {
      isImageFile = true;
      isVideoFile = false;
    }

    super.initState();
  }

  @override
  void dispose() {
    _compressFile.dispose();
    descriptionController.dispose();
    titleController.dispose();
    _resetData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dDeepBackground,
      appBar: AppBar(
        backgroundColor: AppColors.dDeepBackground,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.kWhiteColor,
            )),
        title: const Text(
          "Edit a Future Capsule",
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
                  color: AppColors.dUserTileBackground,
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromRGBO(0, 255, 255, 0.5), // Glow effect
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: Offset(1, 2)),
                  ],
                ),
                child: Stack(alignment: AlignmentDirectional.center, children: [
                  _buildMediaPreview(),
                  if (isMediaLoading)
                    const Center(
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    //^ Step 1: Get the current date and time
    DateTime now = DateTime.now();

    DateTime oneMonthLater = now.add(const Duration(days: 30));
    //^ Step 2: Show date picker
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
              textTheme: const TextTheme(
                  bodyMedium: TextStyle(color: AppColors.kTealGreenColor)),
              primaryTextTheme: const TextTheme(
                  headlineLarge: TextStyle(color: AppColors.kTealGreenColor)),
              cardColor: AppColors.kTealGreenColor,
              canvasColor: AppColors.kTealGreenColor,
            ),
            child: child!,
          );

          // Allow selecting up to one year ahead
        });

    FocusManager.instance.primaryFocus?.unfocus();
    if (pickedDate != null) {
      //^ Step 3: Show time picker after selecting the date
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
            hour: now.hour, minute: now.minute), // Set current time as default
      );
      if (pickedTime != null) {
        //^ Step 4: Combine selected date and time

        _selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        if (_selectedDate == null) return;

        //^ Step 5: Check if the selected DateTime is in the future
        if (_selectedDate!.isAfter(now)) {
          openDate = _selectedDate!.difference(now);

          if (mounted) setState(() {});
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
            decoration: BoxDecoration(
                color: AppColors.dUserTileBackground,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Select File",
                  style: TextStyle(
                    color: AppColors.kWhiteColor,
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
                      icon: Icons.camera_alt_rounded ,
                      label: "Image",
                      onTap: () => _selectImage(context),
                    ),
                    CustomPicker(
                      icon: Icons.videocam,
                      label: "Video",
                      onTap: () => _selectVideo(context),
                    ),
                    CustomPicker(
                      icon: Icons.file_present,
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
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.dActiveColorSecondary),
        ),
        const SizedBox(
          height: 6,
        ),
        FocusScope(
          child: Focus(
            onFocusChange: (hasFocus) {
              setState(() {
                isTitleFocused = hasFocus;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(10, 15, 31, 1), // Background color
                borderRadius: BorderRadius.circular(12), // Rounded corners
                boxShadow: isTitleFocused
                    ? const [
                        BoxShadow(
                            color:
                                Color.fromRGBO(0, 255, 255, 0.5), // Glow effect
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: Offset(1, 2)),
                      ]
                    : [],
              ),
              child: TextFormField(
                style: const TextStyle(color: Colors.white), // Text color
                cursorColor: Colors.blueAccent,
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Capsule title",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none, // No border
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 4,
        ),
        const Text(
          " Description",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.dActiveColorSecondary,
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        FocusScope(
          child: Focus(
            onFocusChange: (hasFocus) {
              setState(() {
                isDesFocused = hasFocus;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(10, 15, 31, 1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: isDesFocused
                    ? const [
                        BoxShadow(
                            color:
                                Color.fromRGBO(0, 255, 255, 0.5), // Glow effect
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: Offset(1, 2)),
                      ]
                    : [],
              ),
              child: TextFormField(
                style: const TextStyle(color: Colors.white), // Text color
                cursorColor: Colors.blueAccent, // Cursor color
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: "Decribe capsule",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none, // No border
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaPreview() {
    //* If file media is loading
    if (isMediaLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation(AppColors.kWarmCoralColor),
        ),
      );
    }

    //* If image_file and user select new image
    //*
    if (isImageFile && xFile != null) {
      // else if (isImageFile && _file != null) {

      Vx.log("User select Image file");
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(xFile!.path),
            height: 200,
            filterQuality: FilterQuality.high,
            fit: BoxFit.fill,
          ),
        ),
      );
    }
    //* If image_file and has already uploaded to firebase
    else if (isImageFile && media != null) {
      Vx.log("User have Image from cloud");
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            media!,
            height: 200,
            filterQuality: FilterQuality.high,
            fit: BoxFit.fill,
          ),
        ),
      );
    }

    //* If videoFile and User have video OR if user select new video
    //*
    if (isVideoFile &&
        _controller != null &&
        _controller!.value.isInitialized) {
      bool isPlaying = _controller!.value.isPlaying;
      Vx.log("User have Video from cloud or Select from storage");
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
            const Text(
              "Revealing Your Capsule In",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.dActiveColorSecondary),
            ),
            const SizedBox(
              height: 8,
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
                color: AppColors.dNeonCyan,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              showZeroValue: true,
              slideAnimationCurve: Curves.bounceInOut,
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
            backgroundColor: AppColors.kAmberColor,
            child: const Text(
              "Set",
              style: TextStyle(
                  color: AppColors.kWhiteColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 16),
            ),
            onPressed: () => _selectDateTime(context),
          ),
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
            GestureDetector(
                onTap: () {
                  if (mounted) {
                    setState(() {
                      isCapsuleToggled = !isCapsuleToggled;
                    });
                  }
                },
                child: AnimatedToggle(
                  isToggled: isCapsuleToggled,
                  onIcon: Icons.lock,
                  offIcon: Icons.lock_open,
                  backgroundColor: const Color.fromRGBO(26, 189, 156, 1),
                ))
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
            GestureDetector(
                onTap: () {
                  if (mounted) {
                    setState(() {
                      isTimeToggled = !isTimeToggled;
                    });
                  }
                },
                child: AnimatedToggle(
                  isToggled: isTimeToggled,
                  onIcon: Icons.check,
                  offIcon: Icons.close,
                  backgroundColor: const Color.fromRGBO(142, 68, 173, 1),
                ))
          ],
        )
      ],
    );
  }

  Widget _previewButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: AppButton(
          backgroundColor: const Color.fromRGBO(53, 153, 219, 1),
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            if (titleController.text.isEmpty) {
              appSnackBar(context: context, text: "Capsule title is required");
              return;
            }

            if (xFile == null && xFile == null && media == null) {
              // if (_file == null && xFile == null && media == null) {
              appSnackBar(context: context, text: "Capsule file is required");
              return;
            }

            _updateCapsule();
          },
          radius: 24,
          child: Obx(() => _capsuleController.isCapsuleLoading.value
              ? const CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation(AppColors.kWhiteColor),
                )
              : const Text(
                  "Save Capsule",
                  style: TextStyle(
                    color: AppColors.kWhiteColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ))),
    );
  }
}
