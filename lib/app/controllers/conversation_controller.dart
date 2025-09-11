import 'package:dot_connections/app/models/conversation_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ConversationController extends GetxController {
  final messages = <Message>[
    Message(
      text: 'Hey, saw your dot near the café yesterday. You go there often?',
      isMe: false,
      type: MessageType.text,
      userAvatar: 'assets/images/Annette_Black.png',
    ),
    Message(
      text: 'Yeah, I work there sometimes. How about you?',
      isMe: true,
      type: MessageType.text,
      userAvatar: 'assets/images/Eleanor_Pena.png',
    ),
    Message(
      text: 'Same! Want to grab a coffee together?',
      isMe: false,
      type: MessageType.text,
      userAvatar: 'assets/images/Annette_Black.png',
    ),
    Message(
      text: 'Sure, this weekend?',
      isMe: true,
      type: MessageType.text,
      userAvatar: 'assets/images/Eleanor_Pena.png',
    ),
    Message(
      isMe: false,
      type: MessageType.audio,
      userAvatar: 'assets/images/Annette_Black.png',
    ),
    Message(
      text: 'Sure, this weekend?',
      isMe: true,
      type: MessageType.text,
      userAvatar: 'assets/images/Eleanor_Pena.png',
    ),
  ].obs;

  var image = Rxn<XFile>();
  final picker = ImagePicker();

  void imagePicker() async {
    try {
      // Pick singe image or video.
      final XFile? media = await picker.pickMedia();
      media != null
          ? image.value = media
          : Get.snackbar('Failed', 'Unable to get the image');
    } catch (e) {
      print('Failed to pick the image');
      kDebugMode ? printInfo(info: 'failed $e') : null;
    }
  }
}
