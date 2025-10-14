import 'package:dot_connections/app/controllers/app_initial_controller.dart';
import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:dot_connections/app/views/screens/initial/where_live_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PreferencesView extends StatelessWidget {
  const PreferencesView({super.key});

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
                  "Preferences",
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "What do you love?",
                  style: AppTextStyle.primaryTextStyle(fontSize: 16),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Looking For',
                  style: AppTextStyle.primaryTextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.lookingFor.value,
                    items: controller.lookingForOptions
                        .map(
                          (label) => DropdownMenuItem(
                            child: Text(label),
                            value: label,
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.setLookingFor(value);
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Age Range',
                  style: AppTextStyle.primaryTextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.minAgeController,
                        decoration: InputDecoration(
                          hintText: 'Ex: 22',
                          labelText: 'Min',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: TextField(
                        controller: controller.maxAgeController,
                        decoration: InputDecoration(
                          hintText: 'Ex: 35',
                          labelText: 'Max',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Obx(
                  () => Text(
                    'Maximum Distance: ${controller.maxDistance.value.toInt()} miles',
                    style: AppTextStyle.primaryTextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Obx(
                  () => Slider(
                    value: controller.maxDistance.value,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: '${controller.maxDistance.value.toInt()} miles',
                    onChanged: controller.setMaxDistance,
                    activeColor: Colors.purple,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    // TODO: Navigate to the next screen
                    final authController = Get.find<AuthController>();

                    debugPrint(
                      "selected looking for: ${controller.lookingFor.value}",
                    );

                    // Convert to API format
                    int index = controller.lookingForOptions.indexOf(
                      controller.lookingFor.value,
                    );
                    String lookingForValue =
                        index >= 0 &&
                            index < controller.lookingForApiValues.length
                        ? controller.lookingForApiValues[index]
                        : "dating"; // Default value

                    authController.currentUserProfile.value.lookingFor =
                        lookingForValue;

                    debugPrint(
                      "selected looking for: ${authController.currentUserProfile.value.lookingFor}",
                    );

                    authController.currentUserProfile.value.ageRangeMin =
                        int.tryParse(controller.minAgeController.text) ?? 18;

                    authController.currentUserProfile.value.ageRangeMax =
                        int.tryParse(controller.maxAgeController.text) ?? 100;

                    authController.currentUserProfile.value.maxDistance =
                        int.tryParse(
                          controller.maxDistance.value.toInt().toString(),
                        ) ??
                        50;
                    authController.currentUserProfile.refresh();

                    // Navigate to the next screen
                    Get.to(() => const WhereLiveView());
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
