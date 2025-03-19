import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:shimmer/shimmer.dart';

class UserTileShimmer extends StatelessWidget {
  const UserTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Show 4 loading placeholders
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[600]!,
            highlightColor: Colors.grey[400]!,
            child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 0).copyWith(top: 12),
              constraints: const BoxConstraints(maxHeight: 85),
              decoration: const BoxDecoration(),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 12, right: 6),
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(120)),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 18,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                   Container(
                                    height: 15,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                ],
                              ),

                              const Spacer(),
                              // (capsule.openingDate.isAfter(DateTime.now()))
                              //     ? Image.asset(
                              //         AppImages.lightCapsuleLock,
                              //         height: 50,
                              //         width: 50,
                              //         fit: BoxFit.cover,
                              //       )
                              //     : Image.asset(
                              //         AppImages.lightCapsuleUnLock,
                              //         height: 40,
                              //         width: 40,
                              //         fit: BoxFit.cover,
                              //       ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            "lastDate.timeAgo()",
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
            ),
          ),
        );
      },
    );
  }
}
