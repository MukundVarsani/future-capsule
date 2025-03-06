import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/data/controllers/recipients.controller.dart';
import 'package:future_capsule/screens/my_futures/my_future_tile.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class MyFutureCapusles extends StatefulWidget {
  const MyFutureCapusles({super.key});

  @override
  State<MyFutureCapusles> createState() => _MyFutureCapuslesState();
}

class _MyFutureCapuslesState extends State<MyFutureCapusles> {
  final RecipientController _recipientController =
      Get.put(RecipientController());

  @override
  Widget build(BuildContext context) {
    _recipientController.getMyFutureCapusle();
    _recipientController.getSortedSharedDate();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Text(
              "My Future",
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
      body: Obx(() => ListView.builder(
          itemCount: _recipientController.myFutureCapusles.length,
          itemBuilder: (context, index) {
            return MyFutureTile(
                capsule: _recipientController.myFutureCapusles[index],
                lastDate:  _recipientController.sharedDate[index],
                
                );
          })),
    );
  }
}
