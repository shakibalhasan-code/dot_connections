import 'package:dot_connections/app/controllers/conversation_controller.dart';
import 'package:dot_connections/app/core/utils/app_colors.dart';
import 'package:dot_connections/app/views/screens/parent/chat/widgets/audio_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
                IconButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedImageAdd01,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    controller.pickImage();
                  },
                ),
                // IconButton(
                //   icon: const Icon(Icons.emoji_emotions_outlined),
                //   onPressed: () {},
                // ),
                IconButton(
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
                Expanded(
                  child:
                      // //  controller.audioPath != null && controller.audioPath != ''
                      //     ? AudioPlayerWidget(
                      //         audioAsset: controller.audioPath!,
                      //         isMe: true,
                      //       )
                      //     :
                      controller.isRecording
                      ? Text("Recording...")
                      : TextField(
                          controller: controller.messageFeildController,
                          decoration: InputDecoration(
                            hintText: "Type a message",
                            border: InputBorder.none,
                          ),
                        ),
                ),
                IconButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedSent,
                    color: Colors.grey,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
