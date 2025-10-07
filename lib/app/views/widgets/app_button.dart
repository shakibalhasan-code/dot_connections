import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/text_style.dart';

/// AppButton provides consistent, customizable buttons throughout the app
///
/// This widget offers different button styles and configurations:
/// - Primary buttons for main actions
/// - Secondary buttons for alternative actions
/// - Outline buttons for subtle actions
/// - Text buttons for minimal actions
///
/// Features:
/// - Loading states with spinners
/// - Haptic feedback
/// - Accessibility support
/// - Theme-aware styling
/// - Customizable sizes and colors
class AppButton extends StatelessWidget {
  /// Button text
  final String text;

  /// Button press callback
  final VoidCallback? onPressed;

  /// Button style variant
  final AppButtonStyle style;

  /// Button size variant
  final AppButtonSize size;

  /// Loading state
  final bool isLoading;

  /// Custom width (if not provided, uses full width)
  final double? width;

  /// Custom height (if not provided, uses size-based height)
  final double? height;

  /// Leading icon
  final Widget? leadingIcon;

  /// Trailing icon
  final Widget? trailingIcon;

  /// Custom colors
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  /// Enable haptic feedback
  final bool enableHaptic;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = AppButtonStyle.primary,
    this.size = AppButtonSize.large,
    this.isLoading = false,
    this.width,
    this.height,
    this.leadingIcon,
    this.trailingIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.enableHaptic = true,
  });

  /// Creates a primary button (most common use case)
  factory AppButton.primary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    AppButtonSize size = AppButtonSize.large,
    Widget? leadingIcon,
    Widget? trailingIcon,
    double? width,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      style: AppButtonStyle.primary,
      size: size,
      isLoading: isLoading,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      width: width,
    );
  }

  /// Creates a secondary button
  factory AppButton.secondary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    AppButtonSize size = AppButtonSize.large,
    Widget? leadingIcon,
    Widget? trailingIcon,
    double? width,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      style: AppButtonStyle.secondary,
      size: size,
      isLoading: isLoading,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      width: width,
    );
  }

  /// Creates an outline button
  factory AppButton.outline({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    AppButtonSize size = AppButtonSize.large,
    Widget? leadingIcon,
    Widget? trailingIcon,
    double? width,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      style: AppButtonStyle.outline,
      size: size,
      isLoading: isLoading,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      width: width,
    );
  }

  /// Creates a text button
  factory AppButton.text({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    AppButtonSize size = AppButtonSize.medium,
    Widget? leadingIcon,
    Widget? trailingIcon,
    double? width,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      style: AppButtonStyle.text,
      size: size,
      isLoading: isLoading,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null || isLoading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width ?? double.infinity,
      height: height ?? _getHeightForSize(),
      child: _buildButtonForStyle(context, theme, isDisabled),
    );
  }

  /// Builds button based on style
  Widget _buildButtonForStyle(
    BuildContext context,
    ThemeData theme,
    bool isDisabled,
  ) {
    switch (style) {
      case AppButtonStyle.primary:
        return _buildElevatedButton(context, theme, isDisabled);
      case AppButtonStyle.secondary:
        return _buildSecondaryButton(context, theme, isDisabled);
      case AppButtonStyle.outline:
        return _buildOutlineButton(context, theme, isDisabled);
      case AppButtonStyle.text:
        return _buildTextButton(context, theme, isDisabled);
    }
  }

  /// Builds elevated button (primary style)
  Widget _buildElevatedButton(
    BuildContext context,
    ThemeData theme,
    bool isDisabled,
  ) {
    return ElevatedButton(
      onPressed: isDisabled ? null : _handlePress,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? theme.colorScheme.primary,
        foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
        disabledBackgroundColor: theme.colorScheme.primary.withOpacity(0.5),
        elevation: isDisabled ? 0 : 2,
        shadowColor: theme.colorScheme.primary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
      ),
      child: _buildButtonContent(theme),
    );
  }

  /// Builds secondary button
  Widget _buildSecondaryButton(
    BuildContext context,
    ThemeData theme,
    bool isDisabled,
  ) {
    return ElevatedButton(
      onPressed: isDisabled ? null : _handlePress,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? theme.colorScheme.secondary,
        foregroundColor: foregroundColor ?? theme.colorScheme.onSecondary,
        disabledBackgroundColor: theme.colorScheme.secondary.withOpacity(0.5),
        elevation: isDisabled ? 0 : 2,
        shadowColor: theme.colorScheme.secondary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
      ),
      child: _buildButtonContent(theme),
    );
  }

  /// Builds outline button
  Widget _buildOutlineButton(
    BuildContext context,
    ThemeData theme,
    bool isDisabled,
  ) {
    return OutlinedButton(
      onPressed: isDisabled ? null : _handlePress,
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor ?? theme.colorScheme.primary,
        side: BorderSide(
          color: borderColor ?? theme.colorScheme.primary,
          width: isDisabled ? 1 : 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
      ),
      child: _buildButtonContent(theme),
    );
  }

  /// Builds text button
  Widget _buildTextButton(
    BuildContext context,
    ThemeData theme,
    bool isDisabled,
  ) {
    return TextButton(
      onPressed: isDisabled ? null : _handlePress,
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor ?? theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
      ),
      child: _buildButtonContent(theme),
    );
  }

  /// Builds button content with loading state and icons
  Widget _buildButtonContent(ThemeData theme) {
    if (isLoading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: _getIconSize(),
            height: _getIconSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getLoadingColor(theme),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text('Loading...', style: _getTextStyle(theme)),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[leadingIcon!, SizedBox(width: 8.w)],
        Text(text, style: _getTextStyle(theme)),
        if (trailingIcon != null) ...[SizedBox(width: 8.w), trailingIcon!],
      ],
    );
  }

  /// Handles button press with haptic feedback
  void _handlePress() {
    if (enableHaptic) {
      HapticFeedback.lightImpact();
    }
    onPressed?.call();
  }

  /// Gets height based on size
  double _getHeightForSize() {
    switch (size) {
      case AppButtonSize.small:
        return 36.h;
      case AppButtonSize.medium:
        return 44.h;
      case AppButtonSize.large:
        return 52.h;
    }
  }

  /// Gets border radius based on size
  double _getBorderRadius() {
    switch (size) {
      case AppButtonSize.small:
        return 18.r;
      case AppButtonSize.medium:
        return 22.r;
      case AppButtonSize.large:
        return 26.r;
    }
  }

  /// Gets text style based on size
  TextStyle _getTextStyle(ThemeData theme) {
    double fontSize;
    FontWeight fontWeight;

    switch (size) {
      case AppButtonSize.small:
        fontSize = 14.sp;
        fontWeight = FontWeight.w500;
        break;
      case AppButtonSize.medium:
        fontSize = 16.sp;
        fontWeight = FontWeight.w600;
        break;
      case AppButtonSize.large:
        fontSize = 18.sp;
        fontWeight = FontWeight.w600;
        break;
    }

    return AppTextStyle.primaryTextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: _getTextColor(theme),
    );
  }

  /// Gets text color based on style and theme
  Color _getTextColor(ThemeData theme) {
    if (foregroundColor != null) return foregroundColor!;

    switch (style) {
      case AppButtonStyle.primary:
        return theme.colorScheme.onPrimary;
      case AppButtonStyle.secondary:
        return theme.colorScheme.onSecondary;
      case AppButtonStyle.outline:
      case AppButtonStyle.text:
        return theme.colorScheme.primary;
    }
  }

  /// Gets loading indicator color
  Color _getLoadingColor(ThemeData theme) {
    switch (style) {
      case AppButtonStyle.primary:
        return theme.colorScheme.onPrimary;
      case AppButtonStyle.secondary:
        return theme.colorScheme.onSecondary;
      case AppButtonStyle.outline:
      case AppButtonStyle.text:
        return theme.colorScheme.primary;
    }
  }

  /// Gets icon size based on button size
  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16.sp;
      case AppButtonSize.medium:
        return 18.sp;
      case AppButtonSize.large:
        return 20.sp;
    }
  }
}

/// Button style variants
enum AppButtonStyle { primary, secondary, outline, text }

/// Button size variants
enum AppButtonSize { small, medium, large }
