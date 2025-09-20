import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

/// Accessibility service for enhanced app accessibility
///
/// This service provides comprehensive accessibility features including:
/// - Screen reader support with semantic labels
/// - Enhanced focus management
/// - Voice announcements for important actions
/// - Accessibility-friendly UI components
/// - Support for assistive technologies
///
/// Key features:
/// - Semantic labels for all interactive elements
/// - Voice announcements for user actions
/// - Focus management for keyboard navigation
/// - Support for TalkBack (Android) and VoiceOver (iOS)
class AccessibilityService {
  static AccessibilityService? _instance;
  static AccessibilityService get instance =>
      _instance ??= AccessibilityService._();

  AccessibilityService._();

  /// Announce text to screen readers
  ///
  /// This method uses Flutter's accessibility services to announce
  /// text to screen readers like TalkBack and VoiceOver.
  void announceText(String text) {
    SemanticsService.announce(text, TextDirection.ltr);
  }

  /// Announce a successful action to users
  void announceSuccess(String message) {
    HapticFeedback.lightImpact();
    announceText(message);
  }

  /// Announce an error to users
  void announceError(String message) {
    HapticFeedback.heavyImpact();
    announceText('Error: $message');
  }

  /// Announce a warning to users
  void announceWarning(String message) {
    HapticFeedback.mediumImpact();
    announceText('Warning: $message');
  }

  /// Create an accessible button with proper semantics
  Widget createAccessibleButton({
    required Widget child,
    required VoidCallback onPressed,
    required String semanticLabel,
    String? semanticHint,
    bool enabled = true,
  }) {
    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      button: true,
      enabled: enabled,
      child: Material(
        child: InkWell(onTap: enabled ? onPressed : null, child: child),
      ),
    );
  }

  /// Create an accessible text field with proper semantics
  Widget createAccessibleTextField({
    required TextEditingController controller,
    required String semanticLabel,
    String? semanticHint,
    String? hintText,
    bool obscureText = false,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      textField: true,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  /// Create an accessible image with proper semantics
  Widget createAccessibleImage({
    required String imagePath,
    required String semanticLabel,
    String? semanticHint,
    VoidCallback? onTap,
    double? width,
    double? height,
    BoxFit? fit,
  }) {
    Widget imageWidget = Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      semanticLabel: semanticLabel,
    );

    if (onTap != null) {
      return Semantics(
        label: semanticLabel,
        hint: semanticHint,
        button: true,
        child: GestureDetector(onTap: onTap, child: imageWidget),
      );
    }

    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      image: true,
      child: imageWidget,
    );
  }

  /// Create an accessible network image
  Widget createAccessibleNetworkImage({
    required String imageUrl,
    required String semanticLabel,
    String? semanticHint,
    VoidCallback? onTap,
    double? width,
    double? height,
    BoxFit? fit,
  }) {
    Widget imageWidget = Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      semanticLabel: semanticLabel,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Semantics(
          label: 'Loading image: $semanticLabel',
          child: Container(
            width: width,
            height: height,
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Semantics(
          label: 'Failed to load image: $semanticLabel',
          child: Container(
            width: width,
            height: height,
            child: Icon(Icons.error),
          ),
        );
      },
    );

    if (onTap != null) {
      return Semantics(
        label: semanticLabel,
        hint: semanticHint,
        button: true,
        child: GestureDetector(onTap: onTap, child: imageWidget),
      );
    }

    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      image: true,
      child: imageWidget,
    );
  }

  /// Create an accessible loading indicator
  Widget createAccessibleLoadingIndicator({String? label, Color? color}) {
    return Semantics(
      label: label ?? 'Loading',
      child: CircularProgressIndicator(color: color),
    );
  }

  /// Create an accessible card/container with navigation support
  Widget createAccessibleCard({
    required Widget child,
    required String semanticLabel,
    String? semanticHint,
    VoidCallback? onTap,
    EdgeInsets? padding,
    Color? color,
  }) {
    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      button: onTap != null,
      container: true,
      child: Card(
        color: color,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding ?? EdgeInsets.all(16), child: child),
        ),
      ),
    );
  }

  /// Create an accessible list item
  Widget createAccessibleListItem({
    required Widget child,
    required String semanticLabel,
    String? semanticHint,
    VoidCallback? onTap,
    bool selected = false,
  }) {
    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      button: onTap != null,
      selected: selected,
      child: ListTile(onTap: onTap, selected: selected, title: child),
    );
  }

  /// Create an accessible tab with proper semantics
  Widget createAccessibleTab({
    required String text,
    required bool isSelected,
    required int index,
    required int totalTabs,
  }) {
    return Semantics(
      label: text,
      hint: 'Tab ${index + 1} of $totalTabs',
      selected: isSelected,
      button: true,
      child: Tab(text: text),
    );
  }

  /// Create an accessible dialog
  Widget createAccessibleDialog({
    required String title,
    required Widget content,
    List<Widget>? actions,
    bool dismissible = true,
  }) {
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: AlertDialog(
        title: Semantics(header: true, child: Text(title)),
        content: content,
        actions: actions,
      ),
    );
  }

  /// Focus management helper
  void requestFocus(FocusNode focusNode) {
    focusNode.requestFocus();
  }

  /// Clear focus from current focused widget
  void clearFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// Traverse to next focusable widget
  void focusNext() {
    FocusManager.instance.primaryFocus?.nextFocus();
  }

  /// Traverse to previous focusable widget
  void focusPrevious() {
    FocusManager.instance.primaryFocus?.previousFocus();
  }

  /// Check if device has accessibility features enabled
  bool get hasAccessibilityFeatures {
    return MediaQuery.of(
      NavigationService.navigatorKey.currentContext!,
    ).accessibleNavigation;
  }

  /// Get text scale factor for dynamic text sizing
  double get textScaleFactor {
    return MediaQuery.of(
      NavigationService.navigatorKey.currentContext!,
    ).textScaleFactor;
  }

  /// Check if user prefers reduced motion
  bool get prefersReducedMotion {
    return MediaQuery.of(
      NavigationService.navigatorKey.currentContext!,
    ).disableAnimations;
  }

  /// Check if device has high contrast enabled
  bool get hasHighContrast {
    return MediaQuery.of(
      NavigationService.navigatorKey.currentContext!,
    ).highContrast;
  }
}

/// Navigation service for accessibility focus management
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}
