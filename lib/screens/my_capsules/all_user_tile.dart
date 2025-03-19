import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:velocity_x/velocity_x.dart';

class AllUserTile extends StatelessWidget {
  const AllUserTile(
      {super.key, this.isUserSelect = false, this.name, this.imgURL});

  final bool isUserSelect;
  final String? name;
  final String? imgURL;

  @override
  Widget build(BuildContext context) {

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.bounceIn,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isUserSelect
            ? const Color.fromRGBO(62, 62, 62, 1)
            : const Color.fromRGBO(30, 30, 30, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
             
              borderRadius: BorderRadius.circular(100),
              boxShadow: const [BoxShadow(blurRadius: 5,spreadRadius: 1, color:  Color.fromRGBO(0, 255, 255, 0.5))]
            ),
            child: (imgURL.isNotEmptyAndNotNull)
                ? ClipRRect(
                     borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                      imageUrl: imgURL!,
                      filterQuality: FilterQuality.high,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Align(
                        alignment: Alignment
                            .center,
                        child: SizedBox(
                          height: 30, // Explicitly set smaller height
                          width: 30, // Explicitly set smaller width
                          child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                            valueColor: const AlwaysStoppedAnimation(
                                AppColors.kWhiteColor),
                            strokeWidth: 2, // Make it thinner
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                )
                : Image.asset(
                    AppImages.profile,
                    height: 60,
                  ),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            name ?? "No name",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.kWhiteColor),
          ),
          const Spacer(),
          if (isUserSelect)
            const Icon(
              Icons.check_circle,
              color: AppColors.kWhiteColor,
              size: 28,
            )
        ],
      ),
    );
  }
}
