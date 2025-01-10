import 'package:future_capsule/data/models/settings_model.dart';

class UserModel {
  final String userId;
  final String name;
  final String email;
  final String? profilePicture;
  final String? bio;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SettingsModel settings;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.bio,
    required this.createdAt,
    required this.updatedAt,
    required this.settings,
  });

  // Factory method to create a UserModel object from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profilePicture: json['profilePicture'] as String?,
      bio: json['bio'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      settings: SettingsModel.fromJson(json['settings'] as Map<String, dynamic>),
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'settings': settings.toJson(),
    };
  }
}
