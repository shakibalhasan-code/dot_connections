import 'package:dot_connections/app/controllers/app_initial_controller.dart';
import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/utils/app_images.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:dot_connections/app/data/models/user_personal_data.dart';
import 'package:dot_connections/app/views/screens/initial/interests_view.dart';
import 'package:dot_connections/app/views/screens/initial/workplace_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WhereLiveView extends StatelessWidget {
  const WhereLiveView({super.key});

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
                  "Where do you live?",
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "By sharing your location, get match near you",
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: Image.asset(
                    AppImages.mapDemo,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                SizedBox(height: 20.h),
                TextField(
                  controller: controller.locationController,
                  decoration: InputDecoration(
                    hintText: 'New York, USA',
                    hintStyle: AppTextStyle.primaryTextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {
                    final authController = Get.find<AuthController>();
                    final locationData = Location(
                      type: 'Point',
                      coordinates: [],
                      address: 'Mohakhali, Dhaka, Bangladesh',
                    );
                    debugPrint('>>>>>>>>>>>>>>>>>Location Data: $locationData');

                    Get.to(() => WorkplaceView());
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
