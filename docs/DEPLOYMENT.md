# 🚀 Deployment Guide

This comprehensive guide covers deploying Dot Connections to both Google Play Store and Apple App Store, including preparation, building, and submission processes.

## 📋 Table of Contents

- [Pre-deployment Checklist](#pre-deployment-checklist)
- [Android Deployment](#android-deployment)
- [iOS Deployment](#ios-deployment)
- [Environment Configuration](#environment-configuration)
- [Code Signing](#code-signing)
- [Store Assets](#store-assets)
- [Testing](#testing)
- [Post-deployment](#post-deployment)

## ✅ Pre-deployment Checklist

Before deploying your app, ensure you've completed these essential steps:

### Code Preparation
- [ ] Replace all mock data with real API integration
- [ ] Update app configuration in `app_config.dart`
- [ ] Set `isDebugMode = false` and `enableMockData = false`
- [ ] Add your Google Maps API keys
- [ ] Configure Firebase (if using push notifications)
- [ ] Test all app features thoroughly
- [ ] Run code analysis: `flutter analyze`
- [ ] Fix all linter warnings and errors

### Assets and Branding
- [ ] Replace app icons with your branding
- [ ] Update splash screen with your design
- [ ] Customize app colors and themes
- [ ] Update app name and package identifiers
- [ ] Prepare store screenshots and descriptions
- [ ] Create promotional graphics

### Legal and Privacy
- [ ] Update privacy policy URL
- [ ] Update terms of service URL
- [ ] Ensure GDPR/privacy compliance
- [ ] Add age verification if required
- [ ] Configure user data handling policies

### Performance and Security
- [ ] Enable code obfuscation for release builds
- [ ] Optimize images and assets
- [ ] Test app performance on various devices
- [ ] Implement proper error handling
- [ ] Set up crash reporting (Firebase Crashlytics)

## 🤖 Android Deployment

### 1. Configure App Details

Update `android/app/build.gradle`:

```gradle
android {
    compileSdkVersion 34
    ndkVersion flutter.ndkVersion

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    defaultConfig {
        applicationId "com.yourcompany.dotconnections" // Change this
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
        multiDexEnabled true
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### 2. Create Signing Key

Generate a keystore file:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Create `android/key.properties`:

```properties
storePassword=your-store-password
keyPassword=your-key-password
keyAlias=upload
storeFile=/path/to/upload-keystore.jks
```

### 3. Configure Signing

Update `android/app/build.gradle`:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... other config

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
}
```

### 4. Update App Icon

Replace files in `android/app/src/main/res/`:
- `mipmap-hdpi/ic_launcher.png` (72x72)
- `mipmap-mdpi/ic_launcher.png` (48x48)
- `mipmap-xhdpi/ic_launcher.png` (96x96)
- `mipmap-xxhdpi/ic_launcher.png` (144x144)
- `mipmap-xxxhdpi/ic_launcher.png` (192x192)

### 5. Configure Permissions

Update `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.yourcompany.dotconnections">

    <!-- Required permissions -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    
    <!-- Optional permissions -->
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />

    <application
        android:label="Dot Connections"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="false"
        android:allowBackup="false">
        
        <!-- Add your Google Maps API key -->
        <meta-data android:name="com.google.android.geo.API_KEY"
                   android:value="your-google-maps-api-key"/>
        
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            
            <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme"/>
            
            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
    </application>
</manifest>
```

### 6. Build Release APK

```bash
# Clean previous builds
flutter clean
flutter pub get

# Build release APK
flutter build apk --release

# Or build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### 7. Test Release Build

```bash
# Install and test the release APK
flutter install --release
```

### 8. Google Play Console Setup

1. **Create Developer Account**: Sign up at [Google Play Console](https://play.google.com/console)
2. **Create New App**: Click "Create app" and fill in details
3. **App Content**: Complete all required sections:
   - Content rating questionnaire
   - Target audience and content
   - Privacy policy
   - App access (if login required)
   - Ads declaration
   - Data safety

### 9. Upload to Play Store

1. **Upload App Bundle**: Go to "Release" → "Production" → "Create new release"
2. **Upload Bundle**: Select the `.aab` file from `build/app/outputs/bundle/release/`
3. **Release Notes**: Add what's new in this version
4. **Review**: Complete all required sections
5. **Submit**: Send for review (usually takes 1-3 days)

## 🍎 iOS Deployment

### 1. Configure App Details

Update `ios/Runner/Info.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>$(DEVELOPMENT_LANGUAGE)</string>
    <key>CFBundleDisplayName</key>
    <string>Dot Connections</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>dot_connections</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>$(FLUTTER_BUILD_NAME)</string>
    <key>CFBundleVersion</key>
    <string>$(FLUTTER_BUILD_NUMBER)</string>
    
    <!-- Required permissions -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>This app needs location access to find people near you.</string>
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>This app needs location access to find people near you.</string>
    <key>NSCameraUsageDescription</key>
    <string>This app needs camera access to take photos for your profile.</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>This app needs photo library access to select images for your profile.</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>This app needs microphone access to record voice messages.</string>
    
    <!-- Add your Google Maps API key -->
    <key>GMSApiKey</key>
    <string>your-google-maps-api-key</string>
</dict>
</plist>
```

### 2. Configure Xcode Project

1. **Open Xcode**: `open ios/Runner.xcworkspace`
2. **Update Bundle Identifier**: Change to your unique identifier (e.g., `com.yourcompany.dotconnections`)
3. **Update Display Name**: Set your app name
4. **Configure Team**: Select your Apple Developer Team
5. **Update Version**: Set version and build numbers

### 3. App Icon Configuration

Replace app icons in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`:
- iPhone icons: 20x20, 29x29, 40x40, 60x60 (and @2x, @3x variants)
- iPad icons: 20x20, 29x29, 40x40, 76x76, 83.5x83.5 (and @2x variants)
- App Store icon: 1024x1024

### 4. Launch Screen

Update `ios/Runner/Base.lproj/LaunchScreen.storyboard` with your branding.

### 5. Build for iOS

```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Build for iOS
flutter build ios --release
```

### 6. Archive in Xcode

1. **Open Xcode**: `open ios/Runner.xcworkspace`
2. **Select Device**: Choose "Any iOS Device (arm64)"
3. **Archive**: Product → Archive
4. **Validate**: Click "Validate App" when archive completes
5. **Distribute**: Click "Distribute App" → "App Store Connect"

### 7. App Store Connect Setup

1. **Create App**: Go to [App Store Connect](https://appstoreconnect.apple.com)
2. **App Information**: Fill in all required details
3. **Pricing**: Set pricing tier (can be free)
4. **App Privacy**: Complete privacy questionnaire
5. **App Review Information**: Provide review notes and demo account if needed

### 8. Submit for Review

1. **Select Build**: Choose the uploaded build
2. **Screenshots**: Upload required screenshots for all device sizes
3. **App Description**: Write compelling description with keywords
4. **Keywords**: Add relevant search keywords
5. **Submit**: Send for review (usually takes 1-7 days)

## 🔧 Environment Configuration

### Production Environment File

Create `.env.production`:

```env
# Production API Configuration
API_BASE_URL=https://api.dotconnections.com/v1
WS_BASE_URL=wss://api.dotconnections.com
API_KEY=your-production-api-key

# Google Maps API Keys
GOOGLE_MAPS_API_KEY_ANDROID=your-android-maps-key
GOOGLE_MAPS_API_KEY_IOS=your-ios-maps-key

# Firebase Configuration
FIREBASE_PROJECT_ID=dotconnections-prod
FIREBASE_API_KEY=your-firebase-key
FIREBASE_APP_ID=your-firebase-app-id

# Social Login
FACEBOOK_APP_ID=your-facebook-app-id
GOOGLE_CLIENT_ID=your-google-client-id

# App Store Configuration
APP_NAME=Dot Connections
COMPANY_NAME=Your Company Name
SUPPORT_EMAIL=support@yourcompany.com
PRIVACY_POLICY_URL=https://yourcompany.com/privacy
TERMS_URL=https://yourcompany.com/terms

# Analytics
GOOGLE_ANALYTICS_ID=your-analytics-id
MIXPANEL_TOKEN=your-mixpanel-token

# Feature Flags
ENABLE_PUSH_NOTIFICATIONS=true
ENABLE_ANALYTICS=true
ENABLE_CRASHLYTICS=true
ENABLE_DEBUG_MODE=false
ENABLE_MOCK_DATA=false
```

### Build Scripts

Create `scripts/build_android.sh`:

```bash
#!/bin/bash
echo "Building Android release..."

# Load production environment
cp .env.production .env

# Clean and get dependencies
flutter clean
flutter pub get

# Build App Bundle
flutter build appbundle --release --dart-define-from-file=.env.production

echo "Android build complete! Check build/app/outputs/bundle/release/"
```

Create `scripts/build_ios.sh`:

```bash
#!/bin/bash
echo "Building iOS release..."

# Load production environment
cp .env.production .env

# Clean and get dependencies
flutter clean
flutter pub get

# Build iOS
flutter build ios --release --dart-define-from-file=.env.production

echo "iOS build complete! Archive in Xcode to upload to App Store Connect"
```

## 🔐 Code Obfuscation

For additional security, enable code obfuscation:

### Android

```bash
flutter build appbundle --release --obfuscate --split-debug-info=debug-info/
```

### iOS

```bash
flutter build ios --release --obfuscate --split-debug-info=debug-info/
```

## 📸 Store Assets

### Screenshots Required

**Android (Google Play):**
- Phone: 16:9 aspect ratio, minimum 1080px
- Tablet: Various tablet sizes
- TV: 1920x1080 (if supporting Android TV)

**iOS (App Store):**
- iPhone: 6.7", 6.5", 5.5", 4.7"
- iPad: 12.9", 11"
- Apple TV: 1920x1080 (if supporting tvOS)

### Promotional Graphics

**Android:**
- Feature Graphic: 1024x500
- Icon: 512x512

**iOS:**
- App Previews: Video previews up to 30 seconds
- Screenshots: See requirements above

### Screenshot Guidelines

1. **Show Core Features**: Display main app functionality
2. **Use Real Data**: Show realistic user profiles and conversations
3. **Highlight Unique Features**: Showcase what makes your app special
4. **Follow Platform Guidelines**: Use platform-appropriate UI elements
5. **Add Captions**: Include text overlays explaining features
6. **Test Different Devices**: Ensure screenshots look good on all sizes

## 🧪 Pre-release Testing

### Android Testing

1. **Internal Testing**: Upload to Google Play Console for internal testing
2. **Closed Testing**: Test with specific users via email
3. **Open Testing**: Public beta testing
4. **Device Testing**: Use Firebase Test Lab for automated testing

### iOS Testing

1. **TestFlight**: Upload build and invite testers
2. **Internal Testing**: Test with team members
3. **External Testing**: Test with external users (requires app review)
4. **Device Testing**: Test on physical devices

### Testing Checklist

- [ ] App launches successfully
- [ ] All features work as expected
- [ ] Location services work properly
- [ ] Camera and microphone permissions work
- [ ] Audio recording and playback work
- [ ] Image upload and display work
- [ ] Push notifications work (if implemented)
- [ ] App doesn't crash during normal usage
- [ ] Performance is acceptable on older devices
- [ ] Network connectivity handling works properly

## 🚀 Continuous Integration/Deployment

### GitHub Actions Example

Create `.github/workflows/deploy.yml`:

```yaml
name: Build and Deploy

on:
  push:
    tags:
      - 'v*'

jobs:
  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          java-version: '11'
          distribution: 'temurin'
          
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.8.1'
          
      - name: Get dependencies
        run: flutter pub get
        
      - name: Build APK
        run: flutter build apk --release
        
      - name: Build App Bundle
        run: flutter build appbundle --release
        
      - name: Upload to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.SERVICE_ACCOUNT_JSON }}
          packageName: com.yourcompany.dotconnections
          releaseFiles: build/app/outputs/bundle/release/*.aab
          track: production

  build-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.8.1'
          
      - name: Get dependencies
        run: flutter pub get
        
      - name: Build iOS
        run: flutter build ios --release --no-codesign
        
      - name: Archive and Upload
        env:
          APP_STORE_CONNECT_API_KEY: ${{ secrets.APP_STORE_CONNECT_API_KEY }}
        run: |
          xcode-select --print-path
          xcodebuild -workspace ios/Runner.xcworkspace \
                     -scheme Runner \
                     -archivePath Runner.xcarchive \
                     archive
```

## 📊 Post-deployment Monitoring

### Analytics Setup

1. **Firebase Analytics**: Track user engagement
2. **Crashlytics**: Monitor app crashes
3. **Performance Monitoring**: Track app performance
4. **Custom Events**: Track dating app specific events

### Key Metrics to Monitor

- Daily/Monthly Active Users
- User retention rates
- Match success rates
- Message send/receive rates
- App crash rates
- Performance metrics
- Revenue metrics (if applicable)

### App Store Optimization (ASO)

1. **Keywords**: Research and optimize app store keywords
2. **Description**: Write compelling, keyword-rich descriptions
3. **Reviews**: Encourage positive reviews and respond to feedback
4. **Updates**: Regular updates with new features and bug fixes
5. **Localization**: Translate store listings for international markets

## ⚠️ Common Deployment Issues

### Android Issues

**Build Failures:**
- Check Gradle version compatibility
- Ensure all required permissions are declared
- Verify signing configuration

**Google Play Rejection:**
- Missing privacy policy
- Inappropriate content rating
- Missing required metadata
- App crashes during review

### iOS Issues

**Archive Failures:**
- Check code signing certificates
- Verify bundle identifier is unique
- Ensure all required capabilities are enabled

**App Store Rejection:**
- Missing app icon sizes
- Inappropriate content for age rating
- App crashes during review
- Missing required metadata

### General Issues

**API Integration:**
- Test with production API endpoints
- Verify all API keys are correct
- Check network security configurations

**Performance:**
- Test on older devices
- Optimize image sizes and assets
- Monitor memory usage

## 📞 Support and Maintenance

### Post-launch Checklist

- [ ] Monitor app store reviews
- [ ] Track analytics and usage metrics
- [ ] Set up crash reporting alerts
- [ ] Plan first update with bug fixes
- [ ] Prepare customer support processes
- [ ] Set up monitoring for API endpoints
- [ ] Plan marketing and promotion activities

### Update Process

1. **Regular Updates**: Plan monthly or bi-monthly updates
2. **Bug Fixes**: Address crashes and user-reported issues
3. **New Features**: Add features based on user feedback
4. **Security**: Keep dependencies updated
5. **Performance**: Continuously optimize app performance

---

This deployment guide covers all essential aspects of getting your Dot Connections app live on both major app stores. Follow each section carefully and test thoroughly before submission to ensure a smooth deployment process.