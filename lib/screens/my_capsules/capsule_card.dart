import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/constants/methods.dart';
import 'package:future_capsule/data/models/capsule_modal.dart';
import 'package:intl/intl.dart';

class CapsuleCard extends StatelessWidget {
  const CapsuleCard({super.key, required this.capsule});
  final CapsuleModel capsule;

  String durationAgo(DateTime dateTime) {
    return DateFormat('dd/MM/yy h:mm a')
        .format(dateTime); // Always show date and time
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
      ).copyWith(top: 8),
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.kdMyFutureCapsuleCardBackground,
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                cacheKey: capsule.media[0].mediaId,
                imageUrl: (capsule.media.isNotEmpty &&
                        capsule.media[0].thumbnail != null &&
                        capsule.media[0].thumbnail!.isNotEmpty)
                    ? capsule.media[0].thumbnail!
                    : capsule.media[0].url,
                fit: BoxFit.contain,
                height: 150,
              ),
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          Row(
            children: [
              SizedBox(
                width: 300,
                child: Text(
                  capsule.title,
                  maxLines: 1,
                  style: const TextStyle(
                      color: Color.fromRGBO(
                        0,
                        255,
                        204,
                        1,
                      ),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              const Spacer(),
              Icon(
                  capsule.privacy.isCapsulePrivate
                      ? Icons.lock
                      : Icons.lock_open,
                  color: const Color.fromRGBO(255, 84, 84, 1)),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text(
                durationAgo(capsule.openingDate),
                style: const TextStyle(
                    color: AppColors.dNeonCyan,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Icon(
                  !capsule.privacy.isTimePrivate
                      ? Icons.lock
                      : Icons.access_time,
                  color: const Color.fromRGBO(255, 166, 0, 1)),
            ],
          ),
          const SizedBox(
            height: 11,
          ),
          Text(
            timeAgo(capsule.createdAt),
            style: const TextStyle(
              color: AppColors.dDateAndTimeColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
