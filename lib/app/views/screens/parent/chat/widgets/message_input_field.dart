import 'package:easy_localization/easy_localization.dart';
import 'package:finder/app/controllers/conversation_controller.dart'
    show ConversationController;
import 'package:finder/app/core/utils/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:hugeicons/hugeicons.dart';

class MessageInputField extends StatelessWidget {
  const MessageInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConversationController>(
      builder: (controller) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: controller.isRecording
                ? AppColors.primaryColor.withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                Semantics(
                  label: 'image_button'.tr(),
                  hint: 'Double tap to select and send an image',
                  button: true,
                  child: IconButton(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedImageAdd01,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      controller.pickImage();
                    },
                  ),
                ),
                Semantics(
                  label: controller.isRecording
                      ? 'recording'.tr()
                      : 'record_button'.tr(),
                  hint: controller.isRecording
                      ? 'recording_hint'.tr()
                      : 'Double tap to start recording voice message',
                  button: true,
                  child: IconButton(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedMic01,
                      color: controller.isRecording ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      if (controller.isRecording) {
                        controller.toggleRecording();
                      } else {
                        controller.toggleRecording();
                      }
                    },
                  ),
                ),
                Expanded(
                  child:
                      controller.audioPath != null &&
                          controller.audioPath!.isNotEmpty
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.audiotrack,
                                color: AppColors.primaryColor,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  'Audio recorded - tap send',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 20.sp,
                                ),
                                onPressed: () => controller.clearAudio(),
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(
                                  minWidth: 24.w,
                                  minHeight: 24.h,
                                ),
                              ),
                            ],
                          ),
                        )
                      : controller.isRecording
                      ? Row(
                          children: [
                            Icon(
                              Icons.fiber_manual_record,
                              color: Colors.red,
                              size: 16.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Recording...",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      : Semantics(
                          label: 'type_message'.tr(),
                          hint: 'Text field for typing messages',
                          textField: true,
                          child: TextField(
                            controller: controller.messageFeildController,
                            decoration: InputDecoration(
                              hintText: 'type_message'.tr(),
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                            style: TextStyle(fontSize: 14.sp),
                            onChanged: (value) => controller.update(),
                          ),
                        ),
                ),
                Semantics(
                  label:
                      controller.messageFeildController.text
                              .trim()
                              .isNotEmpty ||
                          (controller.audioPath != null &&
                              controller.audioPath!.isNotEmpty)
                      ? 'send_button'.tr()
                      : 'Send button disabled',
                  hint:
                      controller.audioPath != null &&
                          controller.audioPath!.isNotEmpty
                      ? 'Double tap to send audio message'
                      : controller.messageFeildController.text.trim().isNotEmpty
                      ? 'Double tap to send text message'
                      : 'Type a message or record audio to enable sending',
                  button: true,
                  enabled:
                      controller.messageFeildController.text
                          .trim()
                          .isNotEmpty ||
                      (controller.audioPath != null &&
                          controller.audioPath!.isNotEmpty),
                  child: IconButton(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedSent,
                      color:
                          controller.messageFeildController.text
                                  .trim()
                                  .isNotEmpty ||
                              (controller.audioPath != null &&
                                  controller.audioPath!.isNotEmpty)
                          ? AppColors.primaryColor
                          : Colors.grey,
                    ),
                    onPressed: () {
                      if (controller.audioPath != null &&
                          controller.audioPath!.isNotEmpty) {
                        // Send audio message
                        controller.sendAudioMessage(controller.audioPath!);
                      } else if (controller.messageFeildController.text
                          .trim()
                          .isNotEmpty) {
                        // Send text message
                        controller.sendTextMessage(
                          controller.messageFeildController.text,
                        );
                        controller.messageFeildController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
