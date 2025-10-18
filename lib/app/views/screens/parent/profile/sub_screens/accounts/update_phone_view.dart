import 'package:dot_connections/app/controllers/profile_contorller.dart';
import 'package:dot_connections/app/core/utils/app_colors.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:dot_connections/app/views/widgets/common_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class UpdatePhoneView extends StatelessWidget {
  const UpdatePhoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileContorller>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(backgroundColor: Colors.white),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Phone Number',
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Add a valid number for verification and security.',
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 100.h),
                Text(
                  'Phone Number',
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5.h),

                CommonTextFeild(
                  hint: '+1234567890',
                  isPassword: false,
                  type: TextInputType.phone,
                  controller: controller.phoneController,
                ),

                SizedBox(height: 20.h),

                ElevatedButton(
                  onPressed: () async {
                    // Close any existing snackbars to avoid conflicts
                    if (Get.isSnackbarOpen) {
                      Get.closeCurrentSnackbar();
                    }

                    // Update the user's phone number
                    // Navigation is now handled in the controller
                    await controller.updatePhoneNumber();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Text(
                    'Update',
                    style: AppTextStyle.primaryTextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
