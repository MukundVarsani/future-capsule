import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/core/widgets/app_button.dart';
import 'package:future_capsule/core/widgets/snack_bar.dart';
import 'package:future_capsule/data/models/user_model.dart';
import 'package:future_capsule/data/services/firebase_storage.dart';
import 'package:future_capsule/data/services/user_service.dart';
import 'package:future_capsule/features/select_files.dart';
import 'package:future_capsule/screens/profile/info_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // UserModel? userData;
  File? _selectedFile;
  late final String? _currentUserId;
  late final FirebaseStore _firebaseStore;
  late final SelectFiles _selectFiles;
  late final UserService _userService;
  
  
  void _selectProfileImage() async {
    XFile? xFile =
        await _selectFiles.selectImage(imageSource: ImageSource.gallery);
    if (xFile == null) return;
    _selectedFile = File(xFile.path);
    _showEditImageDialog();
  }

  _updateUserData(Map<String, dynamic> updatedData) {
    _userService.updateUserData(updatedData);
  }

  void _updateProfileImage(BuildContext context) async {
    try {
      if (_selectedFile == null) return;
      
      
      _showImageUploadingDialog();

      String? downloadUrl = await _firebaseStore.uploadImageToCloud(
          file: _selectedFile!, fileName: "UserProfileImage");

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

  @override
  void initState() {
    _userService = UserService();
    _firebaseStore = FirebaseStore();
    _selectFiles = SelectFiles();
    _currentUserId = _userService.userId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_currentUserId);
    return Scaffold(
        backgroundColor: AppColors.kScreenBackgroundColor,
        body: (_currentUserId != null)
            ? StreamBuilder<UserModel?>(
                stream:
                    _userService.getUserStream(_currentUserId),
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
                                _buildProfileImage(userData?.profilePicture),
                                InfoField(
                                  fieldName: "Name",
                                  fieldValue: userData?.name ?? "User",
                                  isEditable: true,
                                  leadingIcon: Icons.person_outline,
                                  onFieldValueChanged: (newName) =>
                                      _updateUserData({"name": newName}),
                                ),
                                InfoField(
                                  fieldName: "Bio",
                                  fieldValue: userData?.bio ?? "write your bio",
                                  isEditable: true,
                                  leadingIcon: Icons.error_outline,
                                  onFieldValueChanged: (newBio) =>
                                      _updateUserData({"bio": newBio}),
                                ),
                                InfoField(
                                  fieldName: "Email",
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
                                color: AppColors.kWhiteColor,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          const Icon(
                                            Icons.chat,
                                            size: 28,
                                            color:
                                                Color.fromRGBO(255, 111, 97, 1),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Chat",
                                            style: TextStyle(
                                                color:
                                                    AppColors.kLightGreyColor),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          const Icon(Icons.dock,
                                              size: 28,
                                              color: Color.fromRGBO(
                                                  153, 113, 238, 1)),
                                          const SizedBox(
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
                                      Column(
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            size: 28,
                                            color:
                                                Color.fromRGBO(99, 197, 103, 1),
                                          ),
                                          const SizedBox(
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
                                  Expanded(
                                      child: Divider(
                                          color: AppColors.kSecondryTextColor)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          const Icon(Icons.family_restroom,
                                              size: 28,
                                              color: Color.fromRGBO(
                                                  99, 197, 103, 1)),
                                          const SizedBox(
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
                                          const Icon(
                                            Icons.settings,
                                            size: 28,
                                            color: Color.fromRGBO(
                                                153, 113, 238, 1),
                                          ),
                                          const SizedBox(
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
                                      Column(
                                        children: [
                                          const Icon(
                                            Icons.notifications,
                                            size: 28,
                                            color:
                                                Color.fromRGBO(255, 111, 97, 1),
                                          ),
                                          const SizedBox(
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
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: AppColors.kWhiteColor),
                      ),
                    ),
                    AppButton(
                      onPressed: () => _updateProfileImage(context),
                      child: Text(
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
          return Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation(AppColors.kWarmCoralColor),
            ),
          );
        });
  }

  Widget _buildProfileImage(String? userProfile) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColors.kWarmCoralColor, width: 2)),
          height: 130,
          width: 130,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: userProfile?.isNotEmpty == true
                ? Image.network(
                    userProfile!,
                    height: 130,
                    width: 130,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Image.asset(AppImages.profile,
                        height: 130, width: 130, fit: BoxFit.cover),
                  )
                : Image.asset(AppImages.profile,
                    height: 130, width: 130, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          bottom: 4,
          right: 0,
          child: GestureDetector(
            onTap: _selectProfileImage,
            child: CircleAvatar(
              backgroundColor: AppColors.kWarmCoralColor,
              radius: 25,
              child: const Icon(Icons.camera_alt_outlined, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
