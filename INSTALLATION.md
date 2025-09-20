# 🚀 Installation Guide

Welcome to Dot Connections! This guide will help you get the app up and running on your development environment quickly and easily.

## 📋 Prerequisites

Before you begin, make sure you have the following installed on your system:

### Required Software
- **Flutter SDK 3.8.0 or higher** - [Download Flutter](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (included with Flutter)
- **Git** - [Download Git](https://git-scm.com/)

### Development Environment
Choose one or both:
- **Android Studio** - [Download Android Studio](https://developer.android.com/studio)
- **VS Code** with Flutter extension - [Download VS Code](https://code.visualstudio.com/)

### Platform-Specific Requirements

#### For Android Development:
- **Android SDK** (installed with Android Studio)
- **Android SDK Command-line Tools**
- **Android Virtual Device (AVD)** or physical Android device

#### For iOS Development (Mac only):
- **Xcode 14.0 or higher** - [Download from App Store](https://apps.apple.com/app/xcode/id497799835)
- **iOS Simulator** (included with Xcode)
- **CocoaPods** - Install with: `sudo gem install cocoapods`

### Optional but Recommended:
- **Physical device** for testing (Android/iOS)
- **Firebase account** (for push notifications)
- **Google Maps API key** (for map features)

## ⚡ Quick Start (5 minutes)

### Step 1: Download the Project
```bash
# Extract the downloaded zip file to your desired directory
cd /path/to/your/projects/
unzip dot_connections.zip
cd dot_connections
```

### Step 2: Install Dependencies
```bash
# Get Flutter dependencies
flutter pub get

# For iOS, install CocoaPods dependencies
cd ios && pod install && cd ..
```

### Step 3: Run the App
```bash
# Start an emulator first, then run:
flutter run
```

🎉 **That's it!** The app should now be running on your device/emulator.

## 🔧 Detailed Installation Steps

### 1. Verify Flutter Installation

Check if Flutter is properly installed:

```bash
flutter doctor
```

You should see something like this:
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.8.1, on macOS 13.0.1 22A400)
[✓] Android toolchain - develop for Android devices
[✓] Xcode - develop for iOS and macOS
[✓] Chrome - develop for the web
[✓] Android Studio
[✓] VS Code
[✓] Connected device
```

Fix any issues shown before proceeding.

### 2. Clone/Extract the Project

If you downloaded the source code:
```bash
# Navigate to your projects directory
cd ~/Documents/Projects

# Extract the zip file
unzip dot_connections.zip
cd dot_connections

# Or if you have Git access:
# git clone https://github.com/yourrepo/dot_connections.git
# cd dot_connections
```

### 3. Project Structure Overview

```
dot_connections/
├── android/                 # Android-specific files
├── assets/                  # Images, icons, audio files
│   ├── audio/
│   ├── icons/
│   ├── images/
│   └── svg/
├── ios/                     # iOS-specific files
├── lib/                     # Main Dart code
│   ├── app/
│   │   ├── controllers/     # State management (GetX)
│   │   ├── core/           # Configuration, themes, services
│   │   ├── models/         # Data models
│   │   └── views/          # UI screens and widgets
│   └── main.dart           # App entry point
├── pubspec.yaml            # Dependencies and configuration
├── .env.example            # Environment variables template
└── README.md               # Documentation
```

### 4. Configure Environment Variables

```bash
# Copy the example environment file
cp .env.example .env

# Edit the .env file with your configuration
nano .env  # or use your preferred editor
```

Update `.env` with your settings:
```env
# App Configuration
APP_NAME=Dot Connections
COMPANY_NAME=Your Company

# API Configuration (if you have a backend)
API_BASE_URL=https://your-api.com/v1
API_KEY=your-api-key

# Google Maps API Key (get from Google Cloud Console)
GOOGLE_MAPS_API_KEY=your-google-maps-api-key

# Optional: Firebase configuration
FIREBASE_PROJECT_ID=your-project-id

# Optional: Social login configuration
FACEBOOK_APP_ID=your-facebook-app-id
GOOGLE_CLIENT_ID=your-google-client-id
```

### 5. Install Flutter Dependencies

```bash
# Install all Flutter packages
flutter pub get

# This will download all dependencies listed in pubspec.yaml
```

### 6. iOS-specific Setup (Mac only)

```bash
# Navigate to iOS directory
cd ios

# Install CocoaPods dependencies
pod install

# If you encounter issues, try:
pod repo update
pod install --repo-update

# Return to project root
cd ..
```

### 7. Configure Google Maps (Required for map features)

#### Get Google Maps API Key:
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable "Maps SDK for Android" and "Maps SDK for iOS"
4. Create credentials (API Key)
5. Restrict the key to your app's package name

#### Add API Key to Android:
Edit `android/app/src/main/AndroidManifest.xml`:
```xml
<application>
    <!-- Add this inside <application> tag -->
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="your-google-maps-api-key" />
</application>
```

#### Add API Key to iOS:
Edit `ios/Runner/Info.plist`:
```xml
<dict>
    <!-- Add this inside <dict> tag -->
    <key>GMSApiKey</key>
    <string>your-google-maps-api-key</string>
</dict>
```

## 📱 Running the App

### Start Emulator/Simulator

#### Android:
```bash
# List available emulators
flutter emulators

# Start a specific emulator
flutter emulators --launch <emulator_id>

# Or start from Android Studio:
# Tools → AVD Manager → Play button next to your emulator
```

#### iOS (Mac only):
```bash
# Start iOS Simulator
open -a Simulator

# Or from Xcode:
# Xcode → Open Developer Tool → Simulator
```

### Run the Application

```bash
# Run in debug mode (recommended for development)
flutter run

# Run in release mode (for testing performance)
flutter run --release

# Run on specific device
flutter run -d <device_id>

# See available devices
flutter devices
```

### Expected Output

When running successfully, you should see:
```
Launching lib/main.dart on iPhone 14 in debug mode...
Running Xcode build...
Xcode build done.                                           15.2s
Syncing files to device iPhone 14...
Flutter run key commands.
r Hot reload. 🔥
R Hot restart.
h Repeat this help message.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).

💪 Running with sound null safety 💪

An Observatory debugger and profiler on iPhone 14 is available at: http://127.0.0.1:xxxxx/
```

## 🔧 Troubleshooting

### Common Issues and Solutions

#### 1. Flutter Doctor Issues

**Issue**: `[✗] Android toolchain`
```bash
# Install Android SDK
flutter doctor --android-licenses
# Accept all licenses
```

**Issue**: `[✗] Xcode`
```bash
# Install/update Xcode from App Store
sudo xcode-select --install
sudo xcodebuild -runFirstLaunch
```

#### 2. Dependency Issues

**Issue**: Package conflicts or version issues
```bash
# Clean and reinstall dependencies
flutter clean
flutter pub get

# For iOS
cd ios && pod install && cd ..
```

**Issue**: `CocoaPods not working`
```bash
# Update CocoaPods
sudo gem install cocoapods
pod repo update

# If still failing, try:
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
```

#### 3. Build Errors

**Issue**: Android build fails
```bash
# Clean build
flutter clean
flutter pub get
flutter build apk --debug

# If Gradle issues:
cd android
./gradlew clean
cd ..
```

**Issue**: iOS build fails
```bash
# Clean build
flutter clean
flutter pub get

# Clean iOS build
cd ios
xcodebuild clean
rm -rf build/
pod install
cd ..

flutter build ios --debug
```

#### 4. Google Maps Not Loading

**Issue**: Map shows blank or "For development purposes only"
- Verify API key is correct in both `.env` file and platform-specific files
- Check that Maps SDK is enabled in Google Cloud Console
- Ensure API key restrictions are properly configured

**Issue**: Location not working
- Check device location permissions
- Ensure location permissions are requested in app
- Test on physical device (emulator location might not work properly)

#### 5. Audio Recording Issues

**Issue**: Audio recording not working
- Check microphone permissions on device
- Test on physical device (audio recording may not work in emulator)
- Verify `record` package permissions in platform files

#### 6. Hot Reload Not Working

```bash
# Try hot restart instead
# Press 'R' in terminal where flutter run is active

# If still not working, stop and restart
# Press 'q' to quit, then run 'flutter run' again
```

### Getting Help

If you encounter issues not covered here:

1. **Check Flutter Logs**: The terminal output often shows specific error messages
2. **Flutter Doctor**: Run `flutter doctor -v` for detailed system information
3. **Official Docs**: Visit [Flutter Documentation](https://flutter.dev/docs)
4. **Stack Overflow**: Search for your specific error message
5. **Contact Support**: Email us at support@yourcompany.com

## ⚙️ IDE Setup

### VS Code Setup

1. **Install Flutter Extension**:
   - Open VS Code
   - Go to Extensions (Ctrl+Shift+X)
   - Search "Flutter" and install

2. **Recommended Extensions**:
   - Flutter
   - Dart
   - Bracket Pair Colorizer
   - GitLens
   - Material Icon Theme

3. **VS Code Settings**:
   Create `.vscode/settings.json`:
   ```json
   {
     "dart.flutterSdkPath": "/path/to/flutter",
     "editor.formatOnSave": true,
     "editor.codeActionsOnSave": {
       "source.fixAll": true
     }
   }
   ```

### Android Studio Setup

1. **Install Flutter Plugin**:
   - File → Settings → Plugins
   - Search "Flutter" and install
   - Restart Android Studio

2. **Configure Flutter SDK**:
   - File → Settings → Languages & Frameworks → Flutter
   - Set Flutter SDK path

3. **Create AVD**:
   - Tools → AVD Manager
   - Create Virtual Device
   - Choose device and system image

## 🔄 Development Workflow

### Recommended Development Process

1. **Start Development Server**:
   ```bash
   flutter run
   ```

2. **Make Changes**: Edit Dart files in `lib/` directory

3. **Hot Reload**: Press `r` in terminal to see changes instantly

4. **Hot Restart**: Press `R` for full app restart

5. **Test on Multiple Devices**: Run on different screen sizes

6. **Debug**: Use IDE debugger or `print()` statements

### Git Workflow (if using version control)

```bash
# Create feature branch
git checkout -b feature/your-feature-name

# Make changes and commit
git add .
git commit -m "Add your feature description"

# Push changes
git push origin feature/your-feature-name
```

## 🎨 Customization Quick Start

### Change App Colors
Edit `lib/app/core/theme/app_theme_colors.dart`:
```dart
class AppThemeColors {
  static const Color primary = Color(0xFF yourcolor);
  // ... update other colors
}
```

### Change App Name
1. Update `pubspec.yaml`: name field
2. Update platform-specific files:
   - Android: `android/app/src/main/AndroidManifest.xml`
   - iOS: `ios/Runner/Info.plist`

### Replace App Icon
1. Prepare icons in required sizes
2. Use Flutter launcher_icons package or manually replace:
   - Android: `android/app/src/main/res/mipmap-*/`
   - iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### Update Splash Screen
1. Replace images in `assets/images/`
2. Update splash screen code in `lib/app/views/screens/initial/`

For detailed customization instructions, see [CUSTOMIZATION_GUIDE.md](CUSTOMIZATION_GUIDE.md).

## 📚 Next Steps

Now that you have the app running:

1. **Explore the Code**: Familiarize yourself with the project structure
2. **Customize Branding**: Update colors, icons, and text to match your brand
3. **Configure APIs**: Set up your backend integration (see [API_INTEGRATION.md](docs/API_INTEGRATION.md))
4. **Test Features**: Try all app functionality to understand what's included
5. **Plan Customizations**: Decide what features to modify or add
6. **Set Up Backend**: If you need backend services, plan your API structure
7. **Prepare for Deployment**: When ready, follow our [DEPLOYMENT.md](docs/DEPLOYMENT.md) guide

## ❤️ Support

If you need help or have questions:

- 📧 **Email**: support@yourcompany.com
- 📖 **Documentation**: Check our comprehensive guides
- 💬 **Community**: Join our developer community
- 🐛 **Bug Reports**: Report issues via email with detailed description

We're here to help you succeed with your dating app!

---

**Happy Coding! 🚀**