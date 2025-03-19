import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/data/controllers/capsule.controller.dart';
import 'package:future_capsule/data/controllers/user.controller.dart';
import 'package:future_capsule/data/models/capsule_modal.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
    _capsuleController.getMySentCapusles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dDeepBackground,
      appBar: AppBar(
        backgroundColor: AppColors.dDeepBackground,
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
        () => _capsuleController.isMyCapsuleSentLoading.value
            ? const Center(child: CircularProgressIndicator.adaptive())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        height: 300,
                        enableInfiniteScroll: false,
                      ),
                      items: [
                        ..._capsuleController.mySentCapsules
                            .take(3)
                            .map((CapsuleModel capsule) {
                          return GestureDetector(
                            onTap: () {
                              Vx.log(capsule.title);
                            },
                            child: carasolItem(
                                image: (capsule.media[0].thumbnail != null &&
                                        capsule.media[0].thumbnail!.isNotEmpty)
                                    ? capsule.media[0].thumbnail!
                                    : capsule.media[0].url,
                                title: capsule.title,
                                cId: capsule.capsuleId,
                                status: capsule.status,
                                date: capsule.openingDate),
                          );
                        })
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ..._capsuleController.mySentCapsules
                        .skip(3)
                        .map((CapsuleModel capsule) {
                      return capsuleCard(
                          image: (capsule.media[0].thumbnail != null &&
                                  capsule.media[0].thumbnail!.isNotEmpty)
                              ? capsule.media[0].thumbnail!
                              : capsule.media[0].url,
                          title: capsule.title,
                          status: capsule.status,
                          date: capsule.openingDate,
                          cId: capsule.capsuleId);
                    }),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.083,
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget carasolItem(
      {required String image,
      required String title,
      required String status,
      required String cId,
      required DateTime date}) {
    List<String> img = getProfileUrls(cId);
    return Stack(
      children: [
        SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(32, 32, 32, 0.6),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 12,
          child: Text(
            "Opens: ${DateFormat('dd/MM/yy').format(date)}",
            style: const TextStyle(
                color: AppColors.kWhiteColor, fontWeight: FontWeight.w600),
          ),
        ),
        // Adjust size
        Stack(
          children: List.generate(img.length, (index) {
            return Positioned(
              left: index * 25.0 + 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.dInActiveColorPrimary),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    imageUrl: img[index],
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }),
        ),
        Positioned(
          bottom: 50,
          left: 12,
          child: SizedBox(
            width: 250,
            child: Text(
              title,
              style: const TextStyle(
                  color: AppColors.dNeonCyan,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: MediaQuery.sizeOf(context).width / 2 - 76,
          child: Text(
            status.toUpperCase(),
            style: TextStyle(
                color: (status.toUpperCase() == "LOCKED")
                    ? const Color.fromRGBO(34, 197, 94, 1)
                    : const Color.fromRGBO(153, 113, 238, 1),
                fontWeight: FontWeight.w800,
                fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget capsuleCard({
    required String image,
    required String title,
    required String status,
    required DateTime date,
    required String cId,
  }) {
    List<String> img = getProfileUrls(cId);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      height: 260,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 31, 29, 29),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
              color: Color.fromRGBO(0, 255, 255, 0.5),
              blurRadius: 8,
              spreadRadius: 0.1)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 200,
                width: double.maxFinite,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18).copyWith(
                      bottomLeft: const Radius.circular(0),
                      bottomRight: const Radius.circular(0)),
                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 200,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18).copyWith(
                      bottomLeft: const Radius.circular(0),
                      bottomRight: const Radius.circular(0)),
                  color: const Color.fromRGBO(32, 32, 32, 0.6),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: SizedBox(
                  width: 250,
                  child: Text(
                    title,
                    style: const TextStyle(
                        color: AppColors.dNeonCyan,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 50,
                width: 100,
                child: Stack(
                  children: List.generate(img.length, (index) {
                    return Positioned(
                      left: index * 25.0 + 12,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: const Color.fromARGB(255, 31, 29, 29),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: img[index],
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const Spacer(),
              Text(
                "Opens: ${DateFormat('dd/MM/yy').format(date)}",
                style: const TextStyle(
                    color: AppColors.dSoftGrey, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                status,
                style: const TextStyle(
                    color: Color.fromRGBO(34, 197, 94, 1),
                    fontWeight: FontWeight.w800,
                    fontSize: 14),
              ),
              const SizedBox(
                width: 12,
              )
            ],
          ),
        ],
      ),
    );
  }

  List<String> getProfileUrls(String capsuleId) {
    if (!_capsuleController.capsuleRecipientsMap.containsKey(capsuleId)) {
      return [];
    }

    return _capsuleController.capsuleRecipientsMap[capsuleId]!.map((user) {
      return user.profilePicture?.isNotEmpty == true
          ? user.profilePicture!
          : "https://cdn-icons-png.flaticon.com/512/3135/3135715.png";
    }).toList();
  }
}
