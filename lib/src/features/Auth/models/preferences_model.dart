class PreferencesModel {
  final bool darkMode;
  final String language;
  final bool notificationsEnabled;

  PreferencesModel({
    required this.darkMode,
    required this.language,
    required this.notificationsEnabled,
  });

  Map<String, dynamic> toMap() {
    return {
      'darkMode': darkMode,
      'language': language,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  factory PreferencesModel.fromMap(Map<String, dynamic> map) {
    return PreferencesModel(
      darkMode: map['darkMode'] ?? false,
      language: map['language'] ?? 'en',
      notificationsEnabled: map['notificationsEnabled'] ?? true,
    );
  }
}
