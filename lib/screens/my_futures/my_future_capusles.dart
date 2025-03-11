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

class MyFutureCapusles extends StatefulWidget {
  const MyFutureCapusles({super.key});

  @override
  State<MyFutureCapusles> createState() => _MyFutureCapuslesState();
}

class _MyFutureCapuslesState extends State<MyFutureCapusles> {
  final RecipientController _recipientController =
      Get.put(RecipientController());

  @override
  void initState() {
    _recipientController.fetchSharedCapsulesWithUsersOPT();
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
      body: RefreshIndicator(
        onRefresh: () => _recipientController.fetchSharedCapsulesWithUsersOPT(),
        color: AppColors.kWarmCoralColor,
        child: Obx(
          () => _recipientController.isMyFutureLoading.value
              ? const Center(
                  child: CircularProgressIndicator.adaptive(
                      valueColor:
                          AlwaysStoppedAnimation(AppColors.kWarmCoralColor)),
                )
              : ListView.builder(
                  itemCount: _recipientController.myFutureUserList.length,
                  itemBuilder: (context, index) {
                    UserModel user =
                        _recipientController.myFutureUserList[index];

                    CapsuleModel capsule = CapsuleModel.fromJson(
                        _recipientController.myFuture[user.userId]![0]['data']
                            as Map<String, dynamic>);

                    List<CapsuleModel> capsules = _recipientController
                        .myFuture[user.userId]!
                        .map((cap) => CapsuleModel.fromJson(
                            cap['data'] as Map<String, dynamic>))
                        .toList();

                    String date = _recipientController.myFuture[user.userId]![0]
                        ['sharedDate'];

                     List<String> dateList  = _recipientController.myFuture[user.userId]!.map((data)=> data['sharedDate'].toString()).toList();
                    return GestureDetector(
                      onTap: () {

                        Vx.log("Clicled");
                        Get.to(MyFutureCapsuleView(
                          capsules: capsules,
                          user: user,
                          date: dateList,
                        ));
                      },
                      child: MyFutureTile(
                        user: user,
                        lastDate: date.toDate()!,
                        capsule: capsule,
                      ),
                    );
                  }),
        ),
      ),
    );
  }
}
