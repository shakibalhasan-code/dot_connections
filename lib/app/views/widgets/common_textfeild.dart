import 'package:dot_connections/app/core/utils/app_colors.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonTextFeild extends StatelessWidget {
  final String hint;
  final bool isPassword;
  final TextInputType type;
  final TextEditingController controller;
  const CommonTextFeild({
    super.key,
    required this.hint,
    required this.isPassword,
    required this.type,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.feildBgColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hint: Text(
              hint,
              style: AppTextStyle.primaryTextStyle(
                fontSize: 16.sp,
                color: AppColors.textColor.withOpacity(0.5),
              ),
            ),
          ),
          keyboardType: type,
        ),
      ),
    );
  }
}
