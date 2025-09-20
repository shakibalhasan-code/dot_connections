import 'package:cached_network_image/cached_network_image.dart';
import 'package:dot_connections/app/controllers/find_controller.dart';
import 'package:dot_connections/app/core/utils/app_colors.dart' show AppColors;
import 'package:dot_connections/app/core/utils/app_icons.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:dot_connections/app/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class UserProfileWidget extends StatelessWidget {
  final UserProfile userProfile;
  const UserProfileWidget({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FindController>(
      builder: (controller) {
        return SizedBox(
          height: Get.height,
          child: Container(
            height: Get.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: SizedBox(
              height: Get.height,
              child: Stack(
                children: [
                  _imageWidget(controller),

                  /// current index of container as like facebook story
                  _buildImageStoryProgress(context, controller),

                  _buildProfileData(),

                  ///leftside click event
                  // Positioned(
                  //   left: 0,
                  //   top: 0,
                  //   bottom: 50.h,
                  //   child: InkWell(
                  //     onTap: () {
                  //       controller.decreaseImageIndex();
                  //       debugPrint("Profile Clicked");
                  //     },
                  //     child: SizedBox(width: 50.w, height: Get.height),
                  //   ),
                  // ),

                  /// right side click event
                  // Positioned(
                  //   right: 0,
                  //   top: 0,
                  //   bottom: 50.h,
                  //   child: InkWell(
                  //     onTap: () {
                  //       controller.increaseImageIndex();
                  //       debugPrint("Profile Clicked");
                  //     },
                  //     child: SizedBox(width: 50.w, height: Get.height),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ///profile data view
  Positioned _buildProfileData() {
    return Positioned(
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
                  colors: [Colors.black, Colors.black.withOpacity(0.0)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),

            Positioned(
              left: 10.w,
              right: 10.w,
              bottom: 50.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        userProfile.name,
                        style: AppTextStyle.primaryTextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Icon(Icons.female, color: Colors.white, size: 22.h),
                      Text(
                        userProfile.age.toString(),
                        style: AppTextStyle.primaryTextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Icon(Icons.verified, color: Colors.blue),
                    ],
                  ),
                  SizedBox(height: 5.h),

                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: Colors.white,
                        size: 18.h,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        userProfile.distance,
                        style: AppTextStyle.primaryTextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Wrap(
                    spacing: 5.w,
                    runSpacing: 5.h,
                    children: userProfile.interested.map((item) {
                      return _buildInterestChip(item);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///image story progressview
  Positioned _buildImageStoryProgress(
    BuildContext context,
    FindController controller,
  ) {
    return Positioned(
      top: 0,
      right: 0,
      left: 0,
      child: Container(
        height: 100.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          gradient: LinearGradient(
            colors: [Colors.black, Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 10.w,
              right: 10.w,
              top: 10.h,
              child: SizedBox(
                height: 3.h,
                child: Row(
                  children: userProfile.images.asMap().entries.map((item) {
                    final index = item.key;
                    //final imageUrl = item.value;

                    return Flexible(
                      child: Padding(
                        padding: EdgeInsetsGeometry.only(left: 5.w),
                        child: Container(
                          height: 3.h,
                          width:
                              MediaQuery.of(context).size.width /
                              userProfile.images.length,
                          decoration: BoxDecoration(
                            color: controller.activeProfileImage.value == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///profile image view
  Positioned _imageWidget(FindController controller) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: PageView(
          controller: controller.pageviewProfileImage,
          onPageChanged: (value) => controller.onProfileImageChanged(value),
          children: userProfile.images.map((item) {
            return CachedNetworkImage(imageUrl: item, fit: BoxFit.cover);
          }).toList(),
        ),
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
}
