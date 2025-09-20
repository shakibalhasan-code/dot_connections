import 'dart:io';
import 'package:dot_connections/app/core/utils/app_colors.dart';
import 'package:dot_connections/app/models/conversation_model.dart';
import 'package:dot_connections/app/views/screens/parent/chat/widgets/audio_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final alignment = isMe ? MainAxisAlignment.end : MainAxisAlignment.start;
    final color = isMe ? AppColors.primaryColor : const Color(0xFFF3E5F5);
    final textColor = isMe ? Colors.white : Colors.black;
    final borderRadius = isMe
        ? BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
            bottomLeft: Radius.circular(20.r),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
            bottomRight: Radius.circular(20.r),
          );

    return Row(
      mainAxisAlignment: alignment,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isMe)
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: CircleAvatar(
              radius: 14.r,
              backgroundImage: AssetImage(message.userAvatar),
            ),
          ),
        Container(
          constraints: BoxConstraints(maxWidth: 0.7.sw),
          padding: EdgeInsets.symmetric(
            vertical: message.type == MessageType.image ? 4.h : 12.h,
            horizontal: message.type == MessageType.image ? 4.w : 16.w,
          ),
          margin: EdgeInsets.symmetric(vertical: 4.h),
          decoration: BoxDecoration(color: color, borderRadius: borderRadius),
          child: _buildMessageContent(message, textColor, isMe),
        ),
        if (isMe)
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: CircleAvatar(
              radius: 14.r,
              backgroundImage: AssetImage(message.userAvatar),
            ),
          ),
      ],
    );
  }

  Widget _buildMessageContent(Message message, Color textColor, bool isMe) {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.text!,
          style: TextStyle(color: textColor, fontSize: 16.sp),
        );
      case MessageType.audio:
        return AudioPlayerWidget(
          audioAsset: 'assets/audio/audio_test.mp3',
          isMe: isMe,
        );
      case MessageType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: message.imageFile != null
              ? Image.file(
                  File(message.imageFile!.path),
                  width: 200.w,
                  height: 200.h,
                  fit: BoxFit.cover,
                )
              : message.imageUrl != null
              ? Image.network(
                  message.imageUrl!,
                  width: 200.w,
                  height: 200.h,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 200.w,
                      height: 200.h,
                      color: Colors.grey[300],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 200.w,
                      height: 200.h,
                      color: Colors.grey[300],
                      child: Icon(Icons.error),
                    );
                  },
                )
              : Container(
                  width: 200.w,
                  height: 200.h,
                  color: Colors.grey[300],
                  child: Icon(Icons.image),
                ),
        );
    }
  }
}
