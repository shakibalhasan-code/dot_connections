import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ThemeController manages the application's theme state
///
/// This controller handles switching between light and dark themes,
/// persisting theme preferences, and providing easy access to current theme.
///
/// Features:
/// - Toggle between light and dark themes
/// - Persist theme preference using local storage
/// - System theme detection
/// - Easy customization for different color schemes
///
/// Usage:
/// ```dart
/// final themeController = Get.find<ThemeController>();
/// themeController.toggleTheme(); // Switch themes
/// bool isDark = themeController.isDarkMode; // Check current theme
/// ```
class ThemeController extends GetxController {
  /// Storage key for theme preference
  static const String _themeKey = 'isDarkMode';

  /// Observable theme mode
  var _isDarkMode = false.obs;

  /// Getter for current theme mode
  bool get isDarkMode => _isDarkMode.value;

  /// Getter for current theme mode (observable)
  RxBool get isDarkModeRx => _isDarkMode;

  /// Getter for current ThemeMode
  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _loadThemePreference();
  }

  /// Load theme preference from storage
  /// TODO: Implement actual storage when adding shared_preferences or get_storage package
  void _loadThemePreference() {
    // For now, defaults to light theme
    // When implementing storage:
    // final prefs = await SharedPreferences.getInstance();
    // _isDarkMode.value = prefs.getBool(_themeKey) ?? false;
    _isDarkMode.value = false;

    // Apply the loaded theme
    Get.changeThemeMode(themeMode);
  }

  /// Toggle between light and dark theme
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _saveThemePreference();
    Get.changeThemeMode(themeMode);

    // Optional: Show feedback to user
    _showThemeChangeSnackbar();
  }

  /// Switch to light theme
  void setLightTheme() {
    if (_isDarkMode.value) {
      _isDarkMode.value = false;
      _saveThemePreference();
      Get.changeThemeMode(ThemeMode.light);
      _showThemeChangeSnackbar();
    }
  }

  /// Switch to dark theme
  void setDarkTheme() {
    if (!_isDarkMode.value) {
      _isDarkMode.value = true;
      _saveThemePreference();
      Get.changeThemeMode(ThemeMode.dark);
      _showThemeChangeSnackbar();
    }
  }

  /// Set theme based on system preference
  void setSystemTheme() {
    var brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    _isDarkMode.value = brightness == Brightness.dark;
    _saveThemePreference();
    Get.changeThemeMode(ThemeMode.system);
    _showThemeChangeSnackbar();
  }

  /// Save theme preference to storage
  /// TODO: Implement actual storage when adding shared_preferences or get_storage package
  void _saveThemePreference() {
    // For now, this is a placeholder
    // When implementing storage:
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool(_themeKey, _isDarkMode.value);
  }

  /// Show theme change feedback
  void _showThemeChangeSnackbar() {
    Get.snackbar(
      'Theme Changed',
      _isDarkMode.value ? 'Switched to Dark Mode' : 'Switched to Light Mode',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      isDismissible: true,
    );
  }

  /// Get icon for current theme (useful for theme toggle buttons)
  IconData get themeIcon {
    return _isDarkMode.value ? Icons.light_mode : Icons.dark_mode;
  }

  /// Get description for current theme
  String get themeDescription {
    return _isDarkMode.value ? 'Light Mode' : 'Dark Mode';
  }

  /// Check if current theme matches system theme
  bool get isSystemTheme {
    var brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return (_isDarkMode.value && brightness == Brightness.dark) ||
        (!_isDarkMode.value && brightness == Brightness.light);
  }

  /// Reset theme to system default
  void resetToSystemDefault() {
    setSystemTheme();
  }

  /// For advanced users: Custom theme colors
  /// This can be extended to support multiple color schemes
  Map<String, dynamic> getCustomThemeData() {
    return {
      'isDarkMode': _isDarkMode.value,
      'primaryColor': _isDarkMode.value ? '#E1BBFF' : '#9604B6',
      'backgroundColor': _isDarkMode.value ? '#1C1B1F' : '#FFFFFF',
      'surfaceColor': _isDarkMode.value ? '#1C1B1F' : '#FFFFFF',
      'textColor': _isDarkMode.value ? '#E6E1E5' : '#2D2D2D',
    };
  }
}
