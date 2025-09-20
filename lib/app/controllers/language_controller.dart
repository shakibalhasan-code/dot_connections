import 'package:dot_connections/app/core/localization/localization_service.dart';
import 'package:get/get.dart';

/// Controller for managing app language and localization settings
///
/// This controller handles:
/// - Language selection and switching
/// - Saving user language preferences
/// - Updating UI when language changes
/// - Integration with LocalizationService
class LanguageController extends GetxController {
  final _currentLanguage = 'en'.obs;
  final LocalizationService _localizationService = LocalizationService.instance;

  String get currentLanguage => _currentLanguage.value;

  List<String> get supportedLanguages =>
      _localizationService.supportedLanguages;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  /// Load the saved language preference from storage
  void _loadSavedLanguage() {
    // TODO: Load from SharedPreferences or another storage mechanism
    // For now, default to English
    _currentLanguage.value = 'en';
    _localizationService.changeLanguage(_currentLanguage.value);
  }

  /// Change the app language
  void changeLanguage(String languageCode) {
    if (supportedLanguages.contains(languageCode)) {
      _currentLanguage.value = languageCode;
      _localizationService.changeLanguage(languageCode);
      _saveLanguagePreference(languageCode);
      update();

      // Show success message
      Get.snackbar(
        'Language Changed',
        'Language updated to ${_localizationService.getLanguageName(languageCode)}',
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// Save language preference to storage
  void _saveLanguagePreference(String languageCode) {
    // TODO: Implement SharedPreferences saving
    // GetStorage or SharedPreferences can be used here
  }

  /// Get localized text
  String getText(String key) {
    return _localizationService.getText(key);
  }

  /// Get language name for display
  String getLanguageName(String code) {
    return _localizationService.getLanguageName(code);
  }

  /// Get flag emoji for language (for UI display)
  String getLanguageFlag(String code) {
    const Map<String, String> flags = {
      'en': '🇺🇸',
      'es': '🇪🇸',
      'fr': '🇫🇷',
      'de': '🇩🇪',
      'it': '🇮🇹',
      'pt': '🇵🇹',
      'ru': '🇷🇺',
      'ar': '🇸🇦',
      'zh': '🇨🇳',
      'ja': '🇯🇵',
      'ko': '🇰🇷',
      'hi': '🇮🇳',
    };
    return flags[code] ?? '🌍';
  }
}
