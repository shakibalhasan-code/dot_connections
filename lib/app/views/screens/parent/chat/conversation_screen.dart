import '../../../../controllers/conversation_controller.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/text_style.dart';
import 'widgets/message_bubble.dart';
import 'widgets/message_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ConversationController controller = Get.put(ConversationController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('Annette Black'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options action
              final moreActionItems = PopupMenuButton<String>(
                onSelected: (value) {
                  // Handle menu item selection
                },
                itemBuilder: (BuildContext context) {
                  return {'View Profile', 'Block User', 'Report'}.map((
                    String choice,
                  ) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(
                        choice,
                        style: AppTextStyle.primaryTextStyle(
                          fontSize: 12.sp,
                          color: AppColors.primaryTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }).toList();
                },
              );
              showMenu(
                context: context,
                items: moreActionItems.itemBuilder(context),
                position: RelativeRect.fromLTRB(1000, 80, 0, 0),
              );
            },
          ),
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
  }
}
