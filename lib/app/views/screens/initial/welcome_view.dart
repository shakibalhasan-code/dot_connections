import 'dart:math';

import 'package:dot_connections/app/core/utils/app_colors.dart';
import 'package:dot_connections/app/core/utils/app_icons.dart';
import 'package:dot_connections/app/core/utils/app_images.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:dot_connections/app/views/widgets/connections_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              "Welcome to",
              style: AppTextStyle.primaryTextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor.withOpacity(0.5),
              ),
            ),
            Text(
              "TRUEDOTS",
              style: AppTextStyle.primaryTextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 40.h),
            SizedBox(
              width: 300.w,
              height: 400.w,
              child: Image.asset(AppImages.welcomeImage),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to the main app screen
                Get.toNamed(AppRoutes.parent);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
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
  }

  Widget _buildProfile(String label, String imagePath, int index) {
    const double angleStep = 2 * pi / 5;
    final double angle = index * angleStep;
    final double radius = 120.w;
    final double x = cos(angle) * radius;
    final double y = sin(angle) * radius;

    return Transform(
      transform: Matrix4.translationValues(x, y, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 25.r, backgroundImage: AssetImage(imagePath)),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              label,
              style: AppTextStyle.primaryTextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
