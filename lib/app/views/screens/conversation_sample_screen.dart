import 'package:dot_connections/app/controllers/conversation_controller.dart';
import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Sample conversation screen showing how to use the socket-enabled ConversationController
class ConversationScreen extends StatefulWidget {
  final String chatPartnerId;
  final String chatPartnerName;

  const ConversationScreen({
    Key? key,
    required this.chatPartnerId,
    required this.chatPartnerName,
  }) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  late ConversationController conversationController;
  late AuthController authController;

  @override
  void initState() {
    super.initState();
    conversationController = Get.put(ConversationController());
    authController = Get.find<AuthController>();

    // Set up the chat partner when entering the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      conversationController.setChatPartner(
        widget.chatPartnerId,
        authController.currentUser.value?.id ?? '',
      );
    });
  }

  @override
  void dispose() {
    // Clear chat partner when leaving the screen
    conversationController.clearChatPartner();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.chatPartnerName,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            Obx(() {
              if (conversationController.partnerIsTyping) {
                return Text(
                  'typing...',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                );
              }
              // You can add online status here
              return Text(
                'Online', // Replace with actual online status
                style: TextStyle(fontSize: 12.sp, color: Colors.green),
              );
            }),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          // Socket connection status indicator (for debugging)
          Obx(() {
            final socketService = SocketService.instance;
            return IconButton(
              icon: Icon(
                Icons.circle,
                color: socketService.isConnected ? Colors.green : Colors.red,
                size: 12.h,
              ),
              onPressed: () {
                // Show connection status dialog
                _showConnectionStatus();
              },
            );
          }),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: conversationController.messages.length,
                itemBuilder: (context, index) {
                  final message = conversationController.messages[index];
                  return _buildMessageBubble(message);
                },
              );
            }),
          ),

          // Typing indicator
          Obx(() {
            if (conversationController.partnerIsTyping) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    Text(
                      '${widget.chatPartnerName} is typing',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    SizedBox(
                      width: 12.w,
                      height: 12.h,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Message input area
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(dynamic message) {
    // This is a simplified message bubble - you'll need to adapt based on your Message model
    final isMe = message.isMe ?? false;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 280.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              message.text ?? '',
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          // Image picker button
          IconButton(
            icon: const Icon(Icons.image, color: Colors.grey),
            onPressed: conversationController.pickImage,
          ),

          // Audio recording button
          Obx(() {
            return IconButton(
              icon: Icon(
                conversationController.isRecording ? Icons.stop : Icons.mic,
                color: conversationController.isRecording
                    ? Colors.red
                    : Colors.grey,
              ),
              onPressed: conversationController.toggleRecording,
            );
          }),

          // Text input field
          Expanded(
            child: TextField(
              controller: conversationController.messageFeildController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (text) {
                if (text.trim().isNotEmpty) {
                  conversationController.sendTextMessage(
                    text,
                    authController.currentUser.value?.id ?? '',
                  );
                }
              },
            ),
          ),

          SizedBox(width: 8.w),

          // Send button
          Obx(() {
            final hasText =
                conversationController.messageFeildController.text.isNotEmpty;
            final hasAudio =
                conversationController.audioPath?.isNotEmpty ?? false;

            return IconButton(
              icon: Icon(
                Icons.send,
                color: hasText || hasAudio ? Colors.blue : Colors.grey,
              ),
              onPressed: () {
                final currentUserId =
                    authController.currentUser.value?.id ?? '';

                if (hasText) {
                  conversationController.sendTextMessage(
                    conversationController.messageFeildController.text,
                    currentUserId,
                  );
                } else if (hasAudio) {
                  conversationController.sendAudioMessage(
                    conversationController.audioPath!,
                    currentUserId,
                  );
                }
              },
            );
          }),
        ],
      ),
    );
  }

  void _showConnectionStatus() {
    final socketService = SocketService.instance;
    final status = conversationController.getSocketStatus();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Socket Connection Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Connected: ${status['isConnected']}'),
            Text('Socket ID: ${status['socketId'] ?? 'N/A'}'),
            Text('Current User: ${status['currentUserId']}'),
            Text('Active Chat: ${status['activeChat']}'),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                socketService.reconnect();
                Get.back();
              },
              child: const Text('Reconnect'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }
}
