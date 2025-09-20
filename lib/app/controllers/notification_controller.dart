import 'package:dot_connections/app/models/notification_model.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void fetchNotifications() {
    // This is a mock data. Replace it with your API call.
    var notificationList = [
      NotificationModel(
        title: 'New Match!',
        message: 'You have a new match with Eleanor Pena.',
        time: '10 min ago',
        isRead: false,
      ),
      NotificationModel(
        title: 'New Message',
        message: 'Annette Black sent you a message.',
        time: '1 hour ago',
        isRead: true,
      ),
      NotificationModel(
        title: 'Profile Visit',
        message: 'Someone visited your profile.',
        time: '3 hours ago',
        isRead: false,
      ),
    ];
    notifications.assignAll(notificationList);
  }
}
