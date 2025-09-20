import 'package:flutter/material.dart';

/// AppThemeColors defines all color schemes for the application
///
/// This class provides both light and dark color schemes that can be easily
/// customized by CodeCanyon buyers. The colors are organized using Material 3
/// color system for consistency and accessibility.
///
/// Customization points:
/// - Modify primary, secondary, and accent colors
/// - Adjust surface and background colors
/// - Update error and warning colors
/// - Create new color schemes for different themes
class AppThemeColors {
  /// Private constructor to prevent instantiation
  AppThemeColors._();

  // Base brand colors - these are the main colors that define your app's identity
  static const Color primaryPurple = Color(0xFF9604B6);
  static const Color primaryPurpleLight = Color(0xFFB847D1);
  static const Color primaryPurpleDark = Color(0xFF7A0391);

  static const Color secondaryPink = Color(0xFFE91E63);
  static const Color secondaryPinkLight = Color(0xFFFF6090);
  static const Color secondaryPinkDark = Color(0xFFB0003A);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Success, Warning, Error colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53E3E);
  static const Color info = Color(0xFF2196F3);

  /// Light theme color scheme
  ///
  /// This follows Material Design 3 color system and provides
  /// excellent contrast ratios for accessibility
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,

    // Primary colors
    primary: primaryPurple,
    onPrimary: white,
    primaryContainer: Color(0xFFF3EDF5),
    onPrimaryContainer: Color(0xFF2D002F),

    // Secondary colors
    secondary: secondaryPink,
    onSecondary: white,
    secondaryContainer: Color(0xFFFFD9E2),
    onSecondaryContainer: Color(0xFF3E001A),

    // Tertiary colors
    tertiary: Color(0xFF7D5260),
    onTertiary: white,
    tertiaryContainer: Color(0xFFFFD9E2),
    onTertiaryContainer: Color(0xFF31111D),

    // Error colors
    error: error,
    onError: white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),

    // Background colors
    background: white,
    onBackground: grey900,

    // Surface colors
    surface: white,
    onSurface: grey900,
    surfaceVariant: Color(0xFFF8F0FA),
    onSurfaceVariant: Color(0xFF4F444C),

    // Outline colors
    outline: Color(0xFF817377),
    outlineVariant: Color(0xFFD1C4C9),

    // Shadow and scrim
    shadow: black,
    scrim: black,

    // Inverse colors
    inverseSurface: grey800,
    onInverseSurface: grey50,
    inversePrimary: Color(0xFFE1BBFF),
  );

  /// Dark theme color scheme
  ///
  /// Provides a comfortable dark mode experience with proper
  /// contrast ratios and accessibility considerations
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,

    // Primary colors
    primary: Color(0xFFE1BBFF),
    onPrimary: Color(0xFF4A0056),
    primaryContainer: Color(0xFF66007A),
    onPrimaryContainer: Color(0xFFF3EDF5),

    // Secondary colors
    secondary: Color(0xFFFFB1C8),
    onSecondary: Color(0xFF5E1129),
    secondaryContainer: Color(0xFF7B2C3F),
    onSecondaryContainer: Color(0xFFFFD9E2),

    // Tertiary colors
    tertiary: Color(0xFFE6BDCB),
    onTertiary: Color(0xFF492532),
    tertiaryContainer: Color(0xFF613B48),
    onTertiaryContainer: Color(0xFFFFD9E2),

    // Error colors
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),

    // Background colors
    background: Color(0xFF1C1B1F),
    onBackground: Color(0xFFE6E1E5),

    // Surface colors
    surface: Color(0xFF1C1B1F),
    onSurface: Color(0xFFE6E1E5),
    surfaceVariant: Color(0xFF4F444C),
    onSurfaceVariant: Color(0xFFD1C4C9),

    // Outline colors
    outline: Color(0xFF9A8D93),
    outlineVariant: Color(0xFF4F444C),

    // Shadow and scrim
    shadow: black,
    scrim: black,

    // Inverse colors
    inverseSurface: Color(0xFFE6E1E5),
    onInverseSurface: Color(0xFF313033),
    inversePrimary: primaryPurple,
  );

  // Legacy colors for backward compatibility with existing AppColors class

  /// Primary brand color
  static const Color primaryColor = primaryPurple;

  /// Primary color with transparency
  static const Color primaryTransparent = Color(0xFF8D6596);

  /// Field background color
  static const Color fieldBgColor = Color(0xFFF8F0FA);

  /// General background color
  static const Color backgroundColor = Color(0xFFF5F6F9);

  /// Primary text color
  static const Color textColor = Color(0xFF321B37);

  /// Scaffold background color
  static const Color scaffoldBg = white;

  /// Field background color (alternative naming)
  static const Color feildBgColor = fieldBgColor;

  /// Chip background color
  static const Color chipBgColor = Color(0xFFE8DDEF);

  /// Primary text color (alternative naming)
  static const Color primaryTextColor = Color(0xFF2D2D2D);

  /// Secondary text color
  static const Color secondaryTextColor = Color(0xFF5A5A5A);

  /// Primary transparent card color
  static const Color primaryTransParentCard = Color(0xFFF3EDF5);

  /// Icon shape color
  static const Color iconShapeColor = Color(0xFFF0E5F2);
}

/// Extension methods for ColorScheme to add custom getters
extension ColorSchemeExtension on ColorScheme {
  /// Gets success color based on theme brightness
  Color get success => brightness == Brightness.light
      ? AppThemeColors.success
      : const Color(0xFF81C784);

  /// Gets warning color based on theme brightness
  Color get warning => brightness == Brightness.light
      ? AppThemeColors.warning
      : const Color(0xFFFFB74D);

  /// Gets info color based on theme brightness
  Color get info => brightness == Brightness.light
      ? AppThemeColors.info
      : const Color(0xFF64B5F6);
}
