import 'package:dot_connections/app/controllers/conversation_controller.dart';
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
            color: Colors.white70,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon:  HugeIcon(icon: HugeIcons.strokeRoundedImageAdd01, color: Colors.grey),
                  onPressed: () {
                    controller.pickImage();
                  },
                ),
                // IconButton(
                //   icon: const Icon(Icons.emoji_emotions_outlined),
                //   onPressed: () {},
                // ),
                IconButton(
                    icon:  HugeIcon(icon: HugeIcons.strokeRoundedMic01, color: Colors.grey),
                  onPressed: () {},
                ),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Start your conversation here...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                    icon:  HugeIcon(icon: HugeIcons.strokeRoundedSent, color: Colors.grey),
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
