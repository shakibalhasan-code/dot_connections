# 🎨 TrueDots Customization Guide

Welcome to TrueDots! This guide will help you customize the app to match your brand and requirements. The app is designed to be easily customizable without deep technical knowledge.

## 📋 Quick Start Customization

### 1. App Branding & Information

**File:** `lib/app/core/config/app_config.dart`

```dart
// Change app name and branding
static const String appName = 'YourAppName';
static const String appTagline = 'Your App Tagline';
static const String companyName = 'Your Company Name';
static const String supportEmail = 'support@yourapp.com';
```

### 2. Colors & Theme

**File:** `lib/app/core/theme/app_theme_colors.dart`

```dart
// Change primary brand colors
static const Color primaryPurple = Color(0xFF9604B6); // Change this
static const Color secondaryPink = Color(0xFFE91E63);  // Change this
```

**To add your own color scheme:**
1. Replace the hex color codes with your brand colors
2. The app automatically generates light and dark variants
3. All UI components will adapt to your new colors

### 3. App Icon & Images

**Replace these files with your assets:**
- `assets/icons/app_icon_cover.svg` - Main app logo
- `assets/images/app_cover.png` - Splash screen image
- `assets/images/welcome_image.png` - Welcome screen image
- `assets/images/initial_image.png` - Initial screen background

**File:** `lib/app/core/utils/app_images.dart`
```dart
// Update image paths if needed
class AppImages {
  static const String appCover = 'assets/images/your_app_cover.png';
  static const String welcomeImage = 'assets/images/your_welcome.png';
  // ... add your images
}
```

## 🔧 Advanced Customization

### 4. API Integration

**File:** `lib/app/core/config/app_config.dart`

```dart
// Replace with your backend API
static const String baseApiUrl = 'https://your-api.com/v1';
static const bool enableMockData = false; // Disable mock data
```

**To integrate your API:**
1. Set `enableMockData = false`
2. Update `baseApiUrl` with your API endpoint
3. Modify service files in `lib/app/services/` to match your API structure

### 5. Features Configuration

**File:** `lib/app/core/config/app_config.dart`

```dart
// Enable/disable features
static const bool enablePremiumSubscription = true;
static const bool enableVoiceMessages = true;
static const bool enableSuperLikes = true;
static const bool enableGoogleLogin = true;
static const bool enableFacebookLogin = true;
```

### 6. Subscription Settings

```dart
// Pricing configuration
static const double premiumMonthlyPrice = 19.99;
static const double premiumYearlyPrice = 99.99;

// Premium features
static const List<String> premiumFeatures = [
  'Unlimited likes',
  'See who liked you',
  'Your custom feature',
  // Add your premium features
];
```

### 7. Matching Algorithm Settings

```dart
// Matching parameters
static const int defaultMaxDistance = 50; // km
static const int minimumAge = 18;
static const int dailyLikesLimit = 10; // for free users
```

## 🎨 UI Customization

### 8. Text Styles

**File:** `lib/app/core/utils/text_style.dart`

```dart
// Change font family
static TextStyle primaryTextStyle({...}) {
  return GoogleFonts.yourFontFamily( // Change font here
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}
```

### 9. Button Styles

**File:** `lib/app/views/widgets/app_button.dart`

- Modify button radius, colors, and animations
- Add new button variants
- Customize loading states

### 10. Animation Settings

**File:** `lib/app/core/config/app_config.dart`

```dart
// Animation preferences
static const bool enableAnimations = true;
static const int animationDurationMs = 300; // Change speed
static const bool enableHapticFeedback = true;
```

## 🌐 Localization Setup

### 11. Add New Languages

**File:** `lib/app/core/config/app_config.dart`

```dart
// Supported languages
static const List<String> supportedLanguages = [
  'en', // English
  'es', // Spanish
  'fr', // French
  'your_language_code', // Add your language
];
```

**To add translations:**
1. Create language files in `lib/app/core/localization/`
2. Add translation keys and values
3. Update the language configuration

## 📱 Platform-Specific Customization

### 12. Android Configuration

**File:** `android/app/src/main/AndroidManifest.xml`
- Update app name: `android:label="Your App Name"`
- Configure permissions
- Update package name if needed

**File:** `android/app/build.gradle`
- Update `applicationId`
- Configure signing
- Update version codes

### 13. iOS Configuration

**File:** `ios/Runner/Info.plist`
- Update `CFBundleDisplayName`
- Configure permissions
- Update bundle identifier

## 🚀 Deployment Customization

### 14. App Store Information

Update these for app store submissions:
- App name and description
- Keywords and categories  
- Screenshots and app preview
- Privacy policy and terms of service URLs

### 15. Firebase Setup (Optional)

If using Firebase services:
1. Replace `google-services.json` (Android)
2. Replace `GoogleService-Info.plist` (iOS)
3. Update Firebase project configuration

## 🔐 Security & Privacy

### 16. Privacy Settings

**File:** `lib/app/core/config/app_config.dart`

```dart
// Privacy configuration
static const String privacyPolicyUrl = 'https://yourapp.com/privacy';
static const String termsOfServiceUrl = 'https://yourapp.com/terms';
static const bool enableAnalytics = false; // Set true when ready
```

### 17. Data Protection

- Review and update privacy policy
- Configure data retention policies
- Set up GDPR compliance if needed
- Configure user data deletion

## 📊 Analytics & Monitoring

### 18. Analytics Setup

```dart
// Enable when ready for production
static const bool enableAnalytics = true;
static const bool enableCrashReporting = true;
static const String firebaseProjectId = 'your-firebase-project';
```

## 🛠 Development vs Production

### 19. Environment Configuration

```dart
// Development settings
static const bool isDebugMode = false; // Set false for production
static const bool enableMockData = false; // Disable for production
static const bool showDebugInfo = false; // Never true in production
```

## 📝 Common Customization Tasks

### Task 1: Change App Colors
1. Open `lib/app/core/theme/app_theme_colors.dart`
2. Replace `primaryPurple` and `secondaryPink` with your colors
3. Run the app to see changes

### Task 2: Update App Name
1. Open `lib/app/core/config/app_config.dart`
2. Change `appName` and `appTagline`
3. Update `AndroidManifest.xml` and `Info.plist`
4. Replace app icon files

### Task 3: Connect Your API
1. Set `enableMockData = false` in `app_config.dart`
2. Update `baseApiUrl` with your API endpoint
3. Modify service files to match your API structure
4. Update model classes if needed

### Task 4: Add Premium Features
1. Update `premiumFeatures` list in `app_config.dart`
2. Implement premium checks in relevant screens
3. Set up subscription products in app stores
4. Configure payment processing

### Task 5: Customize Onboarding
1. Replace images in `assets/images/`
2. Update text in onboarding screens
3. Modify flow in `lib/app/views/screens/initial/`
4. Adjust validation rules if needed

## 📞 Support

If you need help with customization:
1. Check the inline code comments for guidance
2. Review the `AppConfig` class for available options
3. Look at the existing code patterns for examples
4. Contact support for complex customizations

## ⚠️ Important Notes

1. **Always test thoroughly** after making changes
2. **Keep backups** of your customizations
3. **Update gradually** - make small changes and test
4. **Follow platform guidelines** for app store submissions
5. **Comply with local laws** for dating app regulations
6. **Respect user privacy** and data protection laws

## 🎉 Ready to Launch!

Once you've customized the app to your needs:
1. Test all features thoroughly
2. Update app store metadata
3. Prepare marketing materials
4. Submit to app stores
5. Monitor user feedback and analytics

Happy customizing! 🚀