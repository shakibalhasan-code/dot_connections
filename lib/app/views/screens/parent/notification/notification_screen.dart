import '../../../../controllers/notification_controller.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// NotificationScreen displays user notifications with read/unread status
///
/// This screen shows a list of notifications with the following features:
/// - Visual distinction between read and unread notifications
/// - Tap to mark notifications as read
/// - Clean, modern UI design
///
/// Customization points:
/// - Change notification icons by modifying the leading widget
/// - Customize colors in AppColors class
/// - Modify notification layout by editing the ListTile structure
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the notification controller
    final NotificationController controller = Get.put(NotificationController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: AppTextStyle.primaryTextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Add "Mark All Read" action button
          IconButton(
            onPressed: () => controller.markAllAsRead(),
            icon: Icon(Icons.done_all, color: AppColors.primaryColor),
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: Obx(() {
        // Show empty state if no notifications
        if (controller.notifications.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          itemCount: controller.notifications.length,
          separatorBuilder: (context, index) =>
              Divider(height: 1, color: Colors.grey.shade200),
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return _buildNotificationTile(notification, controller, index);
          },
        );
      }),
    );
  }

  /// Builds individual notification tile with enhanced styling
  Widget _buildNotificationTile(
    notification,
    NotificationController controller,
    int index,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      leading: Container(
        width: 50.w,
        height: 50.w,
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.grey.shade300
              : AppColors.primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
          border: notification.isRead
              ? null
              : Border.all(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  width: 2,
                ),
        ),
        child: Icon(
          _getNotificationIcon(notification.type ?? 'general'),
          color: notification.isRead
              ? Colors.grey.shade600
              : AppColors.primaryColor,
          size: 24.sp,
        ),
      ),
      title: Text(
        notification.title,
        style: GoogleFonts.poppins(
          fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
          fontSize: 16.sp,
          color: AppColors.primaryTextColor,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4.h),
          Text(
            notification.message,
            style: AppTextStyle.primaryTextStyle(
              fontSize: 14.sp,
              color: AppColors.secondaryTextColor,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            notification.time,
            style: AppTextStyle.primaryTextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
      trailing: notification.isRead
          ? null
          : Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
      tileColor: notification.isRead
          ? Colors.white
          : AppColors.primaryColor.withOpacity(0.03),
      onTap: () => controller.markAsRead(index),
    );
  }

  /// Returns appropriate icon based on notification type
  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'match':
        return Icons.favorite;
      case 'message':
        return Icons.message;
      case 'like':
        return Icons.thumb_up;
      case 'visit':
        return Icons.visibility;
      default:
        return Icons.notifications;
    }
  }

  /// Builds empty state when no notifications are available
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16.h),
          Text(
            'No notifications yet',
            style: AppTextStyle.primaryTextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryTextColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'You\'ll see notifications here when you have new matches,\nmessages, or profile visits.',
            textAlign: TextAlign.center,
            style: AppTextStyle.primaryTextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
