import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/data/models/capsule_modal.dart';
import 'package:velocity_x/velocity_x.dart';

class MyFutureUsersCapsulesTiles extends StatelessWidget {
  const MyFutureUsersCapsulesTiles(
      {super.key, required this.capsule, required this.date});

  final CapsuleModel capsule;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      width: double.infinity,
      decoration: BoxDecoration(
          color: const Color.fromRGBO(26, 26, 26, 1),
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            capsule.title,
            style: const TextStyle(
                color: Color.fromRGBO(0, 255, 204, 1),
                fontSize: 24,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: CachedNetworkImage(
                imageUrl: (capsule.media.isNotEmpty &&
                        capsule.media[0].thumbnail != null &&
                        capsule.media[0].thumbnail!.isNotEmpty)
                    ? capsule.media[0].thumbnail!
                    : capsule.media[0].url,
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            capsule.description ?? "No description",
            style: const TextStyle(
              color: Color.fromRGBO(177, 223, 230, 1),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 3,
          ),
          const SizedBox(
            height: 14,
          ),
          Row(
            children: [
              const Spacer(),
              Text(
                date.toDate()?.timeAgo() ?? "not found",
                style: const TextStyle(
                  color: Color.fromRGBO(0, 255, 255, 1),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
