import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/data/controllers/recipients.controller.dart';
import 'package:future_capsule/data/controllers/user.controller.dart';
import 'package:future_capsule/data/models/capsule_modal.dart';
import 'package:future_capsule/data/models/user_modal.dart';
import 'package:future_capsule/screens/my_futures/animation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_player/video_player.dart';

class FutureCapsuleDetail extends StatefulWidget {
  const FutureCapsuleDetail({
    super.key,
    required this.capsule,
    required this.user,
    required this.date,
  });
  final CapsuleModel capsule;
  final UserModel user;
  final String date;
  @override
  State<FutureCapsuleDetail> createState() => _FutureCapsuleDetailState();
}

class _FutureCapsuleDetailState extends State<FutureCapsuleDetail> {
  bool isLiked = false;
  bool isVideoFile = false;
  static VideoPlayerController? _controller;
  late CapsuleModel capsule;
  late int capsuleLikes;
  late bool isCapsuleLocked;
  late Duration openDate;

  final RecipientController _recipientController =
      Get.put(RecipientController());
  final UserController _userController = Get.put(UserController());
  String? currentUser;

  @override
  void initState() {
    capsule = widget.capsule;
    capsuleLikes = capsule.likes?.length ?? 0;
    isVideoFile = capsule.media[0].type.contains('video');
    isCapsuleLocked = capsule.status == 'locked';
    if (isVideoFile && !isCapsuleLocked) _videoInitialize();
    openDate = capsule.openingDate.difference(DateTime.now());
    currentUser = _userController.getUser?.uid;

    super.initState();
  }

  void _videoInitialize() {
    if (_controller == null ||
        _controller!.dataSource != capsule.media[0].url) {
      if (_controller != null) {
        _controller!.dispose(); // Dispose of old controller if any
      }

      _controller = VideoPlayerController.networkUrl(
        Uri.parse(capsule.media[0].url),
      )..initialize().then((_) {
          if (mounted) {
            setState(() {}); // Update UI after initialization
          }
        }).catchError((error) {
          Vx.log("Error initializing video: $error");
        });
    }
  }

  void _handleLikesbutton(String capsuleId) async {
    _recipientController.updateLikes(capsuleId: capsuleId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Capsule details",
          style: TextStyle(
              color: AppColors.dNeonCyan, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: const [
          Icon(
            Icons.more_vert,
            color: AppColors.kWhiteColor,
          )
        ],
        leading: IconButton(
          onPressed: () {
            Get.back(result: true);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.kWhiteColor,
          ),
        ),
      ),
      body: StreamBuilder<CapsuleModel>(
          stream: _recipientController.capsuleStream(capsule.capsuleId),
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return const Center(child: CircularProgressIndicator());
            // }

            if (!snapshot.hasData) {
              return const Center(
                  child: Text(
                "Capsule not found",
                style: TextStyle(color: AppColors.kWhiteColor),
              ));
            }

            CapsuleModel cap = snapshot.data!;
            final capsuleLikes = cap.likes?.length ?? 0;
            final bool isLiked =
                cap.likes?.any((like) => like['recipientId'] == currentUser) ??
                    false;

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              children: [
                Text(
                  capsule.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(0, 255, 204, 1),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  capsule.description ?? "",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(255, 255, 255, 1),
                      height: 1.5),
                ),
                const SizedBox(height: 18),
                _buildMediaPreview(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      constraints: const BoxConstraints(maxWidth: 24),
                      onPressed: () => _handleLikesbutton(capsule.capsuleId),
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_outline,
                        color: isLiked
                            ? const Color.fromARGB(255, 237, 54, 54)
                            : AppColors.kLightGreyColor,
                        size: 26,
                      ),
                    ),
                    Text(
                      "$capsuleLikes ${(capsuleLikes.length >= 2) ? 'Likes' : 'Like'}",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(255, 255, 255, 1),
                          height: 1.5),
                    )
                  ],
                ),
                const SizedBox(height: 18),
                if (capsule.status.toLowerCase() == "locked")
                  _buildDateTimePreview(),
                const SizedBox(height: 18),
                UserTile(
                  user: widget.user,
                  date: widget.date,
                ),
              ],
            );
          }),
    );
  }

  Widget _buildMediaPreview() {
    bool isPlaying = _controller?.value.isPlaying ?? false;
    return Center(
      child: LikeableImage(
        capsule: capsule,
        onLike: () => _handleLikesbutton(capsule.capsuleId),
        userId: currentUser!,
        child: Container(
            constraints: BoxConstraints(maxHeight: 350, minHeight: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
            ),
            child: !isCapsuleLocked
                ? (isVideoFile &&
                        _controller != null &&
                        _controller!.value.isInitialized)
                    ? SizedBox(
                        height: 350,
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
                                  cacheKey: widget.capsule.media[0].mediaId,
                                  fit: BoxFit.fill,
                                  imageUrl:
                                      (widget.capsule.media[0].thumbnail !=
                                                  null &&
                                              widget.capsule.media[0].thumbnail!
                                                  .isNotEmpty)
                                          ? widget.capsule.media[0].thumbnail!
                                          : widget.capsule.media[0].url,
                                ),
                              ),
                            ),
                          ),
                          (_controller != null &&
                                  !_controller!.value.isInitialized)
                              ? Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Container(
                                      color:
                                          const Color.fromRGBO(32, 32, 32, 0.6),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          (_controller != null &&
                                  !_controller!.value.isInitialized)
                              ? const Center(
                                  child: CircularProgressIndicator.adaptive(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.kWhiteColor),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      )
                : Image.asset(AppImages.darkLockedCapsule)),
      ),
    );
  }

  Widget _buildDateTimePreview() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        (!capsule.privacy.isTimePrivate)
            ? Column(
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
                            color:
                                Color.fromRGBO(0, 255, 255, 0.5), // Glow effect
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
              )
            : Text(
                "Opening date is private ",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.dNeonCyan),
              ),
      ],
    );
  }
}

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.user, required this.date});
  final UserModel user;
  final String date;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      constraints: const BoxConstraints(maxHeight: 110),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(120),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: (user.profilePicture != null ||
                        user.profilePicture!.isNotEmpty)
                    ? Image.network(
                        user.profilePicture!,
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        AppImages.profile,
                        height: 70,
                        width: 70,
                      )),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kWhiteColor),
                ),
                SizedBox(
                  width: 200,
                  child: Text(
                    formatDateTime(date.toDate()!),
                    maxLines: 2,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Color.fromRGBO(139, 150, 160, 1),
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat("MMMM d, yyyy 'on' h:mm a").format(dateTime);
  }
}
