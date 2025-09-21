import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enhanced controller for managing app language with instant switching
///
/// This controller provides:
/// - Instant language switching without hot reload
/// - Integration with both GetX and EasyLocalization
/// - Proper state management for all UI components
/// - Persistent language preferences
class LanguageController extends GetxController {
  static const String _languageKey = 'selected_language';

  // Observable for reactive updates
  final _currentLocale = 'en'.obs;

  String get currentLanguage => _currentLocale.value;

  /// Supported languages that match EasyLocalization.supportedLocales
  final List<String> supportedLanguages = ['en', 'es'];

  /// Language names for display
  final Map<String, String> languageNames = {'en': 'English', 'es': 'Español'};

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  /// Load the saved language preference from storage
  void _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey) ?? 'en';
      if (supportedLanguages.contains(savedLanguage)) {
        _currentLocale.value = savedLanguage;
        if (Get.context != null) {
          await Get.context!.setLocale(Locale(savedLanguage));
          // Update UI immediately after loading saved language
          update();
        }
      }
    } catch (e) {
      print('Error loading saved language: $e');
    }
  }

  /// Change the app language with instant UI updates
  void changeLanguage(String languageCode) async {
    if (supportedLanguages.contains(languageCode) && Get.context != null) {
      try {
        // Debug: Print current and new language
        print(
          'Changing language from ${_currentLocale.value} to $languageCode',
        );

        // Update the observable first for immediate GetX widget updates
        _currentLocale.value = languageCode;

        // Set the EasyLocalization locale and wait for it to complete
        await Get.context!.setLocale(Locale(languageCode));

        // Wait a moment for EasyLocalization to fully process the change
        await Future.delayed(const Duration(milliseconds: 150));

        // Save the preference
        _saveLanguagePreference(languageCode);

        // CRITICAL: Update all GetBuilder widgets immediately
        // This ensures all widgets using GetBuilder<LanguageController> rebuild
        update();

        // Force update the entire GetX app and rebuild the GetMaterialApp
        // This is crucial for updating the app-wide locale
        Get.forceAppUpdate();

        // Additionally, update Get's locale for proper GetX integration
        Get.updateLocale(Locale(languageCode));

        print('New locale set: $languageCode');

        // Show success message with proper translation
        // Use Future.delayed to ensure translations are fully loaded
        Future.delayed(const Duration(milliseconds: 200), () {
          try {
            Get.snackbar(
              'language_changed'.tr(),
              'language_updated_to'.tr(
                namedArgs: {'language': getLanguageName(languageCode)},
              ),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.green.withOpacity(0.8),
              colorText: Colors.white,
              margin: const EdgeInsets.all(8),
              snackPosition: SnackPosition.TOP,
            );
          } catch (e) {
            // Fallback if translation keys don't exist
            Get.snackbar(
              'Language Changed',
              'Language updated to ${getLanguageName(languageCode)}',
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.green.withOpacity(0.8),
              colorText: Colors.white,
              margin: const EdgeInsets.all(8),
              snackPosition: SnackPosition.TOP,
            );
          }
        });

        print('Language change completed successfully');
      } catch (e) {
        print('Error changing language: $e');
        Get.snackbar(
          'Error',
          'Failed to change language: $e',
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    }
  }

  /// Save language preference to storage
  void _saveLanguagePreference(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
    } catch (e) {
      print('Error saving language preference: $e');
    }
  }

  /// Get language name for display
  String getLanguageName(String code) {
    return languageNames[code] ?? 'Unknown';
  }

  /// Get flag emoji for language (for UI display)
  String getLanguageFlag(String code) {
    const Map<String, String> flags = {'en': '🇺🇸', 'es': '🇪🇸'};
    return flags[code] ?? '🌍';
  }

  /// Force update all GetBuilder widgets using this controller
  /// This method should be called when language changes to ensure
  /// all UI components using GetBuilder<LanguageController> rebuild
  void forceUIUpdate() {
    update();
  }

  /// Get current locale as Locale object
  Locale get currentLocale => Locale(_currentLocale.value);
}
