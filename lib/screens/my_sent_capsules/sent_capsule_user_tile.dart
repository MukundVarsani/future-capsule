import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/data/models/user_modal.dart';

class SentCapsuleUserTile extends StatelessWidget {
  const SentCapsuleUserTile({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          color: AppColors.dUserTileBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(0, 255, 255, 0.4),
                blurRadius: 10,
                spreadRadius: 0.5,
                offset: Offset(1, 2))
          ]),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              cacheKey: user.userId,
              imageUrl:
              (user.profilePicture != null && user.profilePicture!.isNotEmpty)
                  ? user.profilePicture!
                  : "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 24,
          ),
          Text(
            user.name,
            style: const TextStyle(
                color: AppColors.kWhiteColor,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          const Row(
            children: [
              Icon(
                Icons.lock,
                size: 20,
                color: AppColors.kErrorSnackBarTextColor,
              ),
              Text(
                "Locked",
                style: TextStyle(
                    color: AppColors.kErrorSnackBarTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
