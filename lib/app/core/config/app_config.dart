/// AppConfig centralizes all configurable app settings
///
/// This class provides a single point of configuration for CodeCanyon buyers
/// to customize the app without diving deep into the codebase. All major
/// app settings, branding, and feature toggles can be modified here.
///
/// Usage:
/// Simply modify the values in this file to customize your app.
/// Most changes will be reflected immediately without code changes elsewhere.
///
/// Categories:
/// - App Information & Branding
/// - API Configuration
/// - Feature Toggles
/// - UI/UX Settings
/// - Social Media Integration
/// - Subscription & Monetization
/// - Analytics & Tracking
class AppConfig {
  /// Private constructor to prevent instantiation
  AppConfig._();

  // =============================================================================
  // APP INFORMATION & BRANDING
  // =============================================================================

  /// App display name (shown in app bar, notifications, etc.)
  static const String appName = 'TrueDots';

  /// App tagline or slogan
  static const String appTagline = 'Find Your Perfect Match';

  /// App version (should match pubspec.yaml version)
  static const String appVersion = '1.0.0';

  /// Company/Developer name
  static const String companyName = 'Dot Connections Inc.';

  /// Support email
  static const String supportEmail = 'support@truedots.com';

  /// Privacy policy URL
  static const String privacyPolicyUrl = 'https://truedots.com/privacy';

  /// Terms of service URL
  static const String termsOfServiceUrl = 'https://truedots.com/terms';

  /// App store URLs (replace with your actual app store links)
  static const String iosAppStoreUrl = 'https://apps.apple.com/app/truedots';
  static const String googlePlayStoreUrl =
      'https://play.google.com/store/apps/details?id=com.truedots';

  // =============================================================================
  // API CONFIGURATION
  // =============================================================================

  /// Base API URL (replace with your backend API)
  static const String baseApiUrl = 'https://api.truedots.com/v1';

  /// API timeout duration in seconds
  static const int apiTimeoutSeconds = 30;

  /// Enable API request logging (disable in production)
  static const bool enableApiLogging = false; // Set to false for production

  /// Maximum retry attempts for failed API requests
  static const int maxRetryAttempts = 3;

  // =============================================================================
  // AUTHENTICATION SETTINGS
  // =============================================================================

  /// Enable social login options
  static const bool enableGoogleLogin = true;
  static const bool enableFacebookLogin = true;
  static const bool enableAppleLogin = true; // iOS only

  /// Minimum password length
  static const int minPasswordLength = 6;

  /// Require email verification
  static const bool requireEmailVerification = true;

  /// Enable phone number verification
  static const bool enablePhoneVerification = false;

  // =============================================================================
  // MATCHING & DISCOVERY SETTINGS
  // =============================================================================

  /// Default maximum distance for matches (in kilometers)
  static const int defaultMaxDistance = 50;

  /// Minimum age for dating (must comply with local laws)
  static const int minimumAge = 18;

  /// Maximum age for dating
  static const int maximumAge = 99;

  /// Maximum number of daily likes for free users
  static const int dailyLikesLimit = 10;

  /// Enable super likes feature
  static const bool enableSuperLikes = true;

  /// Maximum number of daily super likes for free users
  static const int dailySuperLikesLimit = 1;

  /// Enable location-based matching
  static const bool enableLocationMatching = true;

  /// Require location permission for app usage
  static const bool requireLocationPermission = false;

  // =============================================================================
  // CHAT & MESSAGING SETTINGS
  // =============================================================================

  /// Enable voice messages
  static const bool enableVoiceMessages = true;

  /// Enable photo sharing in chat
  static const bool enablePhotoSharing = true;

  /// Enable GIF support in chat
  static const bool enableGifSupport = true;

  /// Maximum message length
  static const int maxMessageLength = 1000;

  /// Enable message encryption
  static const bool enableMessageEncryption = false;

  /// Enable read receipts
  static const bool enableReadReceipts = true;

  /// Enable typing indicators
  static const bool enableTypingIndicators = true;

