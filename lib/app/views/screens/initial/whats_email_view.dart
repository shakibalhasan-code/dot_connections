import 'package:dot_connections/app/controllers/app_initial_controller.dart';
import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WhatsEmailView extends StatelessWidget {
  const WhatsEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get both controllers
    final initialController = Get.find<AppInitialController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
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
              "What's your email?",
              style: AppTextStyle.primaryTextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: authController.emailController,
              keyboardType: TextInputType.emailAddress,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'e.g. johndoe@gmail.com',
                hintStyle: AppTextStyle.primaryTextStyle(color: Colors.grey),
                errorText: authController.errorMessage.value.isEmpty
                    ? null
                    : authController.errorMessage.value,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Obx(
                  () => Checkbox(
                    value: initialController.isMarketingChecked.value,
                    onChanged: initialController.toggleMarketing,
                    activeColor: Colors.purple,
                  ),
                ),
                Expanded(
                  child: Text(
                    'I do not wish to receive marketing communications about peace products & service',
                    style: AppTextStyle.primaryTextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              'We will send you a text with a verification code. Message and data rates may apply',
              textAlign: TextAlign.center,
              style: AppTextStyle.primaryTextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10.h),
            Obx(
              () => ElevatedButton(
                onPressed: authController.isLoading.value
                    ? null
                    : authController.isEmailValid.value
                    ? () => authController.sendOtp()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: authController.isEmailValid.value
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
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
