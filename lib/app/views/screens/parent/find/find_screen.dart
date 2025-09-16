import 'package:cached_network_image/cached_network_image.dart';
import 'package:dot_connections/app/controllers/find_controller.dart';
import 'package:dot_connections/app/core/utils/app_colors.dart';
import 'package:dot_connections/app/core/utils/app_icons.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:hugeicons/hugeicons.dart';

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
                      SizedBox(
                        height: Get.height,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CardSwiper(
                                cardsCount: controller.cardList.length,
                                allowedSwipeDirection:
                                    AllowedSwipeDirection.only(
                                      left: true,
                                      right: true,
                                    ),
                                cardBuilder: (context, index, x, y) {
                                  return Container(
                                    height: Get.height,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24.r),
                                    ),
                                    child: SizedBox(
                                      height: Get.height,
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadiusGeometry.circular(
                                                    24.r,
                                                  ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),

                                          Positioned(
                                            bottom: 0.h,
                                            right: 0.w,
                                            left: 0.w,
                                            child: SizedBox(
                                              height: 250.h,

                                              child: Stack(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.black,
                                                          Colors.black
                                                              .withOpacity(0.0),
                                                        ],
                                                        begin: Alignment
                                                            .bottomCenter,
                                                        end:
                                                            Alignment.topCenter,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20.r,
                                                          ),
                                                    ),
                                                  ),

                                                  Positioned(
                                                    left: 10.w,
                                                    right: 10.w,
                                                    bottom: 50.h,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Sara Rehman',
                                                              style: AppTextStyle.primaryTextStyle(
                                                                fontSize: 28.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            Icon(
                                                              Icons.female,
                                                              color:
                                                                  Colors.white,
                                                              size: 22.h,
                                                            ),
                                                            Text(
                                                              '25',
                                                              style: AppTextStyle.primaryTextStyle(
                                                                fontSize: 22.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 16.w,
                                                            ),
                                                            Icon(
                                                              Icons.verified,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10.h),

                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .location_on_rounded,
                                                              color:
                                                                  Colors.white,
                                                              size: 18.h,
                                                            ),
                                                            SizedBox(
                                                              width: 8.w,
                                                            ),
                                                            Text(
                                                              '0.5 mi. away from you',
                                                              style: AppTextStyle.primaryTextStyle(
                                                                fontSize: 18.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 15.h),
                                                        Wrap(
                                                          spacing: 5.w,
                                                          runSpacing: 5.h,
                                                          children: [
                                                            _buildInterestChip(
                                                              'Online Shopping',
                                                            ),
                                                            _buildInterestChip(
                                                              'Anime',
                                                            ),
                                                            _buildInterestChip(
                                                              'Horror flims',
                                                            ),
                                                            _buildInterestChip(
                                                              'Skincare',
                                                            ),
                                                            _buildInterestChip(
                                                              'Amateur cook',
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
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
                            _buildActionButton(
                              AppIcons.crossIcon,
                              Colors.black,
                              () {},
                            ),
                            _buildActionButton(
                              AppIcons.mapIcon,
                              Colors.blue,
                              () {},
                            ),
                            _buildActionButton(
                              AppIcons.loveIcon,
                              Colors.red,
                              () {},
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
            onTap: ()=> Get.toNamed(AppRoutes.subscription),
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
                  'Upgrade',
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
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColors.iconShapeColor,
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
        ],
      ),
    );
  }

  /// interest list item
  Widget _buildInterestChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }

  /// action button widget
  Widget _buildActionButton(String icon, Color color, VoidCallback onTap) {
    return GestureDetector(
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
    );
  }
}
