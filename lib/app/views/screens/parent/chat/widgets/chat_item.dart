import 'package:dot_connections/app/controllers/chat_controller.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/data/models/chat_model.dart';
import 'package:dot_connections/app/views/widgets/user_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatItem extends StatelessWidget {
  final Chat chat;

  const ChatItem({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // Mark chat as read
        final chatController = Get.find<ChatController>();
        chatController.markChatAsRead(chat.partnerId);

        // Navigate to conversation and pass partnerId
        Get.toNamed(
          AppRoutes.conversation,
          arguments: {
            'partnerId': chat.partnerId,
            'partnerName': chat.name,
            'partnerImage': chat.imageUrl,
          },
        );
      },
      leading: Stack(
        children: [
          SafeAvatarWidget(
            radius: 28,
            imageUrl: chat.imageUrl,
            userName: chat.name,
          ),
          // Online indicator
          if (chat.isOnline)
            Positioned(
              right: 2.w,
              bottom: 2.h,
              child: Container(
                width: 12.w,
                height: 12.h,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.w),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        chat.name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
      ),
      subtitle: Text(
        chat.lastMessage,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            chat.time,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12.sp),
          ),
          // SizedBox(height: 4.h),
          _buildStatusIcon(),
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    if (chat.unreadMessages > 0) {
      return Container(
        padding: EdgeInsets.all(6.r),
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: Text(
          chat.unreadMessages.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      IconData icon;
      Color color;
      switch (chat.status) {
        case MessageStatus.read:
          icon = Icons.done_all;
          color = Colors.blue;
          break;
        case MessageStatus.delivered:
          icon = Icons.done_all;
          color = Colors.grey;
          break;
        case MessageStatus.sent:
          icon = Icons.done;
          color = Colors.grey;
          break;
        case MessageStatus.incoming:
          return const SizedBox.shrink();
      }
      return Icon(icon, color: color, size: 18.sp);
    }
  }
}
