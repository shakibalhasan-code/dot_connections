import 'package:image_picker/image_picker.dart';

enum MessageType { text, audio, image }

class Message {
  final String? text;
  final bool isMe;
  final MessageType type;
  final String userAvatar;
  final String? audioUrl; // For network audio
  final String? audioPath; // For local audio files
  final XFile? imageFile; // For local image files
  final String? imageUrl; // For network images

  Message({
    this.text,
    required this.isMe,
    required this.type,
    required this.userAvatar,
    this.audioUrl,
    this.audioPath,
    this.imageFile,
    this.imageUrl,
  });
}
