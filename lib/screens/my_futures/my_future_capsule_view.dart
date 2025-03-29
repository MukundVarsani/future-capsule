import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/data/models/capsule_modal.dart';
import 'package:future_capsule/data/models/user_modal.dart';
import 'package:future_capsule/screens/my_futures/future_capsule_detail.dart';
import 'package:future_capsule/screens/my_futures/my_future_users_capsules_card.dart';
import 'package:get/get.dart';


class MyFutureCapsuleView extends StatelessWidget {
  const MyFutureCapsuleView(
      {super.key,
      required this.user,
      required this.capsules,
      required this.date});

  final UserModel user;

  final List<CapsuleModel> capsules;

  final List<String> date;

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
                      child: (user.profilePicture != null &&
                              user.profilePicture!.isNotEmpty)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                cacheKey: user.userId,
                                imageUrl: user.profilePicture!,
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
                      user.name,
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
                    itemCount: capsules.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(FutureCapsuleDetail(
                                capsule: capsules[index],
                                date: date[index],
                                user: user,
                              ));
                            },
                            child: MyFutureUsersCapsulesCard(
                              capsule: capsules[index],
                              date: date[index],
                              userId: user.userId,
                            ),
                          ),
                        )),
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
