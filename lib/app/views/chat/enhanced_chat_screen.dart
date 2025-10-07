import 'package:finder/app/models/enhanced_user_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnhancedChatScreen extends StatelessWidget {
  final String matchId;
  final String recipientId;

  const EnhancedChatScreen({
    Key? key,
    required this.matchId,
    required this.recipientId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatThemeController = Get.find<ChatThemeController>();
    final iceBreakersController = Get.find<IceBreakersController>();

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // Chat mood selector
          _buildMoodSelector(chatThemeController),

          // Messages list
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: chatThemeController.currentTheme.value.gradient,
              ),
              child: _buildMessagesList(),
            ),
          ),

          // Quick replies and input area
          _buildInputArea(iceBreakersController),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundImage: NetworkImage('recipient_avatar_url'),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recipient Name',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                'Online',
                style: TextStyle(fontSize: 12.sp, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.local_activity),
          onPressed: () => _showIceBreakers(),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showChatOptions(),
        ),
      ],
    );
  }

  Widget _buildMoodSelector(ChatThemeController controller) {
    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ChatTheme.values.length,
        itemBuilder: (context, index) {
          final theme = ChatTheme.values[index];
          return Obx(
            () => GestureDetector(
              onTap: () => controller.setTheme(theme),
              child: Container(
                margin: EdgeInsets.only(right: 12.w),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  gradient: theme.gradient,
                  borderRadius: BorderRadius.circular(20.r),
                  border: controller.currentTheme.value == theme
                      ? Border.all(color: Colors.white, width: 2)
                      : null,
                ),
                child: Center(
                  child: Text(
                    theme.label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 0, // Replace with actual messages
      itemBuilder: (context, index) {
        return Container(); // Replace with message bubble
      },
    );
  }

  Widget _buildInputArea(IceBreakersController iceBreakersController) {
    return Column(
      children: [
        // Quick replies
        SizedBox(
          height: 40.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: iceBreakersController.quickReplies.length,
            itemBuilder: (context, index) {
              final reply = iceBreakersController.quickReplies[index];
              return Container(
                margin: EdgeInsets.only(right: 8.w),
                child: OutlinedButton(
                  onPressed: () => _sendMessage(reply),
                  child: Text(reply),
                ),
              );
            },
          ),
        ),

        // Input field and actions
        Container(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => _showAttachmentOptions(),
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.mic),
                onPressed: () => _startVoiceRecording(),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _sendMessage(null),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showIceBreakers() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ice Breakers',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            // List of ice breakers
            ListView.builder(
              shrinkWrap: true,
              itemCount: 5, // Replace with actual ice breakers
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Ice breaker question $index'),
                  onTap: () => _sendIceBreaker(index),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showChatOptions() {
    // Implement chat options menu
  }

  void _showAttachmentOptions() {
    // Implement attachment options
  }

  void _startVoiceRecording() {
    // Implement voice recording
  }

  void _sendMessage(String? message) {
    // Implement send message
  }

  void _sendIceBreaker(int index) {
    // Implement send ice breaker
  }
}

enum ChatTheme {
  romantic(
    label: 'Romantic',
    gradient: LinearGradient(
      colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  playful(
    label: 'Playful',
    gradient: LinearGradient(
      colors: [Color(0xFFFED330), Color(0xFFFFE169)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  calm(
    label: 'Calm',
    gradient: LinearGradient(
      colors: [Color(0xFF4ECDC4), Color(0xFF7EE8E1)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  energetic(
    label: 'Energetic',
    gradient: LinearGradient(
      colors: [Color(0xFFFF9F43), Color(0xFFFAD02C)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  final String label;
  final LinearGradient gradient;

  const ChatTheme({required this.label, required this.gradient});
}

class ChatThemeController extends GetxController {
  final Rx<ChatTheme> currentTheme = ChatTheme.calm.obs;

  void setTheme(ChatTheme theme) {
    currentTheme.value = theme;
  }
}

class IceBreakersController extends GetxController {
  final RxList<String> quickReplies = <String>[
    'Hey! How are you?',
    'What are you up to?',
    'Nice to meet you!',
    'What do you like to do for fun?',
    'Have any weekend plans?',
  ].obs;

  final RxList<IceBreaker> iceBreakers = <IceBreaker>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadIceBreakers();
  }

  Future<void> _loadIceBreakers() async {
    // Load ice breakers from API or local storage
  }
}
