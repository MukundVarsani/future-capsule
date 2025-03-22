import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/constants/methods.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/data/models/capsule_modal.dart';
import 'package:future_capsule/data/models/user_modal.dart';


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
      margin: const EdgeInsets.symmetric(horizontal: 12).copyWith(top: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      constraints: const BoxConstraints(maxHeight: 110),
      decoration: BoxDecoration(
          color: AppColors.dUserTileBackground,
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
             margin: const EdgeInsets.only(right:  16),
             decoration: BoxDecoration(
              boxShadow: const [BoxShadow(color: AppColors.dNeonCyan, offset: Offset(0, 0), blurRadius: 8, spreadRadius:0.05)],
              borderRadius: BorderRadius.circular(120),
             ),
            child:
                (user.profilePicture != null && user.profilePicture!.isNotEmpty)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          cacheKey: user.userId,
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
                                    AppColors.dNeonCyan),
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
                    capsule.title,
                    maxLines: 2,
                    style: const TextStyle( 
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.dNeonCyan,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      timeAgo(lastDate),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: AppColors.dDateAndTimeColor
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
