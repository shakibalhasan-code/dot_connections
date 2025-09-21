import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:pinput/pinput.dart';
import '../../controllers/app_initial_controller.dart';
import '../../controllers/language_controller.dart';

/// GetX SignIn Bottom Sheet Widget
///
/// This follows proper GetX architecture:
/// - StatelessWidget for better performance
/// - GetBuilder for reactive UI updates
/// - Rx variables in controller for state management
class SignInBottomSheet extends StatelessWidget {
  const SignInBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<AppInitialController>(
      builder: (controller) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: theme.colorScheme.scrim.withOpacity(0.5),
            child: DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Handle bar
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        width: 50,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.outline,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // Header - Reactive to language changes
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            if (controller.currentStep.value > 0)
                              IconButton(
                                onPressed: () => controller.previousStep(),
                                icon: const Icon(Icons.arrow_back_ios),
                              ),
                            Expanded(
                              child: GetBuilder<LanguageController>(
                                builder: (langController) {
                                  return Text(
                                    controller.currentStep.value == 0
                                        ? 'sign_in_header'.tr()
                                        : 'verify_otp_header'.tr(),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                    textAlign: controller.currentStep.value > 0
                                        ? TextAlign.left
                                        : TextAlign.center,
                                  );
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),
                      // Content
                      Expanded(
                        child: PageView(
                          controller: controller.pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildEmailStep(controller, theme),
                            _buildOtpStep(controller, theme, context),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Handle sign-in success
  void _handleSignInSuccess(BuildContext context) {
    Navigator.pop(context);
    Get.offAllNamed('/parent');
  }

  Widget _buildEmailStep(AppInitialController controller, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Description - Reactive to language changes
          GetBuilder<LanguageController>(
            builder: (langController) {
              return Text(
                'enter_email_description'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          // Email input field
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: GetBuilder<LanguageController>(
              builder: (langController) {
                return TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'email_address'.tr(),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Email validation - Reactive to both email changes and language
          GetBuilder<AppInitialController>(
            builder: (appController) {
              return GetBuilder<LanguageController>(
                builder: (langController) {
                  final email = appController.email.value;
                  if (email.isNotEmpty && !GetUtils.isEmail(email)) {
                    return Text(
                      'please_enter_valid_email'.tr(),
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontSize: 12,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              );
            },
          ),
          const SizedBox(height: 40),
          // Continue button - Reactive to both button state and language
          SizedBox(
            width: double.infinity,
            child: GetBuilder<AppInitialController>(
              builder: (appController) {
                return GetBuilder<LanguageController>(
                  builder: (langController) {
                    return ElevatedButton(
                      onPressed: appController.isEmailButtonEnabledRx.value
                          ? () => appController.nextStep()
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        disabledBackgroundColor: theme.colorScheme.primary
                            .withOpacity(0.3),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'continue'.tr(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildOtpStep(
    AppInitialController controller,
    ThemeData theme,
    BuildContext context,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // OTP description - Reactive to language changes
          GetBuilder<LanguageController>(
            builder: (langController) {
              return Text(
                'enter_otp_description'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          // Email display - Reactive to email changes
          Obx(() {
            return Text(
              controller.email.value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            );
          }),
          const SizedBox(height: 32),
          // OTP input field
          Center(
            child: Pinput(
              length: 6,
              controller: controller.otpController,
              onChanged: (value) => controller.otp.value = value,
              defaultPinTheme: PinTheme(
                width: 48,
                height: 56,
                textStyle: TextStyle(
                  fontSize: 20,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Resend OTP - Reactive to language changes
          Center(
            child: GetBuilder<LanguageController>(
              builder: (langController) {
                return TextButton(
                  onPressed: () {
                    Get.snackbar(
                      'otp_sent'.tr(),
                      'otp_sent_to_email'.tr(
                        namedArgs: {'email': controller.email.value},
                      ),
                      backgroundColor: theme.colorScheme.primary,
                      colorText: theme.colorScheme.onPrimary,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  child: Text(
                    'resend_otp'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
          // Verify button - Reactive to both button state and language
          SizedBox(
            width: double.infinity,
            child: GetBuilder<AppInitialController>(
              builder: (appController) {
                return GetBuilder<LanguageController>(
                  builder: (langController) {
                    return Obx(() {
                      return ElevatedButton(
                        onPressed: appController.isOtpButtonEnabledRx.value
                            ? () => _handleSignInSuccess(context)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          disabledBackgroundColor: theme.colorScheme.primary
                              .withOpacity(0.3),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'verify_sign_in'.tr(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      );
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
