import 'package:cached_network_image/cached_network_image.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:dot_connections/app/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserProfileWidget extends StatelessWidget {
  final UserModel userProfile;

  const UserProfileWidget({Key? key, required this.userProfile})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.r)),
      child: Stack(
        children: [
          // Profile Image
          _buildProfileImage(),

          // Gradient overlay at top
          _buildTopGradient(),

          // Profile Data at bottom
          _buildProfileData(),
        ],
      ),
    );
  }

  /// Profile image view
  Widget _buildProfileImage() {
    // Determine the image URL
    String? imageUrl;

    // First try to use profile photo URL
    if (userProfile.profilePhotoUrl != null &&
        userProfile.profilePhotoUrl!.isNotEmpty) {
      imageUrl = userProfile.profilePhotoUrl;
    }
    // Otherwise use the first photo from photoUrls if available
    else if (userProfile.photoUrls.isNotEmpty) {
      imageUrl = userProfile.photoUrls[0];
    }

    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl.startsWith('http')
                    ? imageUrl
                    : 'https://api.dotconnections.xyz$imageUrl', // Add base URL if needed
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, size: 80, color: Colors.grey[600]),
                      const SizedBox(height: 10),
                      Text(
                        'Image not available',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                color: Colors.grey[300],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      userProfile.gender.toLowerCase() == 'female'
                          ? Icons.female
                          : Icons.male,
                      size: 80,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userProfile.name,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  /// Gradient overlay at top
  Widget _buildTopGradient() {
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
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  /// Profile data view
  Widget _buildProfileData() {
    return Positioned(
      bottom: 0.h,
      right: 0.w,
      left: 0.w,
      child: Container(
        height: 250.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24.r),
            bottomRight: Radius.circular(24.r),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name, Age and Verification
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
                SizedBox(width: 8.w),
                Icon(
                  userProfile.gender.toLowerCase() == 'female'
                      ? Icons.female
                      : Icons.male,
                  color: Colors.white,
                  size: 22.h,
                ),
                SizedBox(width: 4.w),
                Text(
                  userProfile.age.toString(),
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12.w),
                if (userProfile.isVerified)
                  Icon(Icons.verified, color: Colors.blue),
              ],
            ),
            SizedBox(height: 8.h),

            // Location
            if (userProfile.displayLocation.isNotEmpty)
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: Colors.white,
                    size: 18.h,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    userProfile.displayLocation,
                    style: AppTextStyle.primaryTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            SizedBox(height: 8.h),

            // Interests tags
            if (userProfile.interests.isNotEmpty)
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: userProfile.interests
                    .take(5) // Limit to 5 interests
                    .map((interest) => _buildInterestChip(interest))
                    .toList(),
              ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  /// Interest list item
  Widget _buildInterestChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 12.sp),
      ),
    );
  }
}
