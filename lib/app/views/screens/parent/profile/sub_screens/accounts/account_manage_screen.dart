import 'package:finder/app/core/utils/app_routes.dart';
import 'package:finder/app/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/utils/app_icons.dart';

class AccountManageScreen extends StatelessWidget {
  const AccountManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Account',
              style: AppTextStyle.primaryTextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Manage your login and security preferences',
              style: AppTextStyle.primaryTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w200,
              ),
            ),
            SizedBox(height: 30.h),
            data_edit_item(
              title: 'Full Name',
              subtitle: 'Shakib Al Hasan',
              onTap: () => Get.toNamed(AppRoutes.editFullName),
              isEditable: true,
            ),
            SizedBox(height: 10.h),
            data_edit_item(
              title: 'Phone Number',
              subtitle: '+8801857895107',
              onTap: () => Get.toNamed(AppRoutes.updatePhoneView),
              isEditable: true,
            ),
            SizedBox(height: 10.h),
            data_edit_item(
              title: 'E-mail',
              subtitle: 'example.sah@gmail.com',
              onTap: () {},
              isEditable: false,
            ),
          ],
        ),
      ),
    );
  }

  Row data_edit_item({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isEditable,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyle.primaryTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: AppTextStyle.primaryTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        SizedBox(width: 10.w),
        isEditable
            ? Builder(
                builder: (context) {
                  final theme = Theme.of(context);
                  return IconButton(
                    onPressed: onTap,
                    icon: SvgPicture.asset(
                      AppIcons.penIcon,
                      color: theme.colorScheme.onSurface,
                    ),
                  );
                },
              )
            : const SizedBox(),
      ],
    );
  }
}
