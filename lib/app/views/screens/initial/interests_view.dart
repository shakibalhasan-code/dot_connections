import 'package:dot_connections/app/controllers/app_initial_controller.dart';
import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:dot_connections/app/views/screens/initial/preferences_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class InterestsView extends StatelessWidget {
  const InterestsView({super.key});

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
                    final authController = Get.find<AuthController>();

                    // Update the interests using the update method for consistency and convert to API format
                    authController.currentUserProfile.update((profile) {
                      // Convert display passions to API format (lowercase with underscores)
                      List<String> apiPassions = [];
                      for (String passion in controller.selectedPassions) {
                        int index = controller.passions.indexOf(passion);
                        if (index >= 0) {
                          apiPassions.add(controller.passionsApiValues[index]);
                        }
                      }
                      profile?.interests = apiPassions;

                      // Ensure we have at least one interest if nothing selected
                      if (profile?.interests.isEmpty ?? true) {
                        profile?.interests = ['travel']; // Default interest
                      }
                    });
                    authController.currentUserProfile.refresh();

                    debugPrint(
                      '👤 Updated profile interests: ${authController.currentUserProfile.value.interests}',
                    );
                    Get.to(() => PreferencesView());
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
