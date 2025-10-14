import 'package:dot_connections/app/controllers/app_initial_controller.dart';
import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WhoToDateView extends StatelessWidget {
  const WhoToDateView({super.key});

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
                  "Who do you want to date?",
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: 20.h),
                ...controller.datingOptions.map(
                  (option) => Obx(
                    () => RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: controller.datingPreference.value,
                      onChanged: (value) {
                        if (value != null) {
                          controller.setDatingPreference(value);
                        }
                      },
                      activeColor: Colors.purple,
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Get the AuthController
                    final authController = Get.find<AuthController>();

                    // Update the interestedIn value in the current profile with API format
                    authController.currentUserProfile.update((profile) {
                      // Convert display preference to API format
                      final int index = controller.datingOptions.indexOf(
                        controller.datingPreference.value,
                      );
                      profile?.interestedIn = controller.datingApiValues[index];
                    });
                    authController.currentUserProfile.refresh();

                    debugPrint(
                      '👤 Updated profile interestedIn: ${authController.currentUserProfile.value.interestedIn}',
                    );

                    Get.toNamed(AppRoutes.howTall);
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
