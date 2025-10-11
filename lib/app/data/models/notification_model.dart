/// NotificationModel represents a single notification in the app
///
/// This model contains all necessary information for displaying notifications
/// including read status, notification type, and timing information.
///
/// Customization points:
/// - Add more notification types in the type field
/// - Include additional metadata like actionUrl, imageUrl, etc.
/// - Extend with user information for personalized notifications
class NotificationModel {
  /// Unique identifier for the notification
  final String? id;

  /// Title/heading of the notification
  final String title;

  /// Detailed message content
  final String message;

  /// Human-readable time string (e.g., "10 min ago", "2 hours ago")
  final String time;

  /// Whether the notification has been read by the user
  final bool isRead;

  /// Type of notification (match, message, like, visit, general, etc.)
  /// This can be used for categorization and custom styling
  final String? type;

  /// Optional image URL for rich notifications
  final String? imageUrl;

  /// Optional action URL or route to navigate when tapped
  final String? actionUrl;

  NotificationModel({
    this.id,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
    this.type,
    this.imageUrl,
    this.actionUrl,
  });

  /// Creates a copy of this notification with updated values
  ///
  /// This method is useful for updating notification state immutably
  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? time,
    bool? isRead,
    String? type,
    String? imageUrl,
    String? actionUrl,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }

  /// Converts the model to a Map for JSON serialization
  ///
  /// Useful for API communication and local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'time': time,
      'isRead': isRead,
      'type': type,
      'imageUrl': imageUrl,
      'actionUrl': actionUrl,
    };
  }

  /// Creates a NotificationModel from a JSON Map
  ///
  /// Useful for parsing API responses and local storage data
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      time: json['time'] ?? '',
      isRead: json['isRead'] ?? false,
      type: json['type'],
      imageUrl: json['imageUrl'],
      actionUrl: json['actionUrl'],
    );
  }

  /// Returns a string representation of the notification for debugging
  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, message: $message, time: $time, isRead: $isRead, type: $type)';
  }

  /// Compares two NotificationModel instances for equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationModel &&
        other.id == id &&
        other.title == title &&
        other.message == message &&
        other.time == time &&
        other.isRead == isRead &&
        other.type == type &&
        other.imageUrl == imageUrl &&
        other.actionUrl == actionUrl;
  }

  /// Generates hash code for the notification
  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      message,
      time,
      isRead,
      type,
      imageUrl,
      actionUrl,
    );
  }
}
