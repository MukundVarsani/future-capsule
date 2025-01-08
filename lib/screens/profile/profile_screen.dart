import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kScreenBackgroundColor,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 430,
                padding: const EdgeInsets.only(bottom: 18),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 111, 97, 1),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "125",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white),
                        ),
                        Text("FOLLOWERS",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.white)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "150",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white),
                        ),
                        Text("FOLLOWING",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.white)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "476",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white),
                        ),
                        Text("LIKES",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                  height: 350,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: AppColors.kWhiteColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        height: 100,
                        width: 100,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(500),
                            child: Image.asset(
                              AppImages.profile,
                              fit: BoxFit.cover,
                            )),
                      ),
                      Text(
                        "Miky Dowells",
                        style: TextStyle(
                          fontSize: 28,
                          color: AppColors.kPrimaryTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      SizedBox(
                        width: 300,
                        child: Text(
                          "😁😁😁😁😁😁😁😁😁\nI love creating surprise capsules!\n😁😁😁😁😁😁😁😁😁",
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.kLightGreyColor,
                                overflow: TextOverflow.fade
                              ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 36, horizontal: 36),
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: AppColors.kWhiteColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const Icon(
                                Icons.chat,
                                size: 28,
                                color: Color.fromRGBO(255, 111, 97, 1),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Chat",
                                style:
                                    TextStyle(color: AppColors.kLightGreyColor),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(Icons.dock,
                                  size: 28,
                                  color: Color.fromRGBO(153, 113, 238, 1)),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Docks",
                                style:
                                    TextStyle(color: AppColors.kLightGreyColor),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 28,
                                color: Color.fromRGBO(99, 197, 103, 1),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Location",
                                style:
                                    TextStyle(color: AppColors.kLightGreyColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                          child: Divider(color: AppColors.kSecondryTextColor)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const Icon(Icons.family_restroom,
                                  size: 28,
                                  color: Color.fromRGBO(99, 197, 103, 1)),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Friends",
                                style:
                                    TextStyle(color: AppColors.kLightGreyColor),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(
                                Icons.settings,
                                size: 28,
                                color: Color.fromRGBO(153, 113, 238, 1),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Settings",
                                style:
                                    TextStyle(color: AppColors.kLightGreyColor),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(
                                Icons.notifications,
                                size: 28,
                                color: Color.fromRGBO(255, 111, 97, 1),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Notifications",
                                style:
                                    TextStyle(color: AppColors.kLightGreyColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
