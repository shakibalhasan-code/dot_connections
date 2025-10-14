import 'package:dot_connections/app/controllers/app_initial_controller.dart';
import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:dot_connections/app/views/screens/initial/interests_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HowTallView extends StatelessWidget {
  const HowTallView({super.key});

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
                  "How tall are you?",
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(
                  height: 300.h,
                  child: CupertinoPicker(
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      controller.setHeight(controller.heights[index]);
                    },
                    children: controller.heights
                        .map((height) => Center(child: Text(height)))
                        .toList(),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    // Get the AuthController
                    final authController = Get.find<AuthController>();

                    try {
                      // Extract height in cm from the format "5'6\" (167 cm)"
                      final heightString = controller.selectedHeight.value;
                      final regex = RegExp(r'\((\d+) cm\)');
                      final match = regex.firstMatch(heightString);
                      final heightInCm = match != null
                          ? int.parse(match.group(1)!)
                          : 167; // Default to 167cm if parsing fails

                      print(
                        '📏 Selected height: $heightString, parsed to $heightInCm cm',
                      );

                      // Get current user data
                      // final userData = authController.currentUser.value;
                      // if (userData == null) {
                      //   throw Exception('User data not available');
                      // }

                      // Update local user data with a new instance
                      authController.currentUserProfile.update((profile) {
                        profile?.height = heightInCm;
                      });
                      authController.currentUserProfile.refresh();

                      debugPrint(
                        '👤 Updated local profile height: ${authController.currentUserProfile.value.height}',
                      );

                      ///navigate to the next screen
                      Get.to(() => InterestsView());
                    } catch (e) {
                      print('Error saving height: $e');
                      Get.snackbar(
                        'Error',
                        'Failed to save your height. Please try again.',
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
