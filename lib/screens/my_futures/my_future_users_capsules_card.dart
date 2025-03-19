import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/constants/methods.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/data/controllers/recipients.controller.dart';
import 'package:future_capsule/data/models/capsule_modal.dart';
import 'package:get/get.dart';

import 'package:velocity_x/velocity_x.dart';

class MyFutureUsersCapsulesCard extends StatefulWidget {
  const MyFutureUsersCapsulesCard(
      {super.key, required this.capsule, required this.date});

  final CapsuleModel capsule;
  final String date;

  @override
  State<MyFutureUsersCapsulesCard> createState() =>
      _MyFutureUsersCapsulesCardState();
}

class _MyFutureUsersCapsulesCardState extends State<MyFutureUsersCapsulesCard> {
  final RecipientController _recipientController =
      Get.put(RecipientController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.kdMyFutureCapsuleCardBackground,
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.capsule.title,
            maxLines: 1,
            style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Color.fromRGBO(0, 255, 204, 1),
                fontSize: 24,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: widget.capsule.status == 'opened'
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: (widget.capsule.media.isNotEmpty &&
                              widget.capsule.media[0].thumbnail != null &&
                              widget.capsule.media[0].thumbnail!.isNotEmpty)
                          ? widget.capsule.media[0].thumbnail!
                          : widget.capsule.media[0].url,
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  )
                : widget.capsule.status == "pending"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 180,
                          ),
                          GestureDetector(
                            onTap: () {
                             
                              _recipientController.updateCapsuleStatus(capsuleId: widget.capsule.capsuleId);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(10, 15, 31, 1),
                                  borderRadius: BorderRadius.circular(32),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Color.fromRGBO(
                                            0, 255, 255, 0.5), // Glow effect
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                        offset: Offset(1, 2)),
                                  ]),
                              child: const Text(
                                "Open Capsule",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.dNeonCyan),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Image.asset(
                        AppImages
                            .darkLockedCapsule, // Default to "locked" status
                        height: 180,
                        fit: BoxFit.cover,
                      ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.capsule.description ?? "No description",
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
                widget.date.toDate() != null
                    ? timeAgo(widget.date.toDate()!)
                    : "not found",
                style: const TextStyle(
                  color: Color.fromRGBO(0, 255, 255, 1),
                  fontSize: 10,
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
