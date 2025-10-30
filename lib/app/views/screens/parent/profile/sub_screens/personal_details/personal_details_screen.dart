import 'package:dot_connections/app/core/utils/app_colors.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalDetailsScreen extends StatelessWidget {
  const PersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Assuming ScreenUtilInit is somewhere in your app's widget tree
    // For standalone running, you might wrap this Scaffold with it.
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0, // Removes the shadow to match the design
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Details',
                style: AppTextStyle.primaryTextStyle(
                  fontSize: 24.sp,
                  color: AppColors.primaryTextColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Keep your personal info accurate.',
                style: AppTextStyle.primaryTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextColor,
                ),
              ),
              SizedBox(height: 30.h),

              // --- List of Details ---
              personalDetailsMethod(
                title: 'Interests',
                subWidget: Row(
                  children: [
                    _buildChip('Hiking'),
                    SizedBox(width: 8.w),
                    _buildChip('Cooking'),
                    SizedBox(width: 8.w),
                    _buildChip('Music'),
                  ],
                ),
              ),
              SizedBox(height: 15.h),

              personalDetailsMethod(
                title: 'Preferences',
                subWidget: Text(
                  'What do you love?',
                  style: AppTextStyle.primaryTextStyle(fontSize: 16.sp),
                ),
              ),
              SizedBox(height: 15.h),

              personalDetailsMethod(
                title: 'Where is your hometown?',
                subWidget: Text(
                  'Saint Barthélemy',
                  style: AppTextStyle.primaryTextStyle(fontSize: 16.sp),
                ),
              ),
              SizedBox(height: 15.h),

              personalDetailsMethod(
                title: 'Where do you work?',
                subWidget: Text(
                  'Poland',
                  style: AppTextStyle.primaryTextStyle(fontSize: 16.sp),
                ),
              ),
              SizedBox(height: 15.h),

              personalDetailsMethod(
                title: 'What is your job title?',
                subWidget: Text(
                  'Marketing manager', // Matched case from image
                  style: AppTextStyle.primaryTextStyle(fontSize: 16.sp),
                ),
              ),
              SizedBox(height: 15.h),

              personalDetailsMethod(
                title: 'Where did you go to school?',
                subWidget: Text(
                  'Ecole de webdesign',
                  style: AppTextStyle.primaryTextStyle(fontSize: 16.sp),
                ),
              ),
              SizedBox(height: 15.h),

              personalDetailsMethod(
                title: 'The height level you attained',
                subWidget: _buildChip('Post graduation'),
              ),
              SizedBox(height: 15.h),

              personalDetailsMethod(
                title: 'What is your religious beliefs?',
                subWidget: _buildChip('Muslim'), // Corrected to a Chip
              ),
              SizedBox(height: 15.h),

              personalDetailsMethod(
                title: 'Do you drink?',
                subWidget: _buildChip('No'), // Corrected to a Chip
              ),
              SizedBox(height: 15.h),

              personalDetailsMethod(
                title: 'Do you smoke?', // Added this missing section
                subWidget: _buildChip('No'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Reusable method for each list item container ---

  Widget personalDetailsMethod({
    required String title,
    required Widget subWidget,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldBgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.primaryTextStyle(
                      fontSize: 18.sp,
                      color: AppColors.primaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  subWidget,
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper method to create styled chips ---

  Widget _buildChip(String label) {
    return Chip(
      label: Text(label),
      labelStyle: AppTextStyle.primaryTextStyle(
        color: AppColors.primaryTextColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: AppColors.chipBgColor,
      shape: const StadiumBorder(),
      side: BorderSide.none,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
