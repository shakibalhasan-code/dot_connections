import 'package:dot_connections/app/controllers/splash_controller.dart';
import 'package:dot_connections/app/core/utils/app_colors.dart';
import 'package:dot_connections/app/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Splash screen shown when app is launched
///
/// This screen displays:
/// - App logo
/// - Loading animation
/// - App name
///
/// It automatically navigates to the appropriate screen based on authentication status
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo
                // Image.asset(
                //   AppImages.,
                //   width: 200.w,
                //   height: 200.h,
                // ),
                // SizedBox(height: 30.h),

                // App name
                Text(
                  'Dot Connections',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),

                SizedBox(height: 50.h),

                // Loading indicator
                Obx(
                  () => controller.isLoading.value
                      ? SizedBox(
                          width: 60.w,
                          height: 60.h,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryColor,
                            ),
                            strokeWidth: 3.w,
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
