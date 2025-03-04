class SettingsModel {
  final bool notificationsEnabled;
  final String theme;
  final String language;

  SettingsModel({
    required this.notificationsEnabled,
    required this.theme,
    required this.language,
  });

  // Factory method to create a SettingsModel object from JSON
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      notificationsEnabled: json['notificationsEnabled'] as bool,
      theme: json['theme'] as String,
      language: json['language'] as String,
    );
  }

  // Method to convert a SettingsModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'theme': theme,
      'language': language,
    };
  }
}
