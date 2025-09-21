import 'package:dot_connections/app/controllers/find_controller.dart';
import 'package:dot_connections/app/controllers/parent_controller.dart';
import 'package:dot_connections/app/core/utils/app_colors.dart';
import 'package:dot_connections/app/core/utils/app_icons.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:dot_connections/app/views/screens/parent/find/widgets/user_profile_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class FindScreen extends StatelessWidget {
  const FindScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FindController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _headerWidget(),
                // SizedBox(height: 10.h),
                Expanded(
                  child: Stack(
                    children: [
                      ///>>>>>>>>> profile container<<<<<<<<<<<<<<<
                      Positioned.fill(
                        child: CardSwiper(
                          backCardOffset: Offset(0, 10),
                          controller: controller.cardSwipeController,
                          padding: EdgeInsetsGeometry.symmetric(
                            horizontal: 5.w,
                            vertical: 16.h,
                          ),
                          initialIndex: controller.activeProfile.value,
                          onSwipe: (previousIndex, currentIndex, direction) {
                            if (currentIndex != null) {
                              controller.cardSwipe(
                                currentIndex: currentIndex,
                                previousIndex: previousIndex,
                                direction: direction,
                              );
                            }
                            return true;
                          },
                          cardsCount: controller.cardList.length,
                          allowedSwipeDirection: AllowedSwipeDirection.only(
                            left: true,
                            right: true,
                          ),
                          cardBuilder: (context, index, x, y) {
                            return UserProfileWidget(
                              userProfile: controller.cardList[index],
                            );
                          },
                        ),
                      ),

                      ///>>>>>>>> BOTTOM ACTIONS<<<<<<<<
                      Positioned(
                        left: 15.w,
                        right: 15.h,
                        bottom: 0.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ///ignore action button
                            _buildAccessibleActionButton(
                              AppIcons.crossIcon,
                              Colors.black,
                              () => controller.swipeByActions(
                                CardSwiperDirection.left,
                              ),
                              'pass_button'.tr(),
                              'pass_button_hint'.tr(),
                            ),
                            _buildAccessibleActionButton(
                              AppIcons.mapIcon,
                              Colors.blue,
                              () {
                                // Navigate to map tab to show user locations
                                final ParentController parentController =
                                    Get.find();
                                parentController.onTabTapped(
                                  1,
                                ); // Map screen is at index 1
                              },
                              'show_on_map'.tr(),
                              'show_on_map_hint'.tr(),
                            ),
                            _buildAccessibleActionButton(
                              AppIcons.loveIcon,
                              Colors.red,
                              () => controller.swipeByActions(
                                CardSwiperDirection.right,
                              ),
                              'like_button'.tr(),
                              'like_button_hint'.tr(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  ///header widget
  Widget _headerWidget() {
    return Padding(
      padding: EdgeInsets.only(right: 20.w, left: 20.h, top: 10.h),
      child: Row(
        children: [
          SvgPicture.asset(AppIcons.appIcons, height: 44.h, width: 44.w),
          const Spacer(),
          InkWell(
            onTap: () => Get.toNamed(AppRoutes.subscription),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
                child: Text(
                  'upgrade'.tr(),
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          InkWell(
            onTap: () => Get.toNamed(AppRoutes.notification),
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(width: 0.75, color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  AppIcons.notification,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Accessible action button widget with enhanced semantics
  Widget _buildAccessibleActionButton(
    String icon,
    Color color,
    VoidCallback onTap,
    String semanticLabel,
    String semanticHint,
  ) {
    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 1,
                blurStyle: BlurStyle.normal,
                color: Colors.grey,
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              icon,
              width: 43.56.w,
              height: 43.56.h,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
