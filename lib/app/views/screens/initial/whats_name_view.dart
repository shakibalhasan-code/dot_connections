import 'package:dot_connections/app/controllers/app_initial_controller.dart';
import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WhatsNameView extends StatelessWidget {
  const WhatsNameView({super.key});

  @override
  Widget build(BuildContext context) {
    // Make sure controller exists
    final controller = Get.find<AppInitialController>();
    print('👤 WhatsNameView: Controller found with firstName: ${controller.firstName.value}');
    
    return GetBuilder<AppInitialController>(
      init: controller,
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
                              await authController.addUserFields(
                                firstName: controller.firstName.value,
                                lastName: controller.lastName.value,
                                dateOfBirth: DateTime.now(), // We'll update this on the DOB screen
                                pushNotification: false, // We'll update this on the notifications screen
                              );
                              
                              // Navigation is now handled by AuthController.addUserFields method
                              // It will navigate to the next screen after saving data successfully
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
