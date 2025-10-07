import 'package:cached_network_image/cached_network_image.dart';
import 'package:finder/app/controllers/profile_contorller.dart';
import 'package:finder/app/core/utils/app_colors.dart';
import 'package:finder/app/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:reorderable_grid/reorderable_grid.dart';

class ReorderingImageWidget extends StatelessWidget {
  const ReorderingImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileContorller>(
      builder: (controller) {
        ///get the images and show in wrap widget
        return Obx(() {
          return ReorderableGridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              ...controller.photoGllery.asMap().entries.map((entry) {
                int index = entry.key;
                String item = entry.value;
                debugPrint(
                  'index of curent item\s $index and index of the galleryImages is ${controller.photoGllery.length}',
                );
                return SizedBox(
                  key: ValueKey(index),
                  width: 110.w,
                  height: 121.h,

                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            errorListener: (value) {
                              print(
                                '========>>>>>> ERRORR>>>>>>>>>>>>> $value',
                              );
                            },
                            imageUrl: item,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 5.w,
                        top: 5.h,
                        child: InkWell(
                          onTap: () => controller.deletePhoto(index),
                          child: Container(
                            width: 28.w,
                            height: 28.h,
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(5.dm),
                              child: HugeIcon(
                                icon: HugeIcons.strokeRoundedCancel01,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              /// add image widget
              InkWell(
                key: ValueKey('add_image'),
                borderRadius: BorderRadius.circular(10.r),
                onTap: () => controller.pickImage(),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryTransParentCard,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedAdd01,
                        color: AppColors.textColor,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Add Image',
                        style: AppTextStyle.primaryTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            onReorder: (oldIndex, newIndex) {
              // Prevent dragging the "Add Image" widget
              if (oldIndex >= controller.photoGllery.length ||
                  newIndex >= controller.photoGllery.length) {
                return;
              }
              controller.updatePhoto(newIndex: newIndex, oldIndex: oldIndex);
            },
          );
        });
      },
    );
  }
}
