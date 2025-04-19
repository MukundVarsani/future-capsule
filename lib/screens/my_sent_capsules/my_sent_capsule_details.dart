import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/constants/methods.dart';
import 'package:future_capsule/core/widgets/app_button.dart';
import 'package:future_capsule/core/widgets/snack_bar.dart';
import 'package:future_capsule/data/controllers/recipients.controller.dart';
import 'package:future_capsule/data/models/capsule_modal.dart';
import 'package:future_capsule/data/models/user_modal.dart';
import 'package:future_capsule/screens/my_sent_capsules/sent_capsule_user_tile.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_player/video_player.dart';

class MySentCapsuleDetails extends StatefulWidget {
  const MySentCapsuleDetails({
    super.key,
    required this.capsule,
    required this.recipientsUsers,
    required this.shareDate,
  });

  final CapsuleModel capsule;
  final List<UserModel> recipientsUsers;
  final DateTime shareDate;

  @override
  State<MySentCapsuleDetails> createState() => _MySentCapsuleDetailsState();
}

class _MySentCapsuleDetailsState extends State<MySentCapsuleDetails> {
  bool isVideoFile = false;
  static VideoPlayerController? _controller;
  late CapsuleModel userCapsule;
  final RecipientController _recipientController =
      Get.put(RecipientController());

  @override
  void initState() {
    userCapsule = widget.capsule;
    isVideoFile = userCapsule.media[0].type.contains('video');
    if (isVideoFile) _videoInitialize();
    super.initState();
  }

  void _videoInitialize() {
    if (_controller == null ||
        _controller!.dataSource != userCapsule.media[0].url) {
      if (_controller != null) {
        _controller!.dispose(); // Dispose of old controller if any
      }

      _controller = VideoPlayerController.networkUrl(
        Uri.parse(userCapsule.media[0].url),
      )..initialize().then((_) {
          if (mounted) {
            setState(() {}); // Update UI after initialization
          }
        }).catchError((error) {
          Vx.log("Error initializing video: $error");
        });
    }
  }

  void handledeleteCapsule(
      String capsuleId, String senderId, List<UserModel> users) async {
    for (UserModel user in users) {
      await _recipientController.deleteSentCapsule(
          capsuleId: capsuleId, senderId: senderId, recipientId: user.userId);
    }
    appSnackBar(text: "Capsule delete successfully", context: context);
    

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dDeepBackground,
      appBar: AppBar(
        backgroundColor: AppColors.dDeepBackground,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.kWhiteColor,
            )),
        title: const Text(
          "Capsule Details",
          style: TextStyle(
              color: AppColors.dNeonCyan, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMediaPreview(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Tooltip(
                      textStyle: TextStyle(
                          color: AppColors.kLightGreyColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w800),
                      message: dateFormat(userCapsule.openingDate),
                      child: Text(
                        timeAgo(widget.shareDate),
                        style: TextStyle(
                            color: AppColors.dDateAndTimeColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w800),
                      )),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ),
              Text(
                widget.capsule.title,
                style: const TextStyle(
                    color: Color.fromRGBO(
                      0,
                      255,
                      204,
                      1,
                    ),
                    fontSize: 22,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                widget.capsule.description ?? "",
                style: const TextStyle(
                  color: AppColors.dInActiveColorPrimary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    (widget.capsule.status.toUpperCase() == "LOCKED")
                        ? Icons.lock
                        : (widget.capsule.status.toUpperCase() == "PENDING")
                            ? Icons.pending
                            : Icons.lock_open_sharp,
                    size: 24,
                    color: (widget.capsule.status.toUpperCase() == "LOCKED")
                        ? AppColors.kErrorSnackBarTextColor
                        : (widget.capsule.status.toUpperCase() == "PENDING")
                            ? const Color.fromRGBO(153, 113, 238, 1)
                            : const Color.fromRGBO(34, 197, 94, 1),
                  ),
                  Text(
                    widget.capsule.status,
                    style: TextStyle(
                        color: (widget.capsule.status.toUpperCase() == "LOCKED")
                            ? AppColors.kErrorSnackBarTextColor
                            : (widget.capsule.status.toUpperCase() == "PENDING")
                                ? const Color.fromRGBO(153, 113, 238, 1)
                                : const Color.fromRGBO(34, 197, 94, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      color: Colors.tealAccent, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Open Date',
                    style: TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '19/03/25 12:00 AM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ...widget.recipientsUsers.map((user) {
                String? status = widget.capsule.recipients
                    .firstWhere(
                      (element) => element.recipientId == user.userId,
                    )
                    .status;

                return SentCapsuleUserTile(
                  status: status,
                  user: user,
                );
              }),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                  width: double.maxFinite,
                  height: 50,
                  child: AppButton(
                    onPressed: () => handledeleteCapsule(userCapsule.capsuleId,
                        userCapsule.creatorId, widget.recipientsUsers),
                    backgroundColor: AppColors.kErrorSnackBarTextColor,
                    child: Obx(() => _recipientController
                            .isCapsuleDeleting.value
                        ? Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(AppColors.kWhiteColor) ,))
                        : Text(
                            "Delete",
                            style: TextStyle(
                                color: AppColors.kWhiteColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          )),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  String dateFormat(DateTime dateTime) {
    return DateFormat('dd/MM/yy h:mm a')
        .format(dateTime); // Always show date and time
  }

  Widget _buildMediaPreview() {
    bool isPlaying = _controller?.value.isPlaying ?? false;
    return Center(
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
        ),
        child: (isVideoFile &&
                _controller != null &&
                _controller!.value.isInitialized)
            ? SizedBox(
                height: 300,
                child: Stack(
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
                          if (mounted) {
                            setState(
                              () {
                                if (isPlaying) {
                                  _controller!.pause();
                                } else {
                                  _controller!.play();
                                }
                              },
                            );
                          }
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
                ),
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: IntrinsicWidth(
                      child: IntrinsicHeight(
                        child: CachedNetworkImage(
                          cacheKey: widget.capsule.capsuleId,
                          fit: BoxFit.fill,
                          imageUrl: (widget.capsule.media[0].thumbnail !=
                                      null &&
                                  widget.capsule.media[0].thumbnail!.isNotEmpty)
                              ? widget.capsule.media[0].thumbnail!
                              : widget.capsule.media[0].url,
                        ),
                      ),
                    ),
                  ),
                  (_controller != null && !_controller!.value.isInitialized)
                      ? Positioned.fill(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(18), // Match image border
                            child: Container(
                              color: const Color.fromRGBO(32, 32, 32, 0.6),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  (_controller != null && !_controller!.value.isInitialized)
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.kWhiteColor),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
      ),
    );
  }
}
