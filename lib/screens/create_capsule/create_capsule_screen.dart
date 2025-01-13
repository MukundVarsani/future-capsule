import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
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
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class CreateCapsuleScreen extends StatefulWidget {
  const CreateCapsuleScreen({super.key});

  @override
  State<CreateCapsuleScreen> createState() => _CreateCapsuleScreenState();
}

class _CreateCapsuleScreenState extends State<CreateCapsuleScreen> {
  final SelectFiles _files = SelectFiles();

  VideoPlayerController? _controller;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Uint8List? _fileBytes;
  File? thumbnailFile;

  late DateTime dateAndTime;

  bool isCapsuleToggled = true;
  bool isTimeToggled = true;
  bool isMediaLoading = false;

  bool isImageFile = false;
  bool isVideoFile = false;
  bool isOtherFile = false;

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

  Future<void> _selectVideo(BuildContext context) async {
    final XFile? file = await _files.selectVideo();
    if (file == null) return;
    Navigator.of(context).pop();
    setState(() {
      isMediaLoading = true;
    });
    compressVideo(file.path);

    thumbnailFile =
        await CompressFile.getThumbnailfromVideo(filePath: file.path);

    _fileBytes = await thumbnailFile?.readAsBytes();

    isImageFile = false;
    isVideoFile = true;
    isOtherFile = false;
    _controller?.dispose();
    _controller = VideoPlayerController.file(File(file.path))
      ..initialize().then((_) {});
    setState(() {
      isMediaLoading = false;
    });
  }

  Future<void> compressVideo(String path) async {
    final MediaInfo? compressedVideo = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false, // Keep the original file
    );
    if (compressedVideo != null) {
      // Retrieve the size of the compressed video
      final int sizeInBytes = compressedVideo.filesize!;
      final String formattedSize = _formatBytes(sizeInBytes);

      Vx.log("Compressed Video Size: $formattedSize");
    }
  }

  Future<void> _selectImage(BuildContext context) async {
    final XFile? file = await _files.selectImage();
    if (file == null) return;
    Navigator.of(context).pop();
    setState(() {
      isMediaLoading = true;
    });
    _fileBytes = await file.readAsBytes();
    // uploadImage(file);
    setState(() {
      isImageFile = true;
      isVideoFile = false;
      isOtherFile = false;
      isMediaLoading = false;
    });
  }

  String _formatBytes(int bytes, [int decimalPlaces = 2]) {
    if (bytes <= 0) return "0 Bytes";
    const List<String> units = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    int i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimalPlaces)} ${units[i]}';
  }

  @override
  void initState() {
    DateTime currentTime = DateTime.now();
    _formatDateTime(currentTime);
    dateAndTime = currentTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatDateTime(dateAndTime);
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
            _futureAspectBuild(formattedDate),
            const SizedBox(height: 20),
            _previewButton()
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

    if (pickedDate != null) {
      // Step 3: Show time picker after selecting the date
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
            hour: now.hour, minute: now.minute), // Set current time as default
      );

      if (pickedTime != null) {
        // Step 4: Combine selected date and time

        DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Step 5: Check if the selected DateTime is in the future
        if (selectedDateTime.isAfter(now)) {
          setState(() {
            _formatDateTime(selectedDateTime);
          });
          dateAndTime = selectedDateTime;
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

  Widget _futureAspectBuild(Map<String, dynamic> formattedDate) {
    return SizedBox(
      height: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _dateAndTimeBuilder(formattedDate),
          _privacyBuilder(),
        ],
      ),
    );
  }

  Widget _dateAndTimeBuilder(Map<String, dynamic> formattedDate) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Set Future date",
          style: TextStyle(
              fontWeight: FontWeight.w500, color: AppColors.kPrimaryTextColor),
        ),
        const Spacer(),
        InkWell(
          onTap: () => _selectDateTime(context),
          child: Container(
            height: 150,
            width: 150,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.red // Darker shade
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
                          text:
                              '${formattedDate['hour12']}:${formattedDate['min']}', // Main time
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.kWhiteColor,
                          ),
                        ),
                        TextSpan(
                          text: ' ${formattedDate['period']}', // Small AM/PM
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
                    '${formattedDate['date']} ${formattedDate['month']} ${formattedDate['year']}, \n ${formattedDate['weekDay']}',
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
        )
      ],
    );
  }

  Widget _privacyBuilder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Is Capsule private?",
          style: TextStyle(
              fontWeight: FontWeight.w500, color: AppColors.kPrimaryTextColor),
        ),
        const SizedBox(
          height: 5,
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
        const Spacer(),
        Text(
          "Want Time private?",
          style: TextStyle(
              fontWeight: FontWeight.w500, color: AppColors.kPrimaryTextColor),
        ),
        const SizedBox(
          height: 5,
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

    if (isImageFile && _fileBytes != null) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            _fileBytes!,
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
                    color: AppColors.kWarmCoralColor.withOpacity(0.8),
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

  Widget _buildTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          " Title",
          style: TextStyle(fontSize: 18),
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
          style: TextStyle(fontSize: 18),
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

  Widget _previewButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: AppButton(
          onPressed: () {
            if (titleController.text.isEmpty) {
              appSnackBar(context: context, text: "Capsule title is required");
              return;
            }

            if (_fileBytes == null) {
              appSnackBar(context: context, text: "Capsule file is required");
              return;
            }

            PersistentNavBarNavigator.pushDynamicScreen(
              context,
              screen: MaterialPageRoute(
                builder: (context) => PreviewCapsule(
                  capsuleName: titleController.text,
                  capsuleDescription: descriptionController.text,
                  isCapsulePrivate: isCapsuleToggled,
                  isTimePrivate: isTimeToggled,
                  isImageFile: isImageFile,
                  isVideoFile: isVideoFile,
                  dateTime: dateAndTime,
                  file: _fileBytes,
                ),
              ),
              withNavBar: false,
            );
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
