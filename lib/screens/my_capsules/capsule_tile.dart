import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';

class CapsuleTile extends StatelessWidget {
  const CapsuleTile(
      {super.key,
      required this.capsuleTitle,
      required this.openDate,
      required this.isCapsulePrivate,
      required this.isTimePrivate,
      required this.createDate, required this.imgURL});

  final String capsuleTitle;
  final String openDate;
  final bool isCapsulePrivate;
  final bool isTimePrivate;
  final String createDate;
  final String imgURL;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      constraints: const BoxConstraints(maxHeight: 130),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 111, 97, 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.kWarmCoralColor, width: 2)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: AppColors.kWarmCoralColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                )),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(
                AppImages.profile,
                height: 80,
              )
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
                      capsuleTitle,
                      style:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Text.rich(TextSpan(
                        text: "Open on: ",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                        children: [
                          TextSpan(
                              text: openDate,
                              style:const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 14))
                        ])),
                    Row(
                      children: [
                        const Text(
                          "Capsule",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        _boolBuilder(isCapsulePrivate),
                        const Spacer(),
                        const Text(
                          "Time",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        _boolBuilder(isTimePrivate),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                     Row(
                      mainAxisAlignment:
                          MainAxisAlignment.end, // Align to the right
                      children: [
                        Text(createDate,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(0, 0, 0, 0.6)))
                      ],
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _boolBuilder(bool isPrivate) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isPrivate
            ? AppColors.kTealGreenColor
            : AppColors.kErrorSnackBarTextColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Icon(
        isPrivate ? Icons.check : Icons.close,
        color: AppColors.kWhiteColor,
        size: 20,
      ),
    );
  }
}
