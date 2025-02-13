import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/widgets/app_button.dart';
import 'package:future_capsule/data/models/capsule_model.dart';
import 'package:future_capsule/screens/create_capsule/toggle.dart';
import 'package:future_capsule/screens/my_capsules/edit_capsule.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_player/video_player.dart';

class MyCapsulesPreview extends StatefulWidget {
  const MyCapsulesPreview({
    super.key,
    required this.capsule,
  });

  final CapsuleModel capsule;

  @override
  State<MyCapsulesPreview> createState() => _MyCapsulesPreviewState();
}

class _MyCapsulesPreviewState extends State<MyCapsulesPreview> {
  late Duration openDate;
  static VideoPlayerController? _controller;
  bool isCapsuleLoading = false;
  late CapsuleModel userCapsule; 
  bool isVideoFile = false;

  @override
  void initState() {

    userCapsule  = widget.capsule;  
    isVideoFile = userCapsule.media[0].type.contains('video');
    openDate = userCapsule.openingDate.difference(DateTime.now());
    if (isVideoFile) _videoInitialize();

    super.initState();
  }

  void _videoInitialize() {
    if (_controller == null || _controller!.dataSource != userCapsule.media[0].url) {
      if (_controller != null) {
        _controller!.dispose(); // Dispose of the old controller if any
      }

      _controller = VideoPlayerController.networkUrl(Uri.parse(userCapsule.media[0].url))
        ..initialize().then((_) {
          setState(() {});
        }).catchError((error) {
          Vx.log("Error initializing video: $error");
        });
    }
  }

  void deleteCapsule() async {}

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
            _buildTitleField(userCapsule.title),
            const SizedBox(height: 10),
            _buildFilePreview(userCapsule.media[0].url, userCapsule.privacy.isCapsulePrivate),
            const SizedBox(height: 10),
            _buildDescriptionField(userCapsule.description ?? ".."),
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

  Widget _buildFilePreview(String capsuleURL, bool isCapsulePrivate) {
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
                setState(
                  () {
                    if (isPlaying) {
                      _controller!.pause();
                    } else {
                      _controller!.play();
                    }
                  },
                );
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

    if (!isVideoFile) {
      return Container(
        constraints: const BoxConstraints(maxHeight: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.kWarmCoralColor, width: 2),
        ),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            if (capsuleURL.isNotEmpty)
              Image.network(
                capsuleURL,
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
    return Center(
      child: CircularProgressIndicator.adaptive(
        valueColor: const AlwaysStoppedAnimation<Color>(
            Colors.grey), // Buffered portion color
        backgroundColor: AppColors.kWarmCoralColor, // Background color
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
              isToggled: userCapsule.privacy.isCapsulePrivate,
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
              isToggled: userCapsule.privacy.isTimePrivate,
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
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => EditCapsuleScreen(
                          capsuleModel: widget.capsule,
                          controller: _controller,
                        ))),
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
            onPressed: deleteCapsule,
            radius: 24,
            child: Center(
              child: isCapsuleLoading
                  ? CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation(AppColors.kWhiteColor),
                    )
                  : Text(
                      "Delete",
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
