enum MessageStatus { sent, delivered, read, incoming }

class Chat {
  final String imageUrl;
  final String name;
  final String lastMessage;
  final String time;
  final MessageStatus status;
  final int unreadMessages;

  Chat({
    required this.imageUrl,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.status,
    this.unreadMessages = 0,
  });
}
