import '../../../controllers/parent_controller.dart';
import '../../../controllers/language_controller.dart';
import '../../../core/utils/app_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide Trans;

/// ParentScreen is the main navigation container for the app
///
/// This screen provides:
/// - Bottom navigation with 5 main sections
/// - Smooth page transitions between sections
/// - Modern, animated navigation bar
/// - Theme-aware styling
///
/// The screen uses PageView for smooth transitions and maintains
/// state across navigation changes.
class ParentScreen extends StatelessWidget {
  const ParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParentController>(
      builder: (controller) {
        return Scaffold(
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            children: controller.pages,
          ),
          bottomNavigationBar: const CustomBottomNavBar(),
        );
      },
    );
  }
}

/// CustomBottomNavBar provides a simple iOS-style navigation experience
///
/// Features:
/// - Clean iOS-style design without shapes
/// - Simple active/inactive color states
/// - Smooth color transitions
/// - No overflow issues
class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parentController = Get.find<ParentController>();
    final LanguageController languageController =
        Get.find<LanguageController>();

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Obx(() {
          // Force rebuild when language changes
          languageController.currentLanguage;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                AppIcons.findIcon,
                'find_people'.tr(),
                0,
                parentController.currentIndex.value,
                parentController.onTabTapped,
              ),
              _buildNavItem(
                context,
                AppIcons.mapIcon,
                'map'.tr(),
                1,
                parentController.currentIndex.value,
                parentController.onTabTapped,
              ),
              _buildNavItem(
                context,
                AppIcons.chatIcon,
                'chat'.tr(),
                2,
                parentController.currentIndex.value,
                parentController.onTabTapped,
              ),
              _buildNavItem(
                context,
                AppIcons.matchIcon,
                'matches'.tr(),
                3,
                parentController.currentIndex.value,
                parentController.onTabTapped,
              ),
              _buildNavItem(
                context,
                AppIcons.profileIcon,
                'profile'.tr(),
                4,
                parentController.currentIndex.value,
                parentController.onTabTapped,
              ),
            ],
          );
        }),
      ),
    );
  }

  /// Builds individual navigation item with simple iOS-style design
  Widget _buildNavItem(
    BuildContext context,
    String icon,
    String label,
    int index,
    int currentIndex,
    Function(int) onTap,
  ) {
    final theme = Theme.of(context);
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.translucent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            SvgPicture.asset(
              icon,
              width: 22.w,
              height: 22.h,
              colorFilter: ColorFilter.mode(
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.6),
                BlendMode.srcIn,
              ),
            ),

            SizedBox(height: 2.h),

            // Label
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.6),
                fontWeight: FontWeight.w500,
                fontSize: 9.sp,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
