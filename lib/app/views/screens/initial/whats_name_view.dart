import 'package:dot_connections/app/controllers/app_initial_controller.dart';
import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:dot_connections/app/views/screens/initial/enable_notifications_view.dart';
import 'package:dot_connections/app/views/screens/initial/whats_dob_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WhatsNameView extends StatelessWidget {
  const WhatsNameView({super.key});

  @override
  Widget build(BuildContext context) {
    // Make sure controller exists

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
                  "What's your name?",
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.firstNameController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'First name',
                          hintStyle: AppTextStyle.primaryTextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: TextField(
                        controller: controller.lastNameController,
                        decoration: InputDecoration(
                          hintText: 'Last name',
                          hintStyle: AppTextStyle.primaryTextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  'Last name is optional, and only shared with matches.',
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const Spacer(),
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.isNameButtonEnabled
                        ? () async {
                            // Get the AuthController
                            final authController = Get.find<AuthController>();

                            try {
                              // Save user fields with the AuthController
                              authController.userData['firstName'] =
                                  controller.firstNameController.text;
                              authController.userData['lastName'] =
                                  controller.lastNameController.text;

                              // Debug - print the values to confirm they're being set
                              print(
                                '👤 Setting firstName: ${controller.firstNameController.text}',
                              );
                              print(
                                '👤 Setting lastName: ${controller.lastNameController.text}',
                              );
                              print(
                                '👤 AuthController userData: ${authController.userData}',
                              );

                              Get.to(WhatsDobView());
                            } catch (e) {
                              print('Error saving name: $e');
                              Get.snackbar(
                                'Error',
                                'Failed to save your name. Please try again.',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.isNameButtonEnabled
                          ? Colors.purple
                          : Colors.grey,
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
