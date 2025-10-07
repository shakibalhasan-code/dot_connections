import '../models/notification_model.dart';
import 'package:get/get.dart';

/// NotificationController manages notification state and operations
///
/// This controller handles:
/// - Loading and managing notification data
/// - Marking notifications as read/unread
/// - Providing mock data for demonstration
///
/// Customization points:
/// - Replace fetchNotifications() with actual API calls
/// - Modify notification types and data structure
/// - Add push notification handling
class NotificationController extends GetxController {
  /// Observable list of notifications
  var notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  /// Fetches notifications from mock data
  ///
  /// TODO: Replace with actual API integration
  /// Example API integration:
  /// ```dart
  /// final response = await ApiService.getNotifications();
  /// notifications.assignAll(response.data);
  /// ```
  void fetchNotifications() {
    // Mock data with different notification types for demonstration
    var notificationList = [
      NotificationModel(
        title: 'New Match!',
        message: 'You have a new match with Eleanor Pena. Start chatting now!',
        time: '10 min ago',
        isRead: false,
        type: 'match',
      ),
      NotificationModel(
        title: 'New Message',
        message: 'Annette Black sent you a message: "Hey! How are you doing?"',
        time: '1 hour ago',
        isRead: false,
        type: 'message',
      ),
      NotificationModel(
        title: 'Someone liked you!',
        message: 'You received a new like. Check out who it is!',
        time: '2 hours ago',
        isRead: true,
        type: 'like',
      ),
      NotificationModel(
        title: 'Profile Visit',
        message: 'Someone visited your profile. View their profile now.',
        time: '3 hours ago',
        isRead: false,
        type: 'visit',
      ),
      NotificationModel(
        title: 'Welcome to TrueDots!',
        message: 'Complete your profile to start finding amazing matches.',
        time: '1 day ago',
        isRead: true,
        type: 'general',
      ),
    ];
    notifications.assignAll(notificationList);
  }

  /// Marks a specific notification as read
  ///
  /// [index] - The index of the notification to mark as read
  void markAsRead(int index) {
    if (index >= 0 && index < notifications.length) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      notifications.refresh();

      // TODO: Update read status on server
      // ApiService.markNotificationAsRead(notifications[index].id);
    }
  }

  /// Marks all notifications as read
  void markAllAsRead() {
    for (int i = 0; i < notifications.length; i++) {
      if (!notifications[i].isRead) {
        notifications[i] = notifications[i].copyWith(isRead: true);
      }
    }
    notifications.refresh();

    // TODO: Update all read status on server
    // ApiService.markAllNotificationsAsRead();
  }

  /// Gets count of unread notifications
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  /// Adds a new notification (for testing or real-time updates)
  ///
  /// [notification] - The notification to add
  void addNotification(NotificationModel notification) {
    notifications.insert(0, notification);

    // TODO: Show local push notification if app is in foreground
    // LocalNotificationService.show(notification);
  }

  /// Removes a notification
  ///
  /// [index] - The index of the notification to remove
  void removeNotification(int index) {
    if (index >= 0 && index < notifications.length) {
      notifications.removeAt(index);

      // TODO: Remove from server
      // ApiService.deleteNotification(notifications[index].id);
    }
  }

  /// Clears all notifications
  void clearAll() {
    notifications.clear();

    // TODO: Clear all from server
    // ApiService.clearAllNotifications();
  }
}
