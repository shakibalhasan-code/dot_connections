enum MessageType { text, audio }

class Message {
  final String? text;
  final bool isMe;
  final MessageType type;
  final String userAvatar;

  Message({
    this.text,
    required this.isMe,
    required this.type,
    required this.userAvatar,
  });
}
