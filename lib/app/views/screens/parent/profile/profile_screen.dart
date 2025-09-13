import 'package:dot_connections/app/core/utils/app_colors.dart';
import 'package:dot_connections/app/core/utils/app_images.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dot_connections/app/core/utils/app_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const SizedBox(),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Your Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 120.r,
              width: 120.r,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.5),
                        width: 4,
                      ),
                    ),
                    child:  CircleAvatar(
                      backgroundImage: AssetImage(AppImages.annetteBlack),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: -10,
                    child: Container(
                      height: 40.r,
                      width: 40.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryColor,
                        border: Border.all(width: 2, color: Colors.white),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppIcons.penIcon,
                          height: 20.r,
                          width: 20.r,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "Brooklyn Simmons",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "brooklyn.sim@example.com",
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 40.h),
            ProfileMenu(
              icon: AppIcons.accountsIcon,
              text: "Account",
              press: () => Get.toNamed(AppRoutes.accountDetails),
            ),
            ProfileMenu(
              icon: AppIcons.personalData,
              text: "Personal Details",
              press: () => Get.toNamed(AppRoutes.personalDetails),
            ),
            ProfileMenu(
              icon: AppIcons.photoGallery,
              text: "Photo Gallery",
              press: () => Get.toNamed(AppRoutes.photoGallery),
            ),
            ProfileMenu(
              icon: AppIcons.blockedIcon,
              text: "Blocked Users",
              press: () {},
            ),
            ProfileMenu(
              icon: AppIcons.subscriptionIcon,
              text: "Subscription",
              press: () {},
            ),
            ProfileMenu(
              icon: AppIcons.termsConditionIcon,
              text: "Trams & Condition",
              press: () {},
            ),
            ProfileMenu(
              icon: AppIcons.infoIcon,
              text: "About Us",
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
    required this.text,
    required this.icon,
    this.press,
  });

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        
        
        
      ),
      onPressed: press,
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            colorFilter:  ColorFilter.mode(
              AppColors.primaryTransparent,
              BlendMode.srcIn,
            ),
            width: 22.w,
          ),
          SizedBox(width: 20.w),
          Expanded(child: Text(text,style: AppTextStyle.primaryTextStyle(color: AppColors.textColor))),
          const Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}