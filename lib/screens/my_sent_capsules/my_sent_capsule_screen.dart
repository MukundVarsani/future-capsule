import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/data/controllers/recipients.controller.dart';
import 'package:future_capsule/data/models/user_modal.dart';
import 'package:future_capsule/screens/my_sent_capsules/my_sent_capsules_tile.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class MySentCapuslesScreen extends StatefulWidget {
  const MySentCapuslesScreen({super.key});

  @override
  State<MySentCapuslesScreen> createState() => _MyCapuslesScreenState();
}

class _MyCapuslesScreenState extends State<MySentCapuslesScreen> {
  final RecipientController _recipientController =
      Get.put(RecipientController());


@override
  void initState() {
    _recipientController.getUsersYouSentCapsulesTo();
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
          () => _recipientController.isCapsuleLoading.value
              ? const Center(
                  child: CircularProgressIndicator.adaptive(
                      valueColor:
                          AlwaysStoppedAnimation(AppColors.kWarmCoralColor)),
                )
              : _recipientController.recipientUser.isNotEmpty
                  ? ListView.builder(
                      itemCount: _recipientController.recipientUser.length,
                      itemBuilder: (context, index) {
                        UserModel user =
                            _recipientController.recipientUser.value[index];

                        return GestureDetector(
                          // onTap: (){
                          // _recipientController.recipientCapsulesMap[_recipientController.recipientUserIds[index]]?.forEach((CapsuleModel c){
                          //   Vx.log(c.title);
                          // });
                          // },
                          child: MySentCapsuleTile(
                            openDate: _recipientController.recipientCapsulesMap[_recipientController.recipientUserIds[index]]?.last.title ?? "Not found",
                            createDate:  _recipientController.recipientUserSendDate[index].timeAgo(),
                            user: user,
                          ),
                        );
                      })
                  : const Center(
                      child: Text("No recipient user found"),
                    ),
        ));
  }
}
