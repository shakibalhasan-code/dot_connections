import 'package:finder/app/core/utils/app_colors.dart' show AppColors;
import 'package:finder/app/core/utils/app_images.dart';
import 'package:finder/app/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../../core/helper/widget_helper.dart';
import '../../../../../../core/utils/app_icons.dart';

class BlockedUserScreen extends StatelessWidget {
  const BlockedUserScreen({super.key});

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
              'Blocked Users',
              style: AppTextStyle.primaryTextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Manage the users you’ve blocked. They won’t be able to see your profile.',
              style: AppTextStyle.primaryTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.builder(
                itemCount: 5,

                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsetsGeometry.only(top: 5.h),
                    child: Container(
                      height: 80.h,
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: AppColors.feildBgColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(50.r),
                              child: Image.asset(
                                AppImages.annetteBlack,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Shahriar Sakib',
                                    style: AppTextStyle.primaryTextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryTextColor,
                                    ),
                                  ),
                                  Text(
                                    'Thanks',
                                    style: AppTextStyle.primaryTextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.primaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            InkWell(
                              onTap: () {
                                WidgetHelper.showAlertDialog(
                                  dialogStatus: Status.warning,
                                  subTitle:
                                      'Are you sure want to Unblock Shahriar Sakib ?',
                                  onTap: () => Get.back(),
                                  buttonText: 'Unblock',
                                );
                              },
                              child: Container(
                                width: 48.w,
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color: AppColors.iconShapeColor,
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: SvgPicture.asset(AppIcons.blockedIcon),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
