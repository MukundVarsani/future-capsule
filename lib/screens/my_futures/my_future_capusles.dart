import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/widgets/shimmer_effect/user_tile_shimmer.dart';
import 'package:future_capsule/data/controllers/recipients.controller.dart';
import 'package:future_capsule/data/models/capsule_modal.dart';
import 'package:future_capsule/data/models/user_modal.dart';
import 'package:future_capsule/screens/my_futures/animation.dart';
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

  String? searchKeyword;
  late final Stream<Map<String, List<Map<String, dynamic>>>>
      sharedCapsulesStream;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    sharedCapsulesStream =
        _recipientController.fetchSharedCapsulesWithUsersOPTStream();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: AppColors.dDeepBackground,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.dDeepBackground,
            title: const Row(
              children: [
                Text(
                  "My Future",
                  style: TextStyle(
                      color: AppColors.dNeonCyan, fontWeight: FontWeight.w700),
                ),
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
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(
                      color: AppColors.kWhiteColor,
                      fontWeight: FontWeight.w600),
                  cursorColor: AppColors.dActiveColorPrimary,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: AppColors.kLightGreyColor,
                    hintText: 'Search...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide:
                            const BorderSide(color: AppColors.kLightGreyColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                            color: AppColors.dActiveColorPrimary)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide:
                            const BorderSide(color: AppColors.kLightGreyColor)),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchKeyword = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: StreamBuilder<Map<String, List<Map<String, dynamic>>>>(
                  stream: sharedCapsulesStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListView.builder(
                          itemCount: 5,
                          itemBuilder: (c, i) => const UserTileShimmer());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("No capsules found",
                            style: TextStyle(color: Colors.white)),
                      );
                    }

                    final myFuture = snapshot.data!;
                    final userList = _recipientController.myFutureUserList;
                    final filteredUserList =
                        searchKeyword != null && searchKeyword!.isNotEmpty
                            ? userList
                                .where((user) => user.name
                                    .toLowerCase()
                                    .contains(searchKeyword!.toLowerCase()))
                                .toList()
                            : userList;

                    if (filteredUserList.isEmpty) {
                      return const Center(
                        child: Text("No matching users found",
                            style: TextStyle(color: Colors.white)),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredUserList.length,
                      itemBuilder: (context, index) {
                        final UserModel user = filteredUserList[index];
                        final userCapsules = myFuture[user.userId] ?? [];

                        if (userCapsules.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        final List<CapsuleModel> capsules = userCapsules
                            .map((cap) => CapsuleModel.fromJson(
                                cap['data'] as Map<String, dynamic>))
                            .toList();

                        final List<String> dateList = userCapsules
                            .map((data) => data['sharedDate'].toString())
                            .toList();

                        return ManualAnimatedUserTile(
                          index: index,
                          child: GestureDetector(
                            onTap: () {
                              Get.to(
                                () => MyFutureCapsuleView(
                                    capsules: capsules,
                                    user: user,
                                    date: dateList),
                              );
                              searchKeyword = "";
                              _searchController.value =
                                  const TextEditingValue(text: "");
                              FocusScope.of(context).unfocus();
                            },
                            child: MyFutureTile(
                              user: user,
                              lastDate: dateList.first.toDate()!,
                              capsule: capsules.first,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }
}
