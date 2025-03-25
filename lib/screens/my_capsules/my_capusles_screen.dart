import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/widgets/shimmer_effect/capsule_storage_shimmer.dart';
import 'package:future_capsule/data/controllers/capsule.controller.dart';
import 'package:future_capsule/data/models/capsule_modal.dart';
import 'package:future_capsule/screens/my_capsules/capsule_card.dart';
import 'package:future_capsule/screens/my_capsules/my_capsules_preview.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MyCapuslesScreen extends StatefulWidget {
  const MyCapuslesScreen({super.key});

  @override
  State<MyCapuslesScreen> createState() => _MyCapuslesScreenState();
}

class _MyCapuslesScreenState extends State<MyCapuslesScreen> {
  final CapsuleController _capsuleController = Get.put(CapsuleController());


  final List<CapsuleModel> _userCapsules = [];
  List<CapsuleModel> _filterCapsules = [];

  Stream<List<CapsuleModel>> capsuleStream() {
    return _capsuleController.getUserCapsuleStream();
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
                    const Text(
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
                          child: const Text(
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
                          child: const Text(
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
                          child: const Text(
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
                          child: const Text(
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
    if (mounted) setState(() {});
    Navigator.of(context, rootNavigator: true).pop();
  }

  void filterByOpenDate() {
    _filterCapsules = _userCapsules;
    _filterCapsules.sort((a, b) => a.openingDate.compareTo(b.openingDate));
    if (mounted) setState(() {});
    Navigator.of(context, rootNavigator: true).pop();
  }

  void getPrivateCapsule() {
    _filterCapsules = _userCapsules.where((d) {
      return d.privacy.isCapsulePrivate == true;
    }).toList();

    if (mounted) setState(() {});
    Navigator.of(context, rootNavigator: true).pop();
  }

  void getPrivateTime() {
    _filterCapsules = _userCapsules.where((d) {
      return d.privacy.isTimePrivate == true;
    }).toList();
    if (mounted) setState(() {});
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.dDeepBackground,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.dDeepBackground,
          title: const Row(
            children: [
              Text(
                "Capsules Storage",
                style: TextStyle(
                    color: AppColors.dNeonCyan, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: showFilterDialog,
              icon: const Icon(
                Icons.filter_alt_rounded,
                color: AppColors.kWhiteColor,
              ),
            ),
          ],
        ),
        body: StreamBuilder(
          stream: capsuleStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CapsuleStorageShimmer(); // Loading state
            }
        
            if (snapshot.hasError) {
              return Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: AppColors.kWhiteColor),
              );
            }
        
            var capsules = snapshot.data ?? [];
        
            if (capsules.isEmpty) {
              return const Center(
                  child: Text(
                "No Capsules Found",
                style: TextStyle(color: AppColors.kWhiteColor),
              ));
            }
        
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: capsules.length,
              itemBuilder: (context, index) {
                CapsuleModel capsule = capsules[index];
        
                return GestureDetector(
                    onTap: () =>
                        _navigateToCapsulePreview(context, capsule),
                    child: CapsuleCard(
                      capsule: capsule,
                    ));
              },
            );
          },
        ));
  }

  void _navigateToCapsulePreview(BuildContext context, CapsuleModel capsule) {
    PersistentNavBarNavigator.pushDynamicScreen(
      context,
      withNavBar: false,
      screen: MaterialPageRoute(
          builder: (_) => MyCapsulesPreview(
                capsule: capsule,
              )),
    );
  }
}
