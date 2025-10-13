import 'package:dot_connections/app/controllers/app_initial_controller.dart';
import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PassionsView extends StatelessWidget {
  const PassionsView({super.key});

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
                  "Interests",
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "What do you love?",
                  style: AppTextStyle.primaryTextStyle(fontSize: 16),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: controller.passions.map((passion) {
                      return Obx(() {
                        final isSelected = controller.selectedPassions.contains(
                          passion,
                        );
                        return GestureDetector(
                          onTap: () => controller.togglePassion(passion),
                          child: Chip(
                            shape: const StadiumBorder(),
                            label: Text(passion),
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
                ),
                ElevatedButton(
                  onPressed: () {
                    // final authController = Get.find<AuthController>();
                    // authController.currentUserProfile.value.jobTitle =
                    //     controller.selectedPassions;
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
