import 'package:finder/app/controllers/app_initial_controller.dart';
import 'package:finder/app/core/utils/app_routes.dart';
import 'package:finder/app/core/utils/text_style.dart' show AppTextStyle;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpView extends StatelessWidget {
  const OtpView({super.key});

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
                  "6-digit code",
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Please enter the code we've sent to +1 83794988",
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 40.h),
                Pinput(
                  length: 6,
                  controller: controller.otpController,
                  autofocus: true,
                  onChanged: (value) {
                    controller.otp.value = value;
                    controller.update();
                  },
                ),
                SizedBox(height: 20.h),
                Text(
                  "Resend code in 10:30",
                  style: AppTextStyle.primaryTextStyle(color: Colors.grey),
                ),
                const Spacer(),
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.isOtpButtonEnabled
                        ? () {
                            Get.toNamed(AppRoutes.name);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.isOtpButtonEnabled
                          ? Colors.purple
                          : Colors.grey,
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
