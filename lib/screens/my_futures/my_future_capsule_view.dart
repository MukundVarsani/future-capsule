import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/data/controllers/user.controller.dart';
import 'package:future_capsule/data/models/capsule_modal.dart';
import 'package:future_capsule/data/models/user_modal.dart';
import 'package:future_capsule/screens/my_futures/future_capsule_detail.dart';
import 'package:future_capsule/screens/my_futures/my_future_users_capsules_card.dart';
import 'package:get/get.dart';


class MyFutureCapsuleView extends StatefulWidget {
  const MyFutureCapsuleView(
      {super.key,
      required this.user,
      required this.capsules,
      required this.date});

  final UserModel user;

  final List<CapsuleModel> capsules;

  final List<String> date;

  @override
  State<MyFutureCapsuleView> createState() => _MyFutureCapsuleViewState();
}

class _MyFutureCapsuleViewState extends State<MyFutureCapsuleView> {
  List<CapsuleModel?> cap = [];
  late List<String> currentUserStatus;
  final UserController _userController = Get.put(UserController());

  @override
  void initState() {
    cap = widget.capsules;

    currentUserStatus = cap.map((capsule) {
      final recp = capsule!.recipients.firstWhere(
        (r) => r.recipientId == _userController.getUser!.uid,
      );
      return recp.status;
    }).toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dDeepBackground,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.dDeepBackground,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration:
                    const BoxDecoration(color: AppColors.dDeepBackground),
                child: Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: AppColors.kWhiteColor),
                        onPressed: () => Get.back()),
                    const SizedBox(
                      width: 8,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: (widget.user.profilePicture != null &&
                              widget.user.profilePicture!.isNotEmpty)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                cacheKey: widget.user.userId,
                                imageUrl: widget.user.profilePicture!,
                                filterQuality: FilterQuality.high,
                                height: 54,
                                width: 54,
                                fit: BoxFit.cover,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(
                                      value: downloadProgress.progress,
                                      valueColor: const AlwaysStoppedAnimation(
                                          AppColors.kWarmCoralColor),
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            )
                          : Image.asset(
                              AppImages.profile,
                              height: 54,
                            ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      widget.user.name,
                      style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.kWhiteColor,
                          fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    const Icon(Icons.more_vert, color: AppColors.kWhiteColor),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: cap.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: GestureDetector(
                        onTap: () async {
                         await Get.to(
                            () => FutureCapsuleDetail(
                              capsule: cap[index]!,
                              date: widget.date[index],
                              user: widget.user,
                            ),
                          );
                          setState(() {
                            currentUserStatus[index] = "opened";
                          });
                        },
                        child: MyFutureUsersCapsulesCard(
                          capsule: cap[index]!,
                          date: widget.date[index],
                          userId: widget.user.userId,
                          userStatus: currentUserStatus[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
