import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/core/widgets/shimmer_effect/user_tile_shimmer.dart';
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
    // Start listening to the stream
    _recipientController.fetchSharedCapsulesWithUsersOPTStream().listen((data) {
      setState(() {}); // Update UI whenever new data is received
    });
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
      body: StreamBuilder<Map<String, List<Map<String, dynamic>>>>(
        stream: _recipientController.fetchSharedCapsulesWithUsersOPTStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
                itemCount: 5, itemBuilder: (c, i) => const UserTileShimmer());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text("No capsules found",
                    style: TextStyle(color: Colors.white)));
          }

          final myFuture = snapshot.data!;
          final userList = _recipientController.myFutureUserList;

          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final UserModel user = userList[index];
              final userCapsules = myFuture[user.userId] ?? [];

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
    );
  }
}
