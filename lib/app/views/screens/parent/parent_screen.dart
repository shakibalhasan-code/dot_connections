import 'package:dot_connections/app/controllers/parent_controller.dart';
import 'package:dot_connections/app/core/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ParentScreen extends StatelessWidget {
  const ParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParentController>(
      builder: (controller) {
        return Scaffold(
          body: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            children: controller.pages,
          ),
          bottomNavigationBar: CustomBottomNavBar(
              currentIndex: controller.currentIndex.value,
              onTap: controller.onTabTapped,
            ),
        );
      },
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      // The background color of the nav bar in the image is a light grey/off-white
      color: const Color(0xFFF8F8F8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(AppIcons.findIcon, "Find", 0),
          _buildNavItem(AppIcons.mapIcon, "Map", 1),
          _buildNavItem(AppIcons.chatIcon, "Chat", 2),
          _buildNavItem(AppIcons.matchIcon, "Match", 3),
          _buildNavItem(AppIcons.profileIcon, "Profile", 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(String icon, String label, int index) {
    final bool isSelected = currentIndex == index;

    if (isSelected) {
      // Style for the selected item
      return GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          width: 70.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 0.75,
                blurRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                width: 24.w,
                height: 24.h,
                colorFilter: ColorFilter.mode(
                  Colors.grey.shade800,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Style for unselected items
      return GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.translucent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 24.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(
                Colors.grey.shade600,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    }
  }
}
