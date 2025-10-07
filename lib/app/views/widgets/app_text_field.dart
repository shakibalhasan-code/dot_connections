import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/text_style.dart';

/// AppTextField provides consistent, customizable text input throughout the app
///
/// This widget offers enhanced functionality over standard TextFormField:
/// - Consistent styling across the app
/// - Built-in validation states
/// - Loading and disabled states
/// - Prefix/suffix icons with animations
/// - Character counting
/// - Password visibility toggle
/// - Theme-aware styling
///
/// Usage examples:
/// ```dart
/// AppTextField.email(
///   controller: emailController,
///   onChanged: (value) => print(value),
/// )
///
/// AppTextField.password(
///   controller: passwordController,
///   validator: (value) => validatePassword(value),
/// )
/// ```
class AppTextField extends StatefulWidget {
  /// Text controller
  final TextEditingController? controller;

  /// Placeholder text
  final String? hintText;

  /// Field label
  final String? labelText;

  /// Helper text shown below the field
  final String? helperText;

  /// Error text (overrides validation)
  final String? errorText;

  /// Validation function
  final String? Function(String?)? validator;

  /// Text change callback
  final Function(String)? onChanged;

  /// Submit callback
  final Function(String)? onSubmitted;

  /// Tap callback
  final VoidCallback? onTap;

  /// Focus change callback
  final Function(bool)? onFocusChange;

  /// Text input type
  final TextInputType keyboardType;

  /// Text input action
  final TextInputAction textInputAction;

  /// Text capitalization
  final TextCapitalization textCapitalization;

  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// Maximum lines (1 for single line, null for unlimited)
  final int? maxLines;

  /// Maximum length
  final int? maxLength;

  /// Minimum lines
  final int? minLines;

  /// Whether field is required
  final bool isRequired;

  /// Whether field is enabled
  final bool enabled;

  /// Whether field is in loading state
  final bool isLoading;

  /// Whether to obscure text (for passwords)
  final bool obscureText;

  /// Whether to show character counter
  final bool showCounter;

  /// Auto focus
  final bool autofocus;

  /// Read only
  final bool readOnly;

  /// Prefix icon
  final Widget? prefixIcon;

  /// Suffix icon
  final Widget? suffixIcon;

  /// Custom decoration
  final InputDecoration? decoration;

  /// Text style
  final TextStyle? style;

