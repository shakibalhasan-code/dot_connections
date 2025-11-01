enum MessageStatus { sent, delivered, read, incoming }

class Chat {
  final String id;
  final String partnerId;
  final String imageUrl;
  final String name;
  final String lastMessage;
  final String time;
  final MessageStatus status;
  final int unreadMessages;
  final bool isOnline;

  Chat({
    required this.id,
    required this.partnerId,
    required this.imageUrl,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.status,
    this.unreadMessages = 0,
    this.isOnline = false,
  });
}
