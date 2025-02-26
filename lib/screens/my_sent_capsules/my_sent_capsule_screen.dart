import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/data/controllers/capsule.controller.dart';
import 'package:future_capsule/data/models/user_model.dart';
import 'package:future_capsule/screens/my_sent_capsules/my_sent_capsules_tile.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class MySentCapuslesScreen extends StatefulWidget {
  const MySentCapuslesScreen({super.key});

  @override
  State<MySentCapuslesScreen> createState() => _MyCapuslesScreenState();
}

class _MyCapuslesScreenState extends State<MySentCapuslesScreen> {
  final CapsuleController _capsuleController = Get.put(CapsuleController());

  @override
  void initState() {
    _capsuleController.getUserSentCapsule();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              const Text(
                "Sent Capsule",
                style: TextStyle(
                    color: AppColors.kWhiteColor, fontWeight: FontWeight.w500),
              ),
              Image.asset(
                AppImages.capsules,
                height: 40,
              ),
            ],
          ),
          backgroundColor: AppColors.kWarmCoralColor,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.filter_alt_rounded,
                color: AppColors.kWhiteColor,
              ),
            ),
          ],
        ),
        body: Obx(
          () => _capsuleController.isRecipientLoading.value
              ? const Center(
                  child: CircularProgressIndicator.adaptive(
                      valueColor:
                          AlwaysStoppedAnimation(AppColors.kWarmCoralColor)),
                )
              : _capsuleController.capsuleSentUsers.isNotEmpty
                  ? ListView.builder(
                      itemCount: _capsuleController.capsuleSentUsers.length,
                      itemBuilder: (context, index) {
                        UserModel user =
                            _capsuleController.capsuleSentUsers.value[index];

                        return MySentCapsuleTile(
                          openDate: _capsuleController
                                  .recipientCapsuleMap[user.userId]?[0].title ??
                              "Not found",
                          createDate: _capsuleController
                                  .recipientCapsuleMap[user.userId]?[0].createdAt.timeAgo() ??
                              "Not found",
                          user: user,
                        );
                      })
                  : const Center(
                      child: Text("No recipient user found"),
                    ),
        ));
  }
}