  /// Focus node
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.helperText,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onFocusChange,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.minLines,
    this.isRequired = false,
    this.enabled = true,
    this.isLoading = false,
    this.obscureText = false,
    this.showCounter = false,
    this.autofocus = false,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.decoration,
    this.style,
    this.focusNode,
  });

  /// Creates an email text field
  factory AppTextField.email({
    Key? key,
    TextEditingController? controller,
    String? hintText,
    String? labelText,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    Function(String)? onSubmitted,
    bool isRequired = false,
    bool enabled = true,
    bool autofocus = false,
    FocusNode? focusNode,
  }) {
    return AppTextField(
      key: key,
      controller: controller,
      hintText: hintText ?? 'Enter your email',
      labelText: labelText ?? 'Email',
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      validator: validator ?? _defaultEmailValidator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      isRequired: isRequired,
      enabled: enabled,
      autofocus: autofocus,
      focusNode: focusNode,
      prefixIcon: const Icon(Icons.email_outlined),
    );
  }

  /// Creates a password text field
  factory AppTextField.password({
    Key? key,
    TextEditingController? controller,
    String? hintText,
    String? labelText,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    Function(String)? onSubmitted,
    bool isRequired = false,
    bool enabled = true,
    bool autofocus = false,
    FocusNode? focusNode,
  }) {
    return _AppPasswordTextField(
      key: key,
      controller: controller,
      hintText: hintText ?? 'Enter your password',
      labelText: labelText ?? 'Password',
      validator: validator ?? _defaultPasswordValidator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      isRequired: isRequired,
      enabled: enabled,
      autofocus: autofocus,
      focusNode: focusNode,
    );
  }

  /// Creates a search text field
  factory AppTextField.search({
    Key? key,
    TextEditingController? controller,
    String? hintText,
    Function(String)? onChanged,
    Function(String)? onSubmitted,
    VoidCallback? onTap,
    bool enabled = true,
    bool autofocus = false,
    FocusNode? focusNode,
  }) {
    return AppTextField(
      key: key,
      controller: controller,
      hintText: hintText ?? 'Search...',
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      enabled: enabled,
      autofocus: autofocus,
      focusNode: focusNode,
      prefixIcon: const Icon(Icons.search),
    );
  }

  /// Creates a multiline text field
  factory AppTextField.multiline({
    Key? key,
    TextEditingController? controller,
    String? hintText,
    String? labelText,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    int maxLines = 3,
    int? maxLength,
    bool showCounter = false,
    bool isRequired = false,
    bool enabled = true,
    FocusNode? focusNode,
  }) {
    return AppTextField(
      key: key,
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      validator: validator,
      onChanged: onChanged,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      textCapitalization: TextCapitalization.sentences,
      maxLines: maxLines,
      minLines: 2,
      maxLength: maxLength,
      showCounter: showCounter,
      isRequired: isRequired,
      enabled: enabled,
      focusNode: focusNode,
    );
  }

  /// Default email validator
  static String? _defaultEmailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Default password validator
  static String? _defaultPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    widget.onFocusChange?.call(_isFocused);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with required indicator
        if (widget.labelText != null) ...[
          Row(
            children: [
              Text(
                widget.labelText!,
                style: AppTextStyle.primaryTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (widget.isRequired) ...[
                SizedBox(width: 4.w),
                Text(
                  '*',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 8.h),
        ],

        // Text field
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            enabled: widget.enabled && !widget.isLoading,
            autofocus: widget.autofocus,
            readOnly: widget.readOnly,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            textCapitalization: widget.textCapitalization,
            inputFormatters: widget.inputFormatters,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            maxLength: widget.maxLength,
            style:
                widget.style ??
                AppTextStyle.primaryTextStyle(
                  fontSize: 16.sp,
                  color: theme.colorScheme.onSurface,
                ),
            decoration: widget.decoration ?? _buildInputDecoration(theme),
            validator: widget.validator,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            onTap: widget.onTap,
          ),
        ),

        // Helper text
        if (widget.helperText != null) ...[
          SizedBox(height: 4.h),
          Text(
            widget.helperText!,
            style: AppTextStyle.primaryTextStyle(
              fontSize: 12.sp,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ],
    );
  }

  /// Builds input decoration
  InputDecoration _buildInputDecoration(ThemeData theme) {
    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: AppTextStyle.primaryTextStyle(
        fontSize: 16.sp,
        color: theme.colorScheme.onSurface.withOpacity(0.5),
      ),
      prefixIcon: widget.prefixIcon != null
          ? Padding(
              padding: EdgeInsets.only(left: 12.w, right: 8.w),
              child: widget.prefixIcon,
            )
          : null,
      prefixIconConstraints: BoxConstraints(minWidth: 40.w, minHeight: 24.h),
      suffixIcon: _buildSuffixIcon(theme),
      filled: true,
      fillColor: _getFillColor(theme),
      border: _buildBorder(theme, false, false),
      enabledBorder: _buildBorder(theme, false, false),
      focusedBorder: _buildBorder(theme, true, false),
      errorBorder: _buildBorder(theme, false, true),
      focusedErrorBorder: _buildBorder(theme, true, true),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      counterText: widget.showCounter ? null : '',
      errorText: widget.errorText,
    );
  }

  /// Builds suffix icon with loading state
  Widget? _buildSuffixIcon(ThemeData theme) {
    if (widget.isLoading) {
      return Padding(
        padding: EdgeInsets.all(12.w),
        child: SizedBox(
          width: 20.w,
          height: 20.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),
      );
    }

    return widget.suffixIcon != null
        ? Padding(
            padding: EdgeInsets.only(right: 12.w, left: 8.w),
            child: widget.suffixIcon,
          )
        : null;
  }

  /// Gets fill color based on state
  Color _getFillColor(ThemeData theme) {
    if (!widget.enabled || widget.isLoading) {
      return theme.colorScheme.surfaceVariant.withOpacity(0.5);
    }
    if (_isFocused) {
      return theme.colorScheme.surfaceVariant.withOpacity(0.8);
    }
    return theme.colorScheme.surfaceVariant;
  }

  /// Builds border based on state
  OutlineInputBorder _buildBorder(
    ThemeData theme,
    bool isFocused,
    bool hasError,
  ) {
    Color borderColor;
    double borderWidth;

    if (hasError) {
      borderColor = theme.colorScheme.error;
      borderWidth = isFocused ? 2 : 1;
    } else if (isFocused) {
      borderColor = theme.colorScheme.primary;
      borderWidth = 2;
    } else {
      borderColor = Colors.transparent;
      borderWidth = 1;
    }

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: borderColor, width: borderWidth),
    );
  }
}

/// Specialized password text field with visibility toggle
class _AppPasswordTextField extends AppTextField {
  const _AppPasswordTextField({
    super.key,
    super.controller,
    super.hintText,
    super.labelText,
    super.validator,
    super.onChanged,
    super.onSubmitted,
    super.isRequired,
    super.enabled,
    super.autofocus,
    super.focusNode,
  }) : super(
         keyboardType: TextInputType.visiblePassword,
         textInputAction: TextInputAction.done,
         textCapitalization: TextCapitalization.none,
       );

  @override
  State<_AppPasswordTextField> createState() => _AppPasswordTextFieldState();
}

class _AppPasswordTextFieldState extends State<_AppPasswordTextField> {
  bool _isObscured = true;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    widget.onFocusChange?.call(_isFocused);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with required indicator
        if (widget.labelText != null) ...[
          Row(
            children: [
              Text(
                widget.labelText!,
                style: AppTextStyle.primaryTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (widget.isRequired) ...[
                SizedBox(width: 4.w),
                Text(
                  '*',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 8.h),
        ],

        // Password field
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            autofocus: widget.autofocus,
            obscureText: _isObscured,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            style: AppTextStyle.primaryTextStyle(
              fontSize: 16.sp,
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTextStyle.primaryTextStyle(
                fontSize: 16.sp,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 12, right: 8),
                child: Icon(Icons.lock_outline),
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 40.w,
                minHeight: 24.h,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                    key: ValueKey(_isObscured),
                  ),
                ),
              ),
              filled: true,
              fillColor: _isFocused
                  ? theme.colorScheme.surfaceVariant.withOpacity(0.8)
                  : theme.colorScheme.surfaceVariant,
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
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
            ),
            validator: widget.validator,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
          ),
        ),
      ],
    );
  }
}
