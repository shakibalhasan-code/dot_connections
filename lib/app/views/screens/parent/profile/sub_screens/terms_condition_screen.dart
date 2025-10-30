import 'package:dot_connections/app/core/utils/app_colors.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Terms & Conditions',
              style: AppTextStyle.primaryTextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
            Text(
              'Review and accept updated policies.',
              style: AppTextStyle.primaryTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryTextColor,
              ),
            ),

            SizedBox(height: 30.h),
            Text(
              'You are granted a limited. non transferable license to use the app for personal or commercial reading purposes. Unauthorized reproduction or distribution of content is prohibited',
              style: AppTextStyle.primaryTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryTextColor,
              ),
            ),
            SizedBox(height: 10.h),

            Text(
              'You are granted a limited. non transferable license to use the app for personal or commercial reading purposes. Unauthorized reproduction or distribution of content is prohibited',
              style: AppTextStyle.primaryTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryTextColor,
              ),
            ),
            SizedBox(height: 10.h),

            Text(
              'You are granted a limited. non transferable license to use the app for personal or commercial reading purposes. Unauthorized reproduction or distribution of content is prohibited',
              style: AppTextStyle.primaryTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
