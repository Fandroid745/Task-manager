import 'package:flutter/material.dart';

class ThemeService {
  // Singleton instance
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  // ValueNotifier for reactive ThemeMode updates across the app
  final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  ThemeMode get themeMode => themeModeNotifier.value;

  void setThemeMode(ThemeMode mode) {
    themeModeNotifier.value = mode;
  }
}
