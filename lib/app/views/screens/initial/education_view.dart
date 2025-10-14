import 'package:dot_connections/app/controllers/app_initial_controller.dart';
import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:dot_connections/app/views/screens/initial/religious_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EducationView extends StatelessWidget {
  const EducationView({super.key});

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
                  "What is the height level you attained?",
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: 20.h),
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: controller.educationOptions.map((education) {
                    return Obx(() {
                      final isSelected =
                          controller.selectedEducation.value == education;
                      return GestureDetector(
                        onTap: () => controller.setEducation(education),
                        child: Chip(
                          shape: const StadiumBorder(),
                          label: Text(education),
                          backgroundColor: isSelected
                              ? Colors.purple
                              : Colors.grey[200],
                          labelStyle: AppTextStyle.primaryTextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    });
                  }).toList(),
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
                        value: controller.showEducationOnProfile.value,
                        onChanged: controller.toggleShowEducation,
                        activeColor: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    final authController = Get.find<AuthController>();

                    // Convert to API format
                    int index = controller.educationOptions.indexOf(
                      controller.selectedEducation.value,
                    );
                    String educationValue = index >= 0
                        ? controller.educationApiValues[index]
                        : "highSchool"; // Default

                    authController.currentUserProfile.value.school =
                        educationValue;

                    authController
                            .currentUserProfile
                            .value
                            .hiddenFields
                            .school =
                        controller.showEducationOnProfile.value;
                    authController.currentUserProfile.refresh();

                    debugPrint(
                      'Education: ${controller.selectedEducation.value}. && Show on profile: ${controller.showEducationOnProfile.value}',
                    );
                    Get.to(() => ReligiousView());
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
