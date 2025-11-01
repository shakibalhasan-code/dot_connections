import 'package:dot_connections/app/controllers/conversation_controller.dart';
import 'package:dot_connections/app/core/utils/app_colors.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:dot_connections/app/views/screens/parent/chat/widgets/message_bubble.dart';
import 'package:dot_connections/app/views/screens/parent/chat/widgets/message_input_field.dart';
import 'package:dot_connections/app/views/widgets/user_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  late ConversationController controller;
  String partnerName = 'Chat';
  String partnerImage = '';
  String partnerId = '';

  @override
  void initState() {
    super.initState();
    controller = Get.put(ConversationController());

    // Get arguments passed from chat list
    final arguments = Get.arguments as Map<String, dynamic>?;
    print('🔍 ConversationScreen arguments: $arguments');

    if (arguments != null) {
      partnerId = arguments['partnerId'] ?? '';
      partnerName = arguments['partnerName'] ?? 'Chat';
      partnerImage = arguments['partnerImage'] ?? '';

      print('🔍 Parsed values:');
      print('   partnerId: "$partnerId"');
      print('   partnerName: "$partnerName"');
      print('   partnerImage: "$partnerImage"');

      // Start conversation with the partner
      if (partnerId.isNotEmpty) {
        print('✅ Starting conversation with partnerId: "$partnerId"');
        controller.startConversation(partnerId, partnerName);
      } else {
        print('❌ Cannot start conversation: partnerId is empty');
      }
    } else {
      print('❌ No arguments received in ConversationScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            SafeAvatarWidget(
              radius: 16,
              imageUrl: partnerImage.isNotEmpty ? partnerImage : null,
              userName: partnerName,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    partnerName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Add online status indicator
                  Obx(
                    () => Text(
                      controller.partnerIsTyping ? 'typing...' : 'online',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: controller.partnerIsTyping
                            ? AppColors.primaryColor
                            : Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
            child: Obx(() {
              if (controller.isLoadingMessages && controller.messages.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return MessageBubble(message: message);
                },
              );
            }),
          ),
          const MessageInputField(),
        ],
      ),
    );
  }
}
