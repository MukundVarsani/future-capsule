import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/data/controllers/recipients.controller.dart';
import 'package:future_capsule/data/models/capsule_modal.dart';
import 'package:future_capsule/data/models/user_modal.dart';
import 'package:future_capsule/screens/my_futures/my_future_capsule_view.dart';
import 'package:future_capsule/screens/my_futures/my_future_tile.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class MyFutureCapsules extends StatefulWidget {
  const MyFutureCapsules({super.key});

  @override
  State<MyFutureCapsules> createState() => _MyFutureCapsulesState();
}

class _MyFutureCapsulesState extends State<MyFutureCapsules> {
  final RecipientController _recipientController =
      Get.put(RecipientController());

  @override
  void initState() {
    super.initState();
    _recipientController.fetchSharedCapsulesWithUsersOPT();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dDeepBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.dDeepBackground,
        title: Row(
          children: [
            const Text(
              "My Future",
              style: TextStyle(
                  color: AppColors.dNeonCyan, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 8),
            Image.asset(AppImages.capsules, height: 40),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_alt_rounded,
                color: AppColors.dSoftGrey),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _recipientController.fetchSharedCapsulesWithUsersOPT(),
        color: AppColors.dNeonCyan,
 
        child: Obx(
          () {
            if (_recipientController.isMyFutureLoading.value) {
              // return UserTileShimmer();
              return const Center(
                child: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation(AppColors.kWarmCoralColor),
                ),
              );
            }

            final userList = _recipientController.myFutureUserList;
            if (userList.isEmpty) {
              return const Center(
                  child: Text("No capsules found",
                      style: TextStyle(color: Colors.white)));
            }

            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                final UserModel user = userList[index];
                final userCapsules =
                    _recipientController.myFuture[user.userId] ?? [];

                if (userCapsules.isEmpty) return const SizedBox.shrink();

                final List<CapsuleModel> capsules = userCapsules
                    .map((cap) => CapsuleModel.fromJson(
                        cap['data'] as Map<String, dynamic>))
                    .toList();

                final List<String> dateList = userCapsules
                    .map((data) => data['sharedDate'].toString())
                    .toList();

                return GestureDetector(
                  onTap: () {
                    Get.to(() => MyFutureCapsuleView(
                        capsules: capsules, user: user, date: dateList));
                  },
                  child: MyFutureTile(
                    user: user,
                    lastDate: dateList.first.toDate()!,
                    capsule: capsules.first,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
