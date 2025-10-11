import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpView extends StatelessWidget {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "6-digit code",
                style: AppTextStyle.primaryTextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Please enter the code we've sent to ${authController.emailController.text}",
                style: AppTextStyle.primaryTextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 40.h),
              Pinput(
                length: 6,
                controller: authController.otpController,
                autofocus: true,
                onChanged: (value) {
                  // The controller has a listener that will validate the OTP
                },
              ),
              if (authController.errorMessage.value.isNotEmpty) ...[
                SizedBox(height: 10.h),
                Text(
                  authController.errorMessage.value,
                  style: AppTextStyle.primaryTextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ],
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Didn't receive a code?",
                    style: AppTextStyle.primaryTextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () => authController.sendOtp(),
                    child: Text(
                      "Resend code",
                      style: AppTextStyle.primaryTextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: authController.isLoading.value
                    ? null
                    : authController.isOtpValid.value
                    ? () => authController.verifyOtp()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: authController.isOtpValid.value
                      ? Colors.purple
                      : Colors.grey,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                ),
                child: authController.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Continue',
                        style: AppTextStyle.primaryTextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
