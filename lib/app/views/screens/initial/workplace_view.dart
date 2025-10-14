import 'package:dot_connections/app/controllers/app_initial_controller.dart';
import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:dot_connections/app/views/screens/initial/job_title_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WorkplaceView extends StatelessWidget {
  const WorkplaceView({super.key});

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
                  "Where do you work?",
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: 20.h),
                TextField(
                  controller: controller.workplaceController,
                  decoration: InputDecoration(
                    hintText: 'Add a workplace',
                    hintStyle: AppTextStyle.primaryTextStyle(
                      color: Colors.grey,
                    ),
                  ),
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
                        value: controller.showWorkplaceOnProfile.value,
                        onChanged: controller.toggleShowWorkplace,
                        activeColor: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    final authController = Get.find<AuthController>();
                    final workplace = controller.workplaceController.text
                        .trim();
                    authController.currentUserProfile.value.workplace =
                        workplace;

                    authController
                            .currentUserProfile
                            .value
                            .hiddenFields
                            .workplace =
                        controller.showWorkplaceOnProfile.value;
                    authController.currentUserProfile.refresh();

                    debugPrint(
                      'Workplace: $workplace. && Show on profile: ${controller.showWorkplaceOnProfile.value}',
                    );
                    Get.to(() => JobTitleView());
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
