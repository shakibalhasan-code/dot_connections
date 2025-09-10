import 'package:dot_connections/app/controllers/app_initial_controller.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SmokingStatusView extends StatelessWidget {
  const SmokingStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppInitialController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Do you smoke?",
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: 20.h),
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: controller.smokeOptions.map((smoke) {
                    return Obx(() {
                      final isSelected =
                          controller.selectedSmoke.value == smoke;
                      return GestureDetector(
                        onTap: () => controller.setSmoke(smoke),
                        child: Chip(
                          label: Text(smoke),
                          backgroundColor:
                              isSelected ? Colors.purple : Colors.grey[200],
                          labelStyle: AppTextStyle.primaryTextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    });
                  }).toList(),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Show on profile',
                      style: AppTextStyle.primaryTextStyle(),
                    ),
                    Obx(
                      () => Switch(
                        value: controller.showSmokeOnProfile.value,
                        onChanged: controller.toggleShowSmoke,
                        activeColor: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.addBio);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: AppTextStyle.primaryTextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
