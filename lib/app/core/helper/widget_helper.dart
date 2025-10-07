import '../utils/app_colors.dart';
import '../utils/app_constant.dart';
import '../utils/text_style.dart';
import '../../views/widgets/common_buttonl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';

enum Status { success, failed, warning }

class WidgetHelper {
  static void showAlertDialog({
    required Status dialogStatus,
    required String subTitle,
    required VoidCallback onTap,
    required String buttonText,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min, // keep dialog compact
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Row(
                children: [
                  Text(
                    dialogStatus == Status.warning
                        ? 'Warning'
                        : dialogStatus == Status.failed
                        ? 'Failed'
                        : 'Success',
                    style: AppTextStyle.primaryTextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 28.w,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(5.dm),
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedCancel01,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Subtitle
              Text(
                subTitle,
                textAlign: TextAlign.center,
                style: AppTextStyle.primaryTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 20.h),

              // Animation
              LottieBuilder.asset(
                repeat: false,
                dialogStatus == Status.success
                    ? AppConstant.success
                    : dialogStatus == Status.failed
                    ? AppConstant.failed
                    : AppConstant.warning,
                height: 100.h,
              ),

              SizedBox(height: 16.h),

              // Action Button
              CommonRoundedButton(title: buttonText, onPressed: onTap),
            ],
          ),
        ),
      ),
    );
  }

  static void showToast({
    required String message,
    required Status status,
    required BuildContext toastContext,
  }) {
    ScaffoldMessenger.of(toastContext).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(message),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        backgroundColor: status == Status.success
            ? Colors.green
            : status == Status.warning
            ? CupertinoColors.systemYellow
            : Colors.red,
      ),
    );
  }
}
