import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../controllers/app_initial_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/app_routes.dart';

class SignInBottomSheet extends StatefulWidget {
  const SignInBottomSheet({super.key});

  @override
  State<SignInBottomSheet> createState() => _SignInBottomSheetState();
}

class _SignInBottomSheetState extends State<SignInBottomSheet> {
  final PageController _pageController = PageController();
  final AppInitialController controller = Get.find<AppInitialController>();
  final AuthController authController = Get.find<AuthController>();
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

  Future<void> _handleSignInSuccess() async {
    // Transfer the values from AppInitialController to AuthController
    authController.emailController.text = controller.email.value;
    authController.otpController.text = controller.otp.value;
    
    // Show loading indicator
    setState(() {
      // Show loading if needed
    });
    
    try {
      // Close the bottom sheet before navigation to prevent UI stacking
      Navigator.pop(context);
      
      // Wait a short time to ensure the bottom sheet is fully closed
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Call the AuthController's verifyOtp method
      await authController.verifyOtp();
      
      // Note: Navigation is now handled entirely by the authController
    } catch (e) {
      print('Error during sign in: $e');
      Get.snackbar(
        'Error',
        'Failed to verify OTP. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.scaffoldBg,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: ListView(
                controller: scrollController,
                shrinkWrap: true,
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
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
                            _currentStep == 0 
                                ? 'Sign In' 
                                : 'Verify OTP',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryTextColor,
                            ),
                            textAlign: _currentStep > 0 ? TextAlign.left : TextAlign.center,
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
                      children: [
                        _buildEmailStep(),
                        _buildOtpStep(),
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
  }

  Widget _buildEmailStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Enter your email address to sign in',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.secondaryTextColor,
              ),
            ),
            const SizedBox(height: 32),
            // Email input field
            Container(
              decoration: BoxDecoration(
                color: AppColors.fieldBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email Address',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  hintStyle: TextStyle(
                    color: AppColors.secondaryTextColor.withOpacity(0.6),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.primaryTextColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Email validation message
            GetBuilder<AppInitialController>(
              builder: (ctrl) {
                if (ctrl.email.value.isNotEmpty && !GetUtils.isEmail(ctrl.email.value)) {
                  return Text(
                    'Please enter a valid email address',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  );
                }
                return const SizedBox.shrink();
              }
            ),
            const SizedBox(height: 100),
            // Continue button
            GetBuilder<AppInitialController>(
              builder: (ctrl) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 40),
                child: ElevatedButton(
                  onPressed: ctrl.isEmailButtonEnabled ? _nextStep : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    disabledBackgroundColor: AppColors.primaryColor.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Enter the OTP sent to:',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.secondaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            GetBuilder<AppInitialController>(
              builder: (ctrl) => Text(
                ctrl.email.value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              )
            ),
            const SizedBox(height: 32),
            // OTP input field
            Center(
              child: Pinput(
                length: 6,
                controller: controller.otpController,
                onChanged: (value) {
                  controller.otp.value = value;
                  controller.update();
                },
                defaultPinTheme: PinTheme(
                  width: 48,
                  height: 56,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: AppColors.primaryTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.fieldBgColor,
                    border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 48,
                  height: 56,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: AppColors.primaryTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.fieldBgColor,
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                submittedPinTheme: PinTheme(
                  width: 48,
                  height: 56,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Resend OTP
            Center(
              child: TextButton(
                onPressed: () async {
                  // Transfer email from AppInitialController to AuthController
                  authController.emailController.text = controller.email.value;
                  
                  // Call the AuthController's sendOtp method
                  try {
                    await authController.sendOtp();
                    Get.snackbar(
                      'OTP Sent',
                      'OTP has been resent to ${controller.email.value}',
                      backgroundColor: AppColors.primaryColor,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                    );
                  } catch (e) {
                    Get.snackbar(
                      'Error',
                      'Failed to resend OTP: $e',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                child: Text(
                  'Resend OTP',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
            // Verify button
            GetBuilder<AppInitialController>(
              builder: (ctrl) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 40),
                child: ElevatedButton(
                  onPressed: ctrl.isOtpButtonEnabled 
                    ? () => _handleSignInSuccess()
                    : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    disabledBackgroundColor: AppColors.primaryColor.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Obx(() => authController.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Verify & Sign In',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}