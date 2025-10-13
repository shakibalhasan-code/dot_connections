import 'package:dot_connections/app/controllers/app_initial_controller.dart';
import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:dot_connections/app/views/screens/initial/enable_notifications_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WhatsDobView extends StatelessWidget {
  const WhatsDobView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppInitialController>(
      builder: (controller) {
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
                  "What's your date of birth?",
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(
                  height: 200.h,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: controller.selectedDate.value,
                    onDateTimeChanged: controller.setDate,
                  ),
                ),
                const Spacer(),
                Center(
                  child: Obx(
                    () => Text(
                      'Age ${controller.age.value}',
                      style: AppTextStyle.primaryTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    SizedBox(width: 10.w),
                    Text(
                      "Age can't be changed later",
                      style: AppTextStyle.primaryTextStyle(color: Colors.red),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () async {
                    // Get the AuthController
                    final authController = Get.find<AuthController>();

                    try {
                      // Save user fields with the AuthController
                      authController.userData['dateOfBirth'] =
                          controller.selectedDate.value;

                      // Debug - print to verify the data is being preserved
                      print(
                        '👤 DOB View - firstName: ${authController.userData['firstName']}',
                      );
                      print(
                        '👤 DOB View - lastName: ${authController.userData['lastName']}',
                      );
                      print(
                        '👤 DOB View - dateOfBirth: ${controller.selectedDate.value}',
                      );
                      print(
                        '👤 DOB View - userData: ${authController.userData}',
                      );

                      Get.to(EnableNotificationsView());

                      // Navigation will be handled by the AuthController.addUserFields method
                    } catch (e) {
                      print('Error saving DOB: $e');
                      Get.snackbar(
                        'Error',
                        'Failed to save your date of birth. Please try again.',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Text(
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
        );
      },
    );
  }
}
