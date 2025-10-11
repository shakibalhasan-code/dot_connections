import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/data/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ChatItem extends StatelessWidget {
  final Chat chat;

  const ChatItem({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Get.toNamed(AppRoutes.conversation),
      leading: CircleAvatar(
        radius: 28.r,
        backgroundImage: AssetImage(chat.imageUrl),
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
