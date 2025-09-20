import 'package:dot_connections/app/core/utils/app_colors.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:dot_connections/app/views/widgets/common_buttonl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hugeicons/hugeicons.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'LifeTime Membership',
              style: AppTextStyle.primaryTextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
            Text(
              'Unlock premium features and connect with more people. Pick a plan that suits you.',
              style: AppTextStyle.primaryTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryTextColor,
              ),
            ),

            SizedBox(height: 30.h),

            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: AppColors.iconShapeColor,
                borderRadius: BorderRadius.circular(22.r),
                border: Border.all(
                  width: 1.w,
                  color: AppColors.primaryTransparent,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Life Time Member',
                      style: AppTextStyle.primaryTextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,

                          vertical: 10.h,
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$99',
                                  style: AppTextStyle.primaryTextStyle(
                                    fontSize: 40.sp,
                                    color: theme.colorScheme.onSurface,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),

                                Text(
                                  '/ One-Time Payment',
                                  style: AppTextStyle.primaryTextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                HugeIcon(
                                  icon: HugeIcons.strokeRoundedFire,
                                  color: theme.colorScheme.onSurface,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    'All Advanced Features Included',
                                    style: AppTextStyle.primaryTextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.primaryTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            CommonRoundedButton(title: 'Continue', onPressed: () {}),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
