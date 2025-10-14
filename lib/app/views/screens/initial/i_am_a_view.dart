import 'package:dot_connections/app/controllers/app_initial_controller.dart';
import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class IAmAView extends StatelessWidget {
  const IAmAView({super.key});

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
                  "I'm a",
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: 20.h),
                ...controller.genderOptions.map(
                  (option) => Obx(
                    () => RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: controller.gender.value,
                      onChanged: (value) {
                        if (value != null) {
                          controller.setGender(value);
                        }
                      },
                      activeColor: Colors.purple,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Show on profile',
                      style: AppTextStyle.primaryTextStyle(),
                    ),
                    Obx(
                      () => Switch(
                        value: controller.showGenderOnProfile.value,
                        onChanged: controller.toggleShowGender,
                        activeColor: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Get the AuthController
                    final authController = Get.find<AuthController>();

                    // Update the gender value in the current profile with API format (lowercase)
                    authController.currentUserProfile.update((profile) {
                      // Convert display gender to API format (lowercase)
                      final int index = controller.genderOptions.indexOf(
                        controller.gender.value,
                      );
                      profile?.gender = controller.genderApiValues[index];
                      profile?.hiddenFields.gender =
                          !controller.showGenderOnProfile.value;
                    });
                    authController.currentUserProfile.refresh();

                    debugPrint(
                      '👤 Updated profile gender: ${authController.currentUserProfile.value.gender}, hidden: ${authController.currentUserProfile.value.hiddenFields.gender}',
                    );

                    Get.toNamed(AppRoutes.whoToDate);
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
