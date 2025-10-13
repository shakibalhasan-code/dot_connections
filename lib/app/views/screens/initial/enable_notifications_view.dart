import 'package:dot_connections/app/controllers/app_initial_controller.dart';
import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EnableNotificationsView extends StatelessWidget {
  const EnableNotificationsView({super.key});

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
                  "Never miss a message from someone great",
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: 40.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Enable Notifications',
                        style: AppTextStyle.primaryTextStyle(),
                      ),
                      Obx(
                        () => Switch(
                          value: controller.notificationsEnabled.value,
                          onChanged: controller.toggleNotifications,
                          activeColor: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    // Get the AuthController
                    final authController = Get.find<AuthController>();

                    try {
                      // Save user fields with the AuthController
                      authController.userData['notificationsEnabled'] =
                          controller.notificationsEnabled.value;

                      // Debug - print all user data before submitting
                      print('👤 Notifications View - Complete userData:');
                      print(
                        '👤 firstName: ${authController.userData['firstName']}',
                      );
                      print(
                        '👤 lastName: ${authController.userData['lastName']}',
                      );
                      print(
                        '👤 dateOfBirth: ${authController.userData['dateOfBirth']}',
                      );
                      print(
                        '👤 notificationsEnabled: ${controller.notificationsEnabled.value}',
                      );

                      // Now call the method to send all the data to the backend
                      await authController.addUserFields();

                      // Navigation will be handled by AuthController.addUserFields
                    } catch (e) {
                      print('Error saving notification preference: $e');
                      Get.snackbar(
                        'Error',
                        'Failed to save your notification preference. Please try again.',
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
