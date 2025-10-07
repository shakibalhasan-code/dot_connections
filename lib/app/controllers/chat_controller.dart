import 'package:finder/app/models/chat_model.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final chats = <Chat>[
    Chat(
      imageUrl: 'assets/images/welcome_image.png',
      name: 'Annette Black',
      lastMessage: 'Thank you! I will see you to...',
      time: '1h',
      status: MessageStatus.read,
    ),
    Chat(
      imageUrl: 'assets/images/welcome_image.png',
      name: 'Eleanor Pena',
      lastMessage: 'Fringilla leo sem cursus ut p...',
      time: '2h',
      status: MessageStatus.delivered,
    ),
    Chat(
      imageUrl: 'assets/images/welcome_image.png',
      name: 'Annette Black',
      lastMessage: 'Thank you! I will see you to...',
      time: '4h',
      status: MessageStatus.read,
    ),
    Chat(
      imageUrl: 'assets/images/welcome_image.png',
      name: 'Eleanor Pena',
      lastMessage: 'Fringilla leo sem cursus ut p...',
      time: '5h',
      status: MessageStatus.delivered,
    ),
    Chat(
      imageUrl: 'assets/images/welcome_image.png',
      name: 'Eleanor Pena',
      lastMessage: 'Could you send me a link t...',
      time: '6h',
      status: MessageStatus.delivered,
      unreadMessages: 2,
    ),
    Chat(
      imageUrl: 'assets/images/welcome_image.png',
      name: 'Annette Black',
      lastMessage: 'Thank you! I will see you to...',
      time: '8h',
      status: MessageStatus.read,
    ),
    Chat(
      imageUrl: 'assets/images/welcome_image.png',
      name: 'Marvin McKinney',
      lastMessage: 'Incoming...',
      time: '10h',
      status: MessageStatus.incoming,
    ),
  ].obs;
}
