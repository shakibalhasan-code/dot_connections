import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:dot_connections/app/data/models/nearby_user_model.dart';
import 'package:dot_connections/app/views/widgets/photo_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MapUserDetailsSheet extends StatelessWidget {
  final NearbyUser user;

  const MapUserDetailsSheet({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get all photos (combine profile picture and photos array)
    List<String> allPhotos = [];
    if (user.profilePicture != null && user.profilePicture!.isNotEmpty) {
      allPhotos.add(user.profilePicture!);
    }
    allPhotos.addAll(user.photos);

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 12.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Photo slider section
              if (allPhotos.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: PhotoSlider(
                    photos: allPhotos,
                    height: 300,
                    borderRadius: 16,
                  ),
                ),
              SizedBox(height: 16.h),

              // Profile info section - make it scrollable
              Flexible(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name, age and gender row
                        Row(
                          children: [
                            Text(
                              user.name,
                              style: AppTextStyle.primaryTextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(
                              user.gender.toLowerCase() == 'female'
                                  ? Icons.female
                                  : Icons.male,
                              color: user.gender.toLowerCase() == 'female'
                                  ? Colors.pink
                                  : Colors.blue,
                              size: 24.h,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              user.age.toString(),
                              style: AppTextStyle.primaryTextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),

                        // Location
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: Colors.grey.shade600,
                              size: 18.h,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${user.distanceKm.toStringAsFixed(1)} km away',
                              style: AppTextStyle.primaryTextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Bio if available
                        if (user.bio.isNotEmpty) ...[
                          Text(
                            'Bio',
                            style: AppTextStyle.primaryTextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            user.bio,
                            style: AppTextStyle.primaryTextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          SizedBox(height: 16.h),
                        ],

                        // Personal details
                        Text(
                          'Personal Details',
                          style: AppTextStyle.primaryTextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: [
                            if (user.workplace.isNotEmpty)
                              _buildDetailChip('Work: ${user.workplace}'),
                            if (user.school.isNotEmpty)
                              _buildDetailChip('School: ${user.school}'),
                            if (user.studyLevel.isNotEmpty)
                              _buildDetailChip('Education: ${user.studyLevel}'),
                            if (user.religious.isNotEmpty)
                              _buildDetailChip('Religion: ${user.religious}'),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Interests if available
                        if (user.interests.isNotEmpty) ...[
                          Text(
                            'Interests',
                            style: AppTextStyle.primaryTextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: user.interests
                                .map((interest) => _buildInterestChip(interest))
                                .toList(),
                          ),
                          SizedBox(height: 16.h),
                        ],

                        // Chat button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back(); // Close bottom sheet
                              Get.toNamed(
                                AppRoutes.conversation,
                                arguments: {'userId': user.userId},
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              'Start Chat',
                              style: AppTextStyle.primaryTextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h), // Bottom padding
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        text,
        style: AppTextStyle.primaryTextStyle(
          fontSize: 14.sp,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildInterestChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        text,
        style: AppTextStyle.primaryTextStyle(
          fontSize: 14.sp,
          color: Colors.purple,
        ),
      ),
    );
  }
}
