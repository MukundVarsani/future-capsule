import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/core/widgets/app_button.dart';
import 'package:future_capsule/core/widgets/snack_bar.dart';
import 'package:future_capsule/data/controllers/auth.controller.dart';
import 'package:future_capsule/data/controllers/user.controller.dart';
import 'package:future_capsule/data/models/user_modal.dart';
import 'package:future_capsule/data/services/firebase_storage.dart';
import 'package:future_capsule/features/select_files.dart';
import 'package:future_capsule/screens/profile/info_field.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  File? _selectedFile;
  late final String? _currentUserId;
  late final SelectFiles _selectFiles;
  final FirebaseStore _firebaseStore = FirebaseStore();

  final UserController _userController = Get.put(UserController());
  final AuthController _authController = Get.put(AuthController());

  void _selectProfileImage() async {
    XFile? xFile =
        await _selectFiles.selectImage(imageSource: ImageSource.gallery);
    if (xFile == null) return;
    _selectedFile = File(xFile.path);
    _showEditImageDialog();
  }

  _updateUserData(Map<String, dynamic> updatedData) {
    _userController.updateUserData(updatedData);
  }

  void _updateProfileImage(BuildContext context) async {
    try {
      if (_selectedFile == null) return;

      _showImageUploadingDialog();

      String? downloadUrl = await _firebaseStore.uploadImageToCloud(
          file: _selectedFile!, filePath: "UserProfileImage");

      if (downloadUrl != null) {
        await _updateUserData({"profilePicture": downloadUrl});

        appSnackBar(context: context, text: "Profile image updated");
      } else {
        throw Exception("Error uploading image");
      }
    } catch (e) {
      Vx.log("Error while updating profile image : ================== $e");
    } finally {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    }
  }

  Stream<UserModel?> getUserStream() async* {
    final userStream = _userController.getUserStream(_currentUserId!);
    await for (final user in userStream) {
      yield user;
    }
  }

  void logout() async {
    await _authController.signOut();
  }

  @override
  void initState() {
    _selectFiles = SelectFiles();
    _currentUserId = _userController.getUser?.uid;
    _userController.getUserTotalLikes();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _userController.getUserTotalLikes();
    return Scaffold(
        backgroundColor: AppColors.dDeepBackground,
        body: (_currentUserId != null)
            ? StreamBuilder<UserModel?>(
                stream: getUserStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text("No user data available"));
                  }
                  final userData = snapshot.data;
                  return Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 480,
                            padding: const EdgeInsets.only(bottom: 18),
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(26, 188, 156, 1),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(36),
                                bottomRight: Radius.circular(36),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "125",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22,
                                          color: Colors.white),
                                    ),
                                    Text("FOLLOWERS",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 12,
                                            color: Colors.white)),
                                  ],
                                ),
                                const Column(
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
                                            fontWeight: FontWeight.w800,
                                            fontSize: 12,
                                            color: Colors.white)),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Obx(
                                      () => Text(
                                        _userController.userLike.value
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Text("LIKES",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
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
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(30, 30, 30, 1),
                              borderRadius: BorderRadius.only(
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
                                _buildProfileImage(
                                    userData?.profilePicture, userData?.userId),
                                InfoField(
                                  fieldName: "Name",
                                  iconColor:
                                      const Color.fromRGBO(153, 113, 238, 1),
                                  fieldValue: userData?.name ?? "User",
                                  isEditable: true,
                                  leadingIcon: Icons.person_outline,
                                  onFieldValueChanged: (newName) =>
                                      _updateUserData({"name": newName}),
                                ),
                                InfoField(
                                  fieldName: "Bio",
                                  iconColor:
                                      const Color.fromRGBO(99, 197, 103, 1),
                                  fieldValue: userData?.bio ?? "write your bio",
                                  isEditable: true,
                                  leadingIcon: Icons.error_outline,
                                  onFieldValueChanged: (newBio) =>
                                      _updateUserData({"bio": newBio}),
                                ),
                                InfoField(
                                  fieldName: "Email",
                                  iconColor:
                                      const Color.fromRGBO(26, 188, 156, 1),
                                  fieldValue:
                                      userData?.email ?? "yourmail@gmail.com",
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 36, horizontal: 36),
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: const Color.fromRGBO(30, 30, 30, 1),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: logout,
                                        child: const Column(
                                          children: [
                                            Icon(
                                              Icons.logout,
                                              size: 28,
                                              color: Color.fromRGBO(
                                                  211, 47, 47, 1),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "log out",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      224, 224, 224, 1)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Column(
                                        children: [
                                          Icon(Icons.dock,
                                              size: 28,
                                              color: Color.fromRGBO(
                                                  153, 113, 238, 1)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Docks",
                                            style: TextStyle(
                                                color:
                                                    AppColors.kLightGreyColor),
                                          ),
                                        ],
                                      ),
                                      const Column(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            size: 28,
                                            color:
                                                Color.fromRGBO(99, 197, 103, 1),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Location",
                                            style: TextStyle(
                                                color:
                                                    AppColors.kLightGreyColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Expanded(
                                      child: Divider(
                                          color: AppColors.kSecondryTextColor)),
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Icon(Icons.family_restroom,
                                              size: 28,
                                              color: Color.fromRGBO(
                                                  99, 197, 103, 1)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Friends",
                                            style: TextStyle(
                                                color:
                                                    AppColors.kLightGreyColor),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Icon(
                                            Icons.notifications,
                                            size: 28,
                                            color:
                                                Color.fromRGBO(255, 111, 97, 1),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Notifications",
                                            style: TextStyle(
                                                color:
                                                    AppColors.kLightGreyColor),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Icon(
                                            Icons.settings,
                                            size: 28,
                                            color: Color.fromRGBO(
                                                153, 113, 238, 1),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Settings",
                                            style: TextStyle(
                                                color:
                                                    AppColors.kLightGreyColor),
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
                  );
                })
            : const Center(
                child: Text("User Not found"),
              ));
  }

  _showEditImageDialog() async {
    Uint8List fbytes = await _selectedFile!.readAsBytes();
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            height: 200,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          color: AppColors.kWarmCoralColor, width: 2)),
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(500),
                      child: Image.memory(fbytes, fit: BoxFit.cover)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: AppColors.kWhiteColor),
                      ),
                    ),
                    AppButton(
                      onPressed: () => _updateProfileImage(context),
                      child: const Text(
                        "Save",
                        style: TextStyle(color: AppColors.kWhiteColor),
                      ),
                    )
                  ],
                )
              ],
            ),
          ));
        });
  }

  _showImageUploadingDialog() {
    return showDialog(
        context: context,
        builder: (_) {
          return const Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation(AppColors.kWarmCoralColor),
            ),
          );
        });
  }

  Widget _buildProfileImage(String? userProfile, String? id) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              boxShadow: userProfile?.isNotEmpty == true
                  ? [
                      const BoxShadow(
                          color: Color.fromRGBO(153, 113, 238, 0.6),
                          blurRadius: 8,
                          spreadRadius: 0.5)
                    ]
                  : []),
          height: 130,
          width: 130,
          child: userProfile?.isNotEmpty == true
              ? CachedNetworkImage(
                  cacheKey: id,
                  imageUrl: userProfile!,
                  height: 130,
                  width: 130,
                  fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) => Container(
                    // width: 80.0,
                    // height: 80.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
          
                  // Builder: (context, child, loadingProgress) {
                  //   if (loadingProgress == null) return child;
                  //   return Container(
                  //     color: AppColors.dDeepBackground,
                  //     child: Center(
                  //       child: CircularProgressIndicator(
                  //         valueColor: const AlwaysStoppedAnimation<Color>(
                  //             Color.fromRGBO(153, 113, 238, 1)),
                  //         value: loadingProgress.expectedTotalBytes != null
                  //             ? loadingProgress.cumulativeBytesLoaded /
                  //                 (loadingProgress.expectedTotalBytes ?? 1)
                  //             : null,
                  //       ),
                  //     ),
                  //   );
                  // },
                  errorWidget: (_, __, ___) => Image.asset(AppImages.profile,
                      height: 130, width: 130, fit: BoxFit.cover),
                )
              : Image.asset(AppImages.profile,
                  height: 130, width: 130, fit: BoxFit.cover),
        ),
        Positioned(
          bottom: 4,
          right: 0,
          child: GestureDetector(
            onTap: _selectProfileImage,
            child: const CircleAvatar(
              backgroundColor: Color.fromRGBO(153, 113, 238, 1),
              radius: 25,
              child:
                  Icon(Icons.camera_alt_outlined, color: AppColors.kWhiteColor),
            ),
          ),
        ),
      ],
    );
  }
}
