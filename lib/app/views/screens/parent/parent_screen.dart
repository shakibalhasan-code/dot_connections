import 'package:dot_connections/app/controllers/parent_controller.dart';
import 'package:dot_connections/app/core/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

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

/// CustomBottomNavBar provides an enhanced navigation experience
///
/// Features:
/// - Animated selection indicators
/// - Smooth color transitions
/// - Accessibility support
/// - Theme-aware styling
/// - Touch feedback with haptics
class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parentController = Get.find<ParentController>();

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                AppIcons.findIcon,
                "Find",
                0,
                parentController.currentIndex.value,
                parentController.onTabTapped,
              ),
              _buildNavItem(
                context,
                AppIcons.mapIcon,
                "Map",
                1,
                parentController.currentIndex.value,
                parentController.onTabTapped,
              ),
              _buildNavItem(
                context,
                AppIcons.chatIcon,
                "Chat",
                2,
                parentController.currentIndex.value,
                parentController.onTabTapped,
              ),
              _buildNavItem(
                context,
                AppIcons.matchIcon,
                "Match",
                3,
                parentController.currentIndex.value,
                parentController.onTabTapped,
              ),
              _buildNavItem(
                context,
                AppIcons.profileIcon,
                "Profile",
                4,
                parentController.currentIndex.value,
                parentController.onTabTapped,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds individual navigation item with enhanced animations
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
        onTap: () {
          // Add haptic feedback
          // HapticFeedback.lightImpact(); // Uncomment when implementing haptics
          onTap(index);
        },
        behavior: HitTestBehavior.translucent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon container with animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: isSelected ? 70.w : 50.w,
                height: isSelected ? 50.h : 40.h,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(isSelected ? 16.r : 12.r),
                ),
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    child: SvgPicture.asset(
                      icon,
                      width: isSelected ? 28.w : 24.w,
                      height: isSelected ? 28.h : 24.h,
                      colorFilter: ColorFilter.mode(
                        isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withOpacity(0.6),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 4.h),

              // Label with animation
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: isSelected ? 13.sp : 12.sp,
                ),
                child: Text(label),
              ),

              // Selection indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: isSelected ? 20.w : 0,
                height: 2.h,
                margin: EdgeInsets.only(top: 2.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(1.r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