  // =============================================================================
  // PROFILE & VERIFICATION SETTINGS
  // =============================================================================

  /// Maximum number of profile photos
  static const int maxProfilePhotos = 6;

  /// Minimum number of profile photos required
  static const int minProfilePhotos = 2;

  /// Enable profile verification
  static const bool enableProfileVerification = true;

  /// Enable manual photo review/moderation
  static const bool enablePhotoModeration = false;

  /// Maximum bio length
  static const int maxBioLength = 500;

  /// Enable Instagram integration
  static const bool enableInstagramIntegration = false;

  /// Enable Spotify integration
  static const bool enableSpotifyIntegration = false;

  // =============================================================================
  // SUBSCRIPTION & MONETIZATION
  // =============================================================================

  /// Enable premium subscriptions
  static const bool enablePremiumSubscription = true;

  /// Premium subscription price (monthly, in USD)
  static const double premiumMonthlyPrice = 19.99;

  /// Premium subscription price (yearly, in USD)
  static const double premiumYearlyPrice = 99.99;

  /// Enable in-app purchases (boosts, etc.)
  static const bool enableInAppPurchases = true;

  /// Enable advertisements for free users
  static const bool enableAdvertisements = false;

  /// Premium features list
  static const List<String> premiumFeatures = [
    'Unlimited likes',
    'See who liked you',
    'Super likes',
    'Boost your profile',
    'Advanced filters',
    'Read receipts',
    'No ads',
  ];

  // =============================================================================
  // NOTIFICATIONS SETTINGS
  // =============================================================================

  /// Enable push notifications
  static const bool enablePushNotifications = true;

  /// Enable email notifications
  static const bool enableEmailNotifications = true;

  /// Enable notification sounds
  static const bool enableNotificationSounds = true;

  /// Default notification preferences for new users
  static const Map<String, bool> defaultNotificationSettings = {
    'new_matches': true,
    'new_messages': true,
    'likes': true,
    'super_likes': true,
    'profile_visits': false,
    'marketing': false,
  };

  // =============================================================================
  // SOCIAL MEDIA INTEGRATION
  // =============================================================================

  /// Social media sharing settings
  static const bool enableSocialSharing = true;

  /// Social media URLs (replace with your actual social media accounts)
  static const String instagramUrl = 'https://instagram.com/truedots';
  static const String twitterUrl = 'https://twitter.com/truedots';
  static const String facebookUrl = 'https://facebook.com/truedots';
  static const String tiktokUrl = 'https://tiktok.com/@truedots';

  // =============================================================================
  // ANALYTICS & TRACKING
  // =============================================================================

  /// Enable analytics tracking
  static const bool enableAnalytics =
      false; // Set to true when implementing analytics

  /// Firebase Analytics project ID (replace with your Firebase project)
  static const String firebaseProjectId = 'truedots-app';

  /// Enable crash reporting
  static const bool enableCrashReporting =
      false; // Set to true when implementing crash reporting

  /// Enable performance monitoring
  static const bool enablePerformanceMonitoring = false;

  // =============================================================================
  // UI/UX CUSTOMIZATION
  // =============================================================================

  /// Enable dark mode toggle
  static const bool enableDarkMode = true;

  /// Default theme mode ('system', 'light', 'dark')
  static const String defaultThemeMode = 'system';

  /// Enable haptic feedback
  static const bool enableHapticFeedback = true;

  /// Enable smooth animations
  static const bool enableAnimations = true;

  /// Animation duration in milliseconds
  static const int animationDurationMs = 300;

  /// Enable swipe gestures for matching
  static const bool enableSwipeGestures = true;

  /// Card stack size for matching screen
  static const int cardStackSize = 3;

  // =============================================================================
  // SECURITY SETTINGS
  // =============================================================================

  /// Enable biometric authentication
  static const bool enableBiometricAuth = false;

  /// Session timeout in minutes
  static const int sessionTimeoutMinutes = 60;

