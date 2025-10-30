import 'package:dot_connections/app/core/utils/app_colors.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonRoundedButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double borderRadius;
  final double height;
  final double? width;
  final FontWeight fontWeight;

  const CommonRoundedButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.backgroundColor = AppColors.primaryColor,
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.borderRadius = 30,
    this.height = 48,
    this.width,
    this.fontWeight = FontWeight.w600,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: AppTextStyle.primaryTextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
