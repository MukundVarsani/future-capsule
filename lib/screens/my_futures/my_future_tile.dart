import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/data/models/capsule_modal.dart';
import 'package:future_capsule/data/models/user_modal.dart';
import 'package:velocity_x/velocity_x.dart';

class MyFutureTile extends StatelessWidget {
  const MyFutureTile(
      {super.key,
      required this.lastDate,
      required this.user,
      required this.capsule});

  final CapsuleModel capsule;
  final DateTime lastDate;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0).copyWith(top: 12),
      constraints: const BoxConstraints(maxHeight: 85),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 12, right: 6),
            child:
                (user.profilePicture != null && user.profilePicture!.isNotEmpty)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl: user.profilePicture!,
                          filterQuality: FilterQuality.high,
                          height: 70,
                          width: 70,
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
                        height: 70,
                      ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                   
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              capsule.title,
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: AppColors.kLightBlackColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),
                      (capsule.openingDate.isAfter(DateTime.now()))
                          ? Image.asset(
                              AppImages.lightCapsuleLock,
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              AppImages.lightCapsuleUnLock,
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    lastDate.timeAgo(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  const Divider(
                    thickness: 0.3,
                    height: 1,
                    color: AppColors.kWarmCoralColor06,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
