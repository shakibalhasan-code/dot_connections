import 'package:dot_connections/app/controllers/notification_controller.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: AppTextStyle.primaryTextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: notification.isRead
                    ? Colors.grey
                    : Theme.of(context).primaryColor,
                child: const Icon(Icons.notifications, color: Colors.white),
              ),
              title: Text(
                notification.title,
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(notification.message),
              trailing: Text(notification.time),
              tileColor: notification.isRead
                  ? Colors.white
                  : Colors.blue.withOpacity(0.1),
            );
          },
        ),
      ),
    );
  }
}
