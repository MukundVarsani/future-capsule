// ignore_for_file: invalid_use_of_protected_member

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/widgets/app_button.dart';
import 'package:future_capsule/core/widgets/snack_bar.dart';
import 'package:future_capsule/data/controllers/capsule.controller.dart';
import 'package:future_capsule/data/controllers/recipients.controller.dart';
import 'package:future_capsule/data/models/capsule_modal.dart';
import 'package:future_capsule/screens/create_capsule/toggle.dart';
import 'package:future_capsule/screens/my_capsules/all_user_tile.dart';
import 'package:future_capsule/screens/my_capsules/edit_capsule.dart';
import 'package:get/get.dart';
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
  final CapsuleController _capsuleController = Get.put(CapsuleController());
  final RecipientController _recipientController =
      Get.put(RecipientController());

  @override
  void initState() {
    userCapsule = widget.capsule;
    isVideoFile = userCapsule.media[0].type.contains('video');
    openDate = userCapsule.openingDate.difference(DateTime.now());
    // _capsuleController.getAvailableUser();
    _recipientController.getAvailableRecipients();
    if (isVideoFile) _videoInitialize();

    super.initState();
  }

  void _videoInitialize() {
    if (_controller == null ||
        _controller!.dataSource != userCapsule.media[0].url) {
      if (_controller != null) {
        _controller!.dispose(); // Dispose of the old controller if any
      }

      _controller =
          VideoPlayerController.networkUrl(Uri.parse(userCapsule.media[0].url))
            ..initialize().then((_) {
              if (mounted) {
                if (mounted) setState(() {});
              }
            }).catchError((error) {
              Vx.log("Error initializing video: $error");
            });
    }
  }

  void deleteCapsule(String capsuleId, String mediaId) async {
    _capsuleController.deleteCapsule(capsuleId: capsuleId, mediaId: mediaId);
  }

  void _sendCapsule() {
    if (_recipientController.availableRecipientIds.isNotEmpty) {
      _recipientController.sendCapsule(capsule: widget.capsule);

      Get.back();
    } else {
      appBar(text: "Select user");
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
          const SizedBox(height: 10),
          _buildTitleField(userCapsule.title),
          const SizedBox(height: 12),
          // _buildFilePreview(
          //     userCapsule.media[0].url, userCapsule.privacy.isCapsulePrivate),
          _buildMediaPreview(),
          const SizedBox(height: 12),
          _buildDescriptionField(userCapsule.description ?? ".."),
          const SizedBox(height: 18),
          _buildDateTimePreview(),
          const SizedBox(height: 18),
          _privacyBuilder(),
          const SizedBox(height: 18),
          _buildActionButtons(context),
          const SizedBox(height: 18),
          AppButton(
              backgroundColor: const Color.fromRGBO(53, 153, 219, 1),
              onPressed: _openBottomBar,
              child: const Text("Send",
                  style: TextStyle(
                      color: AppColors.kWhiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 20))),
          const SizedBox(height: 10),
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
              aspectRatio: _controller!.value.aspectRatio * 2,
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
      );
    }

    if (!isVideoFile) {
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
            if (capsuleURL.isNotEmpty)
              Image.network(
                capsuleURL,
                height: 200,
                filterQuality: FilterQuality.high,
                fit: BoxFit.fill,
              ),
            if (isCapsulePrivate)
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
    return const Center(
      child: CircularProgressIndicator.adaptive(
        valueColor: AlwaysStoppedAnimation<Color>(
            Colors.grey), // Buffered portion color
        backgroundColor: AppColors.kWarmCoralColor, // Background color
      ),
    );
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
              isToggled: widget.capsule.privacy.isCapsulePrivate,
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
              isToggled: widget.capsule.privacy.isTimePrivate,
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
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => EditCapsuleScreen(
                          capsuleModel: widget.capsule,
                          controller: _controller,
                        ))),
            radius: 24,
            child: const Center(
              child: Text(
                "Edit",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
            backgroundColor: const Color.fromRGBO(53, 153, 219, 1),
            onPressed: () => deleteCapsule(
                userCapsule.capsuleId, userCapsule.media[0].mediaId),
            radius: 24,
            child: Center(
                child: Obx(
              () => _capsuleController.isCapsuleDeleting.value
                  ? const CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation(AppColors.kWhiteColor),
                    )
                  : const Text(
                      "Delete",
                      style: TextStyle(
                        color: AppColors.kWhiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            )),
          ),
        ),
      ],
    );
  }

  void _openBottomBar() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: 600, // Fixed height of 600px
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: AppColors.dNavigationBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 2,
                    child: const Text(
                      "Select User",
                      style: TextStyle(
                          color: AppColors.kWhiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close,
                        size: 28, color: AppColors.kWhiteColor),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Obx(
                () => _recipientController.isRecipientLoading.value
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.grey), // Buffered portion color
                          backgroundColor:
                              AppColors.kWarmCoralColor, // Background color
                        ),
                      )
                    : (_recipientController.availableRecipients.isNotEmpty)
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: _recipientController
                                  .availableRecipients.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    if (_recipientController
                                        .availableRecipientIds
                                        .contains(index)) {
                                      _recipientController
                                          .removeRecipient(index);
                                    } else {
                                      _recipientController.addRecipient(index);
                                    }
                                  },
                                  child: Obx(() => AllUserTile(
                                        isUserSelect: _recipientController
                                            .availableRecipientIds
                                            .contains(index),
                                        name: _recipientController
                                            .availableRecipients
                                            .value[index]
                                            .name,
                                        imgURL: _recipientController
                                            .availableRecipients
                                            .value[index]
                                            .profilePicture,
                                      )),
                                );
                              },
                            ),
                          )
                        : const Center(
                            child: Text(
                              "No User Found",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 300, minWidth: 250),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: AppButton(
                  backgroundColor: const Color.fromRGBO(53, 153, 219, 1),
                  onPressed: _sendCapsule,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Obx(
                        () => _recipientController.isCapsuleSending.value
                            ? const Center(
                                child: CircularProgressIndicator.adaptive(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.grey), // Buffered portion color
                                  backgroundColor:
                                      AppColors.kWhiteColor, // Background color
                                ),
                              )
                            : const Text(
                                "Send",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.kWhiteColor,
                                    fontWeight: FontWeight.w600),
                              ),
                      )),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
