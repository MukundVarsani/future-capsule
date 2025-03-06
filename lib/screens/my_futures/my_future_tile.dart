import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/data/models/capsule_modal.dart';
import 'package:velocity_x/velocity_x.dart';

class MyFutureTile extends StatelessWidget {
  const MyFutureTile(
      {super.key, required this.capsule, required this.lastDate});

  final CapsuleModel capsule;
  final DateTime lastDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0).copyWith(top: 12),
      constraints: const BoxConstraints(maxHeight: 85),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 12, right: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: (capsule.media[0].thumbnail != null &&
                          capsule.media[0].thumbnail!.isNotEmpty)
                      ? capsule.media[0].thumbnail!
                      : capsule.media[0].url,
                  filterQuality: FilterQuality.high,
                  height: 70,
                  width: 70,
                  fit: BoxFit.contain,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Align(
                    alignment:
                        Alignment.center, // Keep it centered inside the parent
                    child: SizedBox(
                      height: 30, // Explicitly set smaller height
                      width: 30, // Explicitly set smaller width
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                        valueColor: const AlwaysStoppedAnimation(
                            AppColors.kWarmCoralColor),
                        strokeWidth: 2, // Make it thinner
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              ],
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            capsule.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              capsule.description ?? "No description",
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: AppColors.kLightBlackColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
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
                  Text(lastDate.timeAgo(),
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(0, 0, 0, 0.4))),
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
