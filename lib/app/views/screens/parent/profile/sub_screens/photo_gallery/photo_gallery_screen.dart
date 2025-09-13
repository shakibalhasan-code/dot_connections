import 'package:dot_connections/app/core/utils/app_colors.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:dot_connections/app/views/screens/parent/profile/sub_screens/photo_gallery/widgets/reordering_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhotoGalleryScreen extends StatelessWidget {
  const PhotoGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w,vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Photo Gallery', style: AppTextStyle.primaryTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700)),
            Text('Upload your best moments and let others get to know you better.', style: AppTextStyle.primaryTextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: AppColors.textColor),),
            SizedBox(height: 10.h),

            ///reorder_image of person gallery
            SizedBox(
              
              height: 600.h,
              child: ReorderingImageWidget())
          
          ],
        ),
      ),
    );
  }
}
