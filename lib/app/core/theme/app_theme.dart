import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme_colors.dart';

/// AppTheme provides comprehensive theming for the entire application
///
/// This class contains both light and dark theme configurations that can be
/// easily customized by CodeCanyon buyers. The theme system is built to be
/// flexible and maintainable.
///
/// Customization points:
/// - Modify colors in AppThemeColors class
/// - Change font family by updating the textTheme methods
/// - Adjust component themes like buttons, cards, etc.
/// - Add new theme variants by extending this class
class AppTheme {
  /// Private constructor to prevent instantiation
  AppTheme._();

  /// Primary gradient used throughout the app
  static LinearGradient get primaryGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppThemeColors.primaryPurple, AppThemeColors.primaryPurpleLight],
  );

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: AppThemeColors.lightColorScheme,

      // Text theme
      textTheme: _buildTextTheme(AppThemeColors.lightColorScheme),

      // App bar theme
      appBarTheme: _buildAppBarTheme(AppThemeColors.lightColorScheme),

      // Elevated button theme
      elevatedButtonTheme: _buildElevatedButtonTheme(
        AppThemeColors.lightColorScheme,
      ),

      // Text button theme
      textButtonTheme: _buildTextButtonTheme(AppThemeColors.lightColorScheme),

      // Input decoration theme
      inputDecorationTheme: _buildInputDecorationTheme(
        AppThemeColors.lightColorScheme,
      ),

      // Card theme
      cardTheme: _buildCardTheme(AppThemeColors.lightColorScheme),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(
        AppThemeColors.lightColorScheme,
      ),

      // Scaffold background color
      scaffoldBackgroundColor: AppThemeColors.lightColorScheme.background,

      // System UI overlay style
      extensions: [_buildSystemUiOverlayTheme(Brightness.light)],
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme
      colorScheme: AppThemeColors.darkColorScheme,

      // Text theme
      textTheme: _buildTextTheme(AppThemeColors.darkColorScheme),

      // App bar theme
      appBarTheme: _buildAppBarTheme(AppThemeColors.darkColorScheme),

      // Elevated button theme
      elevatedButtonTheme: _buildElevatedButtonTheme(
        AppThemeColors.darkColorScheme,
      ),

      // Text button theme
      textButtonTheme: _buildTextButtonTheme(AppThemeColors.darkColorScheme),

      // Input decoration theme
      inputDecorationTheme: _buildInputDecorationTheme(
        AppThemeColors.darkColorScheme,
      ),

      // Card theme
      cardTheme: _buildCardTheme(AppThemeColors.darkColorScheme),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(
        AppThemeColors.darkColorScheme,
      ),

      // Scaffold background color
      scaffoldBackgroundColor: AppThemeColors.darkColorScheme.background,

      // System UI overlay style
      extensions: [_buildSystemUiOverlayTheme(Brightness.dark)],
    );
  }

  /// Builds text theme for the app
  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: GoogleFonts.montserrat(
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
        color: colorScheme.onBackground,
      ),
      displayMedium: GoogleFonts.montserrat(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        color: colorScheme.onBackground,
      ),
      displaySmall: GoogleFonts.montserrat(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: colorScheme.onBackground,
      ),
      headlineLarge: GoogleFonts.montserrat(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        color: colorScheme.onBackground,
      ),
      headlineMedium: GoogleFonts.montserrat(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: colorScheme.onBackground,
      ),
      headlineSmall: GoogleFonts.montserrat(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: colorScheme.onBackground,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: colorScheme.onBackground,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: colorScheme.onBackground,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: colorScheme.onBackground,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        color: colorScheme.onBackground,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        color: colorScheme.onBackground,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        color: colorScheme.onSurface.withOpacity(0.7),
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: colorScheme.onBackground,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: colorScheme.onBackground,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface.withOpacity(0.7),
      ),
    );
  }

  /// Builds app bar theme
  static AppBarTheme _buildAppBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      backgroundColor: colorScheme.background,
      foregroundColor: colorScheme.onBackground,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: colorScheme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness: colorScheme.brightness,
      ),
      titleTextStyle: GoogleFonts.montserrat(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: colorScheme.onBackground,
      ),
    );
  }

  /// Builds elevated button theme
  static ElevatedButtonThemeData _buildElevatedButtonTheme(
    ColorScheme colorScheme,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        shadowColor: colorScheme.primary.withOpacity(0.3),
        minimumSize: Size(double.infinity, 50.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.r),
        ),
        textStyle: GoogleFonts.montserrat(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Builds text button theme
  static TextButtonThemeData _buildTextButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        textStyle: GoogleFonts.montserrat(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Builds input decoration theme
  static InputDecorationTheme _buildInputDecorationTheme(
    ColorScheme colorScheme,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: colorScheme.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      hintStyle: GoogleFonts.poppins(
        fontSize: 14.sp,
        color: colorScheme.onSurface.withOpacity(0.6),
      ),
    );
  }

  /// Builds card theme
  static CardThemeData _buildCardTheme(ColorScheme colorScheme) {
    return CardThemeData(
      color: colorScheme.surface,
      shadowColor: colorScheme.shadow.withOpacity(0.1),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      margin: EdgeInsets.all(8.w),
    );
  }

  /// Builds bottom navigation bar theme
  static BottomNavigationBarThemeData _buildBottomNavigationBarTheme(
    ColorScheme colorScheme,
  ) {
    return BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    );
  }

  /// Builds system UI overlay theme
  static SystemUiOverlayTheme _buildSystemUiOverlayTheme(
    Brightness brightness,
  ) {
    return SystemUiOverlayTheme(
      systemUiOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness: brightness,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
    );
  }
}

/// Custom theme extension for system UI overlay style
class SystemUiOverlayTheme extends ThemeExtension<SystemUiOverlayTheme> {
  final SystemUiOverlayStyle systemUiOverlayStyle;

  const SystemUiOverlayTheme({required this.systemUiOverlayStyle});

  @override
  SystemUiOverlayTheme copyWith({SystemUiOverlayStyle? systemUiOverlayStyle}) {
    return SystemUiOverlayTheme(
      systemUiOverlayStyle: systemUiOverlayStyle ?? this.systemUiOverlayStyle,
    );
  }

  @override
  SystemUiOverlayTheme lerp(SystemUiOverlayTheme? other, double t) {
    if (other is! SystemUiOverlayTheme) {
      return this;
    }
    return SystemUiOverlayTheme(
      systemUiOverlayStyle: t < 0.5
          ? systemUiOverlayStyle
          : other.systemUiOverlayStyle,
    );
  }
}