  /// Enable automatic logout on app backgrounding
  static const bool enableAutoLogout = false;

  /// Maximum login attempts before account lock
  static const int maxLoginAttempts = 5;

  // =============================================================================
  // LOCALIZATION SETTINGS
  // =============================================================================

  /// Supported languages (ISO 639-1 codes)
  static const List<String> supportedLanguages = [
    'en', // English
    'es', // Spanish
    'fr', // French
    'de', // German
    'it', // Italian
    'pt', // Portuguese
    'ja', // Japanese
    'ko', // Korean
    'zh', // Chinese
  ];

  /// Default language
  static const String defaultLanguage = 'en';

  /// Enable automatic language detection
  static const bool enableAutoLanguageDetection = true;

  // =============================================================================
  // ACCESSIBILITY SETTINGS
  // =============================================================================

  /// Enable comprehensive accessibility features
  static const bool enableAccessibilityFeatures = true;

  /// Enable screen reader announcements
  static const bool enableScreenReaderSupport = true;

  /// Minimum touch target size (following accessibility guidelines)
  static const double minimumTouchTargetSize = 44.0;

  /// Enable high contrast mode support
  static const bool enableHighContrastSupport = true;

  /// Enable reduced motion support
  static const bool enableReducedMotionSupport = true;

  /// Text scale factor limits for accessibility
  static const double minTextScaleFactor = 0.8;
  static const double maxTextScaleFactor = 2.0;

  // =============================================================================
  // DEVELOPMENT & DEBUG SETTINGS
  // =============================================================================

  /// Enable debug mode (should be false in production)
  static const bool isDebugMode = true; // Set to false for production

  /// Enable mock data (useful for testing without backend)
  static const bool enableMockData =
      true; // Set to false when connecting real API

  /// Show debug information in UI
  static const bool showDebugInfo = false;

  /// Enable performance overlay
  static const bool enablePerformanceOverlay = false;

  // =============================================================================
  // HELPER METHODS
  // =============================================================================

  /// Checks if the app is running in production mode
  static bool get isProduction => !isDebugMode;

  /// Gets the complete app title with tagline
  static String get fullAppTitle => '$appName - $appTagline';

  /// Gets API headers with common configuration
  static Map<String, String> get defaultApiHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': '$appName/$appVersion',
  };

  /// Gets the complete terms and privacy URLs
  static Map<String, String> get legalUrls => {
    'privacy': privacyPolicyUrl,
    'terms': termsOfServiceUrl,
  };

  /// Gets social media URLs
  static Map<String, String> get socialMediaUrls => {
    'instagram': instagramUrl,
    'twitter': twitterUrl,
    'facebook': facebookUrl,
    'tiktok': tiktokUrl,
  };

  /// Gets app store URLs
  static Map<String, String> get appStoreUrls => {
    'ios': iosAppStoreUrl,
    'android': googlePlayStoreUrl,
  };

  /// Validates if a feature is enabled
  static bool isFeatureEnabled(String feature) {
    switch (feature.toLowerCase()) {
      case 'google_login':
        return enableGoogleLogin;
      case 'facebook_login':
        return enableFacebookLogin;
      case 'apple_login':
        return enableAppleLogin;
      case 'voice_messages':
        return enableVoiceMessages;
      case 'super_likes':
        return enableSuperLikes;
      case 'premium':
        return enablePremiumSubscription;
      case 'dark_mode':
        return enableDarkMode;
      case 'analytics':
        return enableAnalytics;
      case 'push_notifications':
        return enablePushNotifications;
      default:
        return false;
    }
  }

  /// Gets configuration summary for debugging
  static Map<String, dynamic> getConfigSummary() {
    return {
      'app_name': appName,
      'app_version': appVersion,
      'is_debug_mode': isDebugMode,
      'enable_mock_data': enableMockData,
      'api_base_url': baseApiUrl,
      'supported_languages': supportedLanguages,
      'premium_enabled': enablePremiumSubscription,
      'dark_mode_enabled': enableDarkMode,
    };
  }
}
