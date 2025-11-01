import 'package:dot_connections/app/core/services/socket_service.dart';
import 'package:dot_connections/app/data/models/chat_model.dart';
import 'package:dot_connections/app/data/api/message_api_client.dart';
import 'package:dot_connections/app/core/constants/api_endpoints.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  late final SocketService _socketService;
  late final MessageApiClient _messageApiClient;

  // Observable list of chats
  final chats = <Chat>[].obs;

  // Loading state
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // Helper method to construct full image URL
  String _getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    if (imagePath.startsWith('http')) return imagePath; // Already a full URL
    return '${ApiEndpoints.rootUrl}$imagePath';
  }

  @override
  void onInit() {
    super.onInit();
    _socketService = Get.find<SocketService>();
    _messageApiClient = MessageApiClient();
    _initializeSocketListeners();
    _loadInitialChats();

    // Log that ChatController is initialized
    print('🎯 ChatController initialized and listening for socket events');
  }

  void _initializeSocketListeners() {
    print('🔌 ChatController: Initializing socket listeners');

    // Listen for new messages to update chat list
    _socketService.addEventListener('message-received', (data) {
      print('🔔 ChatController: Received message-received event');
      _updateChatFromMessage(data);
    });

    // Listen for user online/offline status
    _socketService.addEventListener('user-online', (data) {
      print('🟢 ChatController: User online event');
      _updateUserStatus(data, true);
    });

    _socketService.addEventListener('user-offline', (data) {
      print('🔴 ChatController: User offline event');
      _updateUserStatus(data, false);
    });

    print('✅ ChatController: Socket listeners initialized');
  }

  void _loadInitialChats() {
    // Load chat list from API
    _loadChatListFromAPI();
  }

  /// Load chat list from API
  Future<void> _loadChatListFromAPI() async {
    try {
      _isLoading.value = true;

      final response = await _messageApiClient.getChatList();

      if (response.success) {
        final List<Chat> apiChats = response.data.map((chatItem) {
          return Chat(
            id: chatItem.id,
            partnerId: chatItem.participant.id,
            imageUrl: _getFullImageUrl(chatItem.participant.image),
            name: chatItem.participant.fullName,
            lastMessage: chatItem.lastMessage,
            time: _formatTime(chatItem.lastMessageTime.toIso8601String()),
            status: chatItem.isRead
                ? MessageStatus.read
                : MessageStatus.delivered,
            unreadMessages: chatItem.unreadCount,
            isOnline: false, // Will be updated via socket events
          );
        }).toList();

        chats.assignAll(apiChats);
        print('✅ Loaded ${apiChats.length} chats from API');
      } else {
        print('❌ Failed to load chat list: ${response.message}');
      }
    } catch (e) {
      print('❌ Error loading chat list: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void _updateChatFromMessage(dynamic messageData) {
    try {
      print('🔔 ChatController received message: $messageData');

      final senderId = messageData['senderId'] as String?;
      final message = messageData['message'] as String?;
      final timestamp = messageData['timestamp'] as String?;

      if (senderId == null || message == null) {
        print('❌ Invalid message data: senderId=$senderId, message=$message');
        return;
      }

      print('📝 Processing message from $senderId: "$message"');

      // Find existing chat or create new one
      final existingChatIndex = chats.indexWhere(
        (chat) => chat.partnerId == senderId,
      );

      print('🔍 Existing chat index for $senderId: $existingChatIndex');

      if (existingChatIndex != -1) {
        // Update existing chat
        print('✅ Updating existing chat at index $existingChatIndex');

        final existingChat = chats[existingChatIndex];
        final updatedChat = Chat(
          id: existingChat.id,
          partnerId: existingChat.partnerId,
          imageUrl: existingChat.imageUrl,
          name: existingChat.name,
          lastMessage: message,
          time: _formatTime(timestamp ?? DateTime.now().toIso8601String()),
          status: MessageStatus.incoming,
          unreadMessages: existingChat.unreadMessages + 1,
          isOnline: existingChat.isOnline,
        );

        chats[existingChatIndex] = updatedChat;

        // Move to top of list
        chats.removeAt(existingChatIndex);
        chats.insert(0, updatedChat);

        print(
          '✅ Chat updated and moved to top. New unread count: ${updatedChat.unreadMessages}',
        );
      } else {
        // Create new chat
        print('➕ Creating new chat for sender: $senderId');

        final newChat = Chat(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          partnerId: senderId,
          imageUrl: '', // No default asset, will show initials
          name: 'User $senderId', // This should come from user profile API
          lastMessage: message,
          time: _formatTime(timestamp ?? DateTime.now().toIso8601String()),
          status: MessageStatus.incoming,
          unreadMessages: 1,
          isOnline: false,
        );

        chats.insert(0, newChat);
        print('✅ New chat created and added to list');
      }

      // Force UI update
      update();
      print('🔄 UI update triggered for chat list');
    } catch (e) {
      print('Error updating chat from message: $e');
    }
  }

  void _updateUserStatus(dynamic statusData, bool isOnline) {
    try {
      final userId = statusData['userId'] as String?;

      if (userId == null) return;

      // Update online status for matching chat
      final chatIndex = chats.indexWhere((chat) => chat.partnerId == userId);
      if (chatIndex != -1) {
        final chat = chats[chatIndex];
        chats[chatIndex] = Chat(
          id: chat.id,
          partnerId: chat.partnerId,
          imageUrl: chat.imageUrl,
          name: chat.name,
          lastMessage: chat.lastMessage,
          time: chat.time,
          status: chat.status,
          unreadMessages: chat.unreadMessages,
          isOnline: isOnline,
        );
      }
    } catch (e) {
      print('Error updating user status: $e');
    }
  }

  String _formatTime(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h';
      } else {
        return '${difference.inDays}d';
      }
    } catch (e) {
      return 'now';
    }
  }

  // Mark chat as read when user opens conversation
  void markChatAsRead(String partnerId) {
    final chatIndex = chats.indexWhere((chat) => chat.partnerId == partnerId);
    if (chatIndex != -1) {
      final chat = chats[chatIndex];
      chats[chatIndex] = Chat(
        id: chat.id,
        partnerId: chat.partnerId,
        imageUrl: chat.imageUrl,
        name: chat.name,
        lastMessage: chat.lastMessage,
        time: chat.time,
        status: chat.status,
        unreadMessages: 0,
        isOnline: chat.isOnline,
      );
    }
  }

  // Method to refresh chats (can be called from pull-to-refresh)
  Future<void> refreshChats() async {
    await _loadChatListFromAPI();
  }
}
