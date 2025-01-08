import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/screens/profile/info_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "Miky Dowells";
  String bio = "I love to create surprise";

  void _updateName(String newName) {
    setState(() {
      name = newName;
    });
  }
  void _updateBio(String newBio) {
    setState(() {
      bio = newBio;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kScreenBackgroundColor,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 480,
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
                height: 400,
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
                      height: 60,
                    ),
                    Stack(children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        height: 130,
                        width: 130,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(500),
                            child: Image.asset(
                              AppImages.profile,
                              fit: BoxFit.cover,
                            )),
                      ),
                      Positioned(
                          bottom: 4,
                          right: 0,
                          child: Container(
                              height: 50,
                              width: 50,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: AppColors.kWarmCoralColor,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: AppColors.kWhiteColor,
                              ))),
                    ]),
                    InfoField(
                      fieldName: "Name",
                      fieldValue: name,
                      isEditable: true,
                      leadingIcon: Icons.person_outline,
                      onFieldValueChanged: _updateName,
                    ),
                    InfoField(
                      fieldName: "Bio",
                      fieldValue: bio,
                      isEditable: true,
                      leadingIcon: Icons.error_outline,
                      onFieldValueChanged: _updateBio,
                    ),
                   const InfoField(
                      fieldName: "Email",
                      fieldValue: "user@gmail.com",
                      isEditable: false,
                      leadingIcon: Icons.email_outlined,
                      
                    ),
                  ],
                ),
              ),
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
