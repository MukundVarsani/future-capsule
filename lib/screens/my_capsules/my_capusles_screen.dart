import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/data/models/capsule_model.dart';
import 'package:future_capsule/data/services/capsule_service.dart';
import 'package:future_capsule/data/services/user_service.dart';

import 'package:future_capsule/screens/my_capsules/capsule_tile.dart';
import 'package:future_capsule/screens/my_capsules/my_capsules_preview.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class MyCapuslesScreen extends StatefulWidget {
  const MyCapuslesScreen({super.key});

  @override
  State<MyCapuslesScreen> createState() => _MyCapuslesScreenState();
}

class _MyCapuslesScreenState extends State<MyCapuslesScreen> {
  late CapsuleService _capsuleService;
  late UserService _userService;
  late final String userId;
  List<CapsuleModel> _userCapsules = [];
  List<CapsuleModel> _filterCapsules = [];

  @override
  void initState() {
    _userService = UserService();
    _capsuleService = CapsuleService();
    userId = _userService.userId ?? "NA";
    getUserCapsules(userId);
    super.initState();
  }

  void getUserCapsules(String userId) async {
    _userCapsules = await _capsuleService.getUserCreateCapsule(userId);
    _filterCapsules = _userCapsules;
    if (mounted) setState(() {});
  }

  void showFilterDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      barrierColor: Colors.transparent,
      builder: (_) {
        return Stack(
          children: [
            Positioned(
              right: 5,
              top: 55,
              child: Container(
                height: 180,
                width: 200,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.kWhiteColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(5, 5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sort by : ",
                      style: TextStyle(
                        color: AppColors.kWarmCoralColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: filterByOpenDate,
                          child: Text(
                            "Opening date",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.kWarmCoralColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: getPrivateCapsule,
                          child: Text(
                            "Private Capsule",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.kWarmCoralColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: filterByCreateDate,
                          child: Text(
                            "Created date",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.kWarmCoralColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: getPrivateTime,
                          child: Text(
                            "Private time",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.kWarmCoralColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void filterByCreateDate() {
    _filterCapsules = _userCapsules;
    _filterCapsules.sort((b, a) => a.createdAt.compareTo(b.createdAt));
    setState(() {});
    Navigator.of(context, rootNavigator: true).pop();
  }

  void filterByOpenDate() {
    _filterCapsules = _userCapsules;
    _filterCapsules.sort((a, b) => a.openingDate.compareTo(b.openingDate));
    setState(() {});
    Navigator.of(context, rootNavigator: true).pop();
  }

  void getPrivateCapsule() {
    _filterCapsules = _userCapsules.where((d) {
      return d.privacy.isCapsulePrivate == true;
    }).toList();

    setState(() {});
    Navigator.of(context, rootNavigator: true).pop();
  }

  void getPrivateTime() {
    _filterCapsules = _userCapsules.where((d) {
      return d.privacy.isTimePrivate == true;
    }).toList();
    setState(() {});
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                "Capsules Storage",
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
              onPressed: showFilterDialog,
              icon: Icon(
                Icons.filter_alt_rounded,
                color: AppColors.kWhiteColor,
              ),
            ),
          ],
        ),
        body: RefreshIndicator.adaptive(
          color: AppColors.kWarmCoralColor,
          onRefresh: () async => getUserCapsules(userId),
          child: ListView.builder(
              itemCount: _filterCapsules.length,
              itemBuilder: (context, index) {
                CapsuleModel capsule = _filterCapsules[index];
                DateTime createdtime = capsule.createdAt;
                DateTime openTime = capsule.openingDate;
                String formattedDate =
                    DateFormat('dd-MMM-yy, HH:mm:ss').format(openTime);

                String? imgUrl = capsule.media[0].type.contains('video')
                    ? capsule.media[0].thumbnail
                    : capsule.media[0].url;

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => MyCapsulesPreview(
                                capsuleTitle: capsule.title,
                                capsuleDescription: capsule.description ?? "..",
                                openDateTime: capsule.openingDate,
                                isTimePrivate: capsule.privacy.isTimePrivate,
                                isCapsulePrivate:
                                    capsule.privacy.isCapsulePrivate,
                                mediaURL: capsule.media[0].url,
                                isVideoFile: capsule.media[0].type.contains('video'),
                              )),
                    );
                  },
                  child: CapsuleTile(
                    capsuleTitle: capsule.title,
                    imgURL: imgUrl ?? '',
                    createDate: createdtime.timeAgo(),
                    isCapsulePrivate: capsule.privacy.isCapsulePrivate,
                    isTimePrivate: capsule.privacy.isTimePrivate,
                    openDate: formattedDate,
                  ),
                );
              }),
        ));
  }
}
