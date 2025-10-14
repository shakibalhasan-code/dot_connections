import 'package:dot_connections/app/controllers/app_initial_controller.dart';
import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:dot_connections/app/views/screens/initial/drink_status_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ReligiousView extends StatelessWidget {
  const ReligiousView({super.key});

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
                  "What is your religious beliefs?",
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
                  children: controller.religionOptions.map((religion) {
                    return Obx(() {
                      final isSelected =
                          controller.selectedReligion.value == religion;
                      return GestureDetector(
                        onTap: () => controller.setReligion(religion),
                        child: Chip(
                          shape: const StadiumBorder(),
                          label: Text(religion),
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
                        value: controller.showReligionOnProfile.value,
                        onChanged: controller.toggleShowReligion,
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
                    int index = controller.religionOptions.indexOf(
                      controller.selectedReligion.value,
                    );
                    String religionValue = index >= 0
                        ? controller.religionApiValues[index]
                        : "prefer_not_to_say"; // Default

                    authController.currentUserProfile.value.religious =
                        religionValue;
                    authController
                            .currentUserProfile
                            .value
                            .hiddenFields
                            .religious =
                        controller.showReligionOnProfile.value;
                    authController.currentUserProfile.refresh();

                    debugPrint(
                      'Religion: ${controller.selectedReligion.value}. && Show on profile: ${controller.showReligionOnProfile.value}',
                    );
                    Get.to(() => DrinkStatusView());
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
