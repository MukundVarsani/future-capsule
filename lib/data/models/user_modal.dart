import 'package:future_capsule/data/models/settings_modal.dart';

class UserModel {
  final String userId;
  final String name;
  final String email;
  final String? profilePicture;
  final String? bio;
  final String? fcmToken;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SettingsModel settings;
  final int? hintCount;

  UserModel({
    required this.fcmToken,
    required this.userId,
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.bio,
    required this.createdAt,
    required this.updatedAt,
    required this.settings,
    this.hintCount = 0,
  });

  // Factory method to create a UserModel object from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profilePicture: json['profilePicture'] as String?,
      bio: json['bio'] as String?,
      fcmToken: json['fcmToken'] as String?,
      hintCount: json['hintCount'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      settings:
          SettingsModel.fromJson(json['settings'] as Map<String, dynamic>),
    );
  }

  // Method to convert a UserModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'bio': bio,
      'fcmToken': fcmToken,
      'hintCount': hintCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'settings': settings.toJson(),
    };
  }
}
