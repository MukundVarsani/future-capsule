import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/data/models/user_modal.dart';

class MySentCapsuleTile extends StatelessWidget {
  const MySentCapsuleTile(
      {super.key,
      required this.openDate,
      required this.createDate,
      required this.user});

  final String openDate;

  final String createDate;

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      constraints: const BoxConstraints(maxHeight: 90),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
            ]),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text.rich(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    TextSpan(
                      text: "Last capsule : ",
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 14),
                      children: [
                        TextSpan(
                            text: openDate,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15))
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(createDate,
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(0, 0, 0, 0.5)))
                    ],
                  ),
                  const Divider(
                    thickness: 0.5,
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
