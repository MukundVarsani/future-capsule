class Settings {
  final bool notificationsEnabled;
  final String theme;
  final String language;

  Settings({
    required this.notificationsEnabled,
    required this.theme,
    required this.language,
  });

  // Factory method to create a Settings object from JSON
  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      notificationsEnabled: json['notificationsEnabled'] as bool,
      theme: json['theme'] as String,
      language: json['language'] as String,
    );
  }

  // Method to convert a Settings object to JSON
  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'theme': theme,
      'language': language,
    };
  }
}
