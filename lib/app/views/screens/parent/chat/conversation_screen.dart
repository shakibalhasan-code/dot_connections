import 'package:dot_connections/app/controllers/conversation_controller.dart';
import 'package:dot_connections/app/views/screens/parent/chat/widgets/message_bubble.dart';
import 'package:dot_connections/app/views/screens/parent/chat/widgets/message_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConversationController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
            title: const Text('Annette Black'),
            actions: [
              IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            ],
            elevation: 0,
            foregroundColor: Colors.black,
          ),
          body: Column(
            children: [
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final message = controller.messages[index];
                      return MessageBubble(message: message);
                    },
                  ),
                ),
              ),
              const MessageInputField(),
            ],
          ),
        );
      },
    );
  }
}
