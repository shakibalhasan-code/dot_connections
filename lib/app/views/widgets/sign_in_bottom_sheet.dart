import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../controllers/app_initial_controller.dart';

class SignInBottomSheet extends StatefulWidget {
  const SignInBottomSheet({super.key});

  @override
  State<SignInBottomSheet> createState() => _SignInBottomSheetState();
}

class _SignInBottomSheetState extends State<SignInBottomSheet> {
  final PageController _pageController = PageController();
  final AppInitialController controller = Get.find<AppInitialController>();
  int _currentStep = 0;

  void _nextStep() {
    if (_currentStep < 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleSignInSuccess() {
    Navigator.pop(context);
    Get.offAllNamed('/parent');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        if (_currentStep > 0)
                          IconButton(
                            onPressed: _previousStep,
                            icon: const Icon(Icons.arrow_back_ios),
                          ),
                        Expanded(
                          child: Text(
                            _currentStep == 0 ? 'Sign In' : 'Verify OTP',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                            textAlign: _currentStep > 0
                                ? TextAlign.left
                                : TextAlign.center,
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
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [_buildEmailStep(), _buildOtpStep()],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmailStep() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Enter your email address to sign in',
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 32),
          // Email input field
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Obx(
              () => TextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email Address',
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
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Email validation message
          Obx(() {
            if (controller.email.value.isNotEmpty &&
                !GetUtils.isEmail(controller.email.value)) {
              return Text(
                'Please enter a valid email address',
                style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
              );
            }
            return const SizedBox.shrink();
          }),
          const Spacer(),
          // Continue button
          Obx(
            () => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 40),
              child: ElevatedButton(
                onPressed: controller.isEmailButtonEnabled ? _nextStep : null,
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
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpStep() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Enter the OTP sent to:',
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              controller.email.value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
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
              focusedPinTheme: PinTheme(
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
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              submittedPinTheme: PinTheme(
                width: 48,
                height: 56,
                textStyle: TextStyle(
                  fontSize: 20,
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Resend OTP
          Center(
            child: TextButton(
              onPressed: () {
                // Implement resend OTP logic
                Get.snackbar(
                  'OTP Sent',
                  'OTP has been sent to ${controller.email.value}',
                  backgroundColor: theme.colorScheme.primary,
                  colorText: theme.colorScheme.onPrimary,
                  duration: const Duration(seconds: 2),
                );
              },
              child: Text(
                'Resend OTP',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const Spacer(),
          // Verify button
          Obx(
            () => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 40),
              child: ElevatedButton(
                onPressed: controller.isOtpButtonEnabled
                    ? _handleSignInSuccess
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
                  'Verify & Sign In',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
