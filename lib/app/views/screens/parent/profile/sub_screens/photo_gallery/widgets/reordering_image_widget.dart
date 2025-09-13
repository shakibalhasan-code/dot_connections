import 'package:cached_network_image/cached_network_image.dart';
import 'package:dot_connections/app/controllers/profile_contorller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:reorderable_grid/reorderable_grid.dart';

class ReorderingImageWidget extends StatelessWidget {
  const ReorderingImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileContorller>(
      builder: (controller) {
        ///get the images and show in wrap widget
        return ReorderableGridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: controller.photoGllery.asMap().entries.map((entry) {
            int index = entry.key;
            String item = entry.value;
            return Container(
              key: ValueKey(index),
              width: 110.w,
              height: 121.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: CachedNetworkImage(
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                errorListener: (value) {
                  print('========>>>>>> ERRORR>>>>>>>>>>>>> $value');
                },
                imageUrl: item,
                fit: BoxFit.cover,
              ),
            );
          }).toList(),
          onReorder: (oldIndex, newIndex) =>
              controller.updatePhoto(newIndex: newIndex, oldIndex: oldIndex),
        );
      },
    );
  }
}
