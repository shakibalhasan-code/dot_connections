enum MessageType { text, audio }

class Message {
  final String? text;
  final bool isMe;
  final MessageType type;
  final String userAvatar;
  final String? audioUrl; // For network audio
  final String? audioPath; // For local audio files

  Message({
    this.text,
    required this.isMe,
    required this.type,
    required this.userAvatar,
    this.audioUrl,
    this.audioPath,
  });
}
