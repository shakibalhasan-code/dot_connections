import 'package:dot_connections/app/controllers/profile_contorller.dart';
import 'package:dot_connections/app/core/utils/app_colors.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:dot_connections/app/views/widgets/common_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class UpdateFullNameView extends StatelessWidget {
  const UpdateFullNameView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileContorller>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Edit Name',
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'This will be visible to other users',
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 100.h),
                Text(
                  'First Name',
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5.h),

                CommonTextFeild(
                  hint: 'first name',
                  isPassword: false,
                  type: TextInputType.text,
                  controller: controller.editFirstNameController,
                ),
                SizedBox(height: 15.h),
                Text(
                  'Last Name',
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5.h),

                CommonTextFeild(
                  hint: 'last name',
                  isPassword: false,
                  type: TextInputType.text,
                  controller: controller.editFirstNameController,
                ),
                SizedBox(height: 20.h),

                ElevatedButton(
                  onPressed: () {
                    Get.back();
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
