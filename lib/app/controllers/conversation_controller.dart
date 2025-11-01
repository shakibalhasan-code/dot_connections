import 'dart:io';
import 'dart:async';

import 'package:dot_connections/app/core/services/socket_service.dart';
import 'package:dot_connections/app/data/api/message_api_client.dart';
import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/data/models/conversation_model.dart';
import 'package:dot_connections/app/core/constants/api_endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class ConversationController extends GetxController {
  // Socket service instance
  late final SocketService _socketService;

  // API client for REST operations
  late final MessageApiClient _messageApiClient;

  // Conversation data
  final messages = <Message>[].obs;
  final apiMessages = <MessageData>[].obs; // For API-fetched messages
  final RxBool _isTyping = false.obs;
  final RxBool _partnerIsTyping = false.obs;
  final RxString _currentChatPartnerId = ''.obs;
  final RxString _currentPartnerName = ''.obs;

  // Loading and pagination states
  final _isLoadingMessages = false.obs;
  final _isSendingMessage = false.obs;
  final _currentPage = 1.obs;
  final _hasMoreMessages = true.obs;
  final _hasPermissionError = false.obs;

  // Media handling
  var image = Rxn<XFile>();
  final imagePicker = ImagePicker();

  // Audio recording
  final _recording = false.obs;
  final RxString _path = RxString('');
  String? get audioPath => _path.value;
  bool get isRecording => _recording.value;
  set isRecording(bool value) => _recording.value;
  final AudioRecorder _audioRecorder = AudioRecorder();

  // UI controllers
  final messageFeildController = TextEditingController();

  // Typing timer
  Timer? _typingTimer;

  // Getters
  bool get isTyping => _isTyping.value;
  bool get partnerIsTyping => _partnerIsTyping.value;
  String get currentChatPartnerId => _currentChatPartnerId.value;
  bool get isLoadingMessages => _isLoadingMessages.value;
  bool get isSendingMessage => _isSendingMessage.value;
  int get currentPage => _currentPage.value;
  bool get hasMoreMessages => _hasMoreMessages.value;
  bool get hasPermissionError => _hasPermissionError.value;
  String get currentPartnerName => _currentPartnerName.value;

  // Helper method to construct full image URL
  String _getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    if (imagePath.startsWith('http')) return imagePath; // Already a full URL
    final fullUrl = '${ApiEndpoints.rootUrl}$imagePath';
    debugPrint('🔗 ConversationController: Constructed image URL: $fullUrl');
    return fullUrl;
  }

  @override
  void onInit() {
    super.onInit();
    _messageApiClient = MessageApiClient();
    _initializeSocketConnection();
    _setupMessageFieldListener();
    loadMessages();
  }

  @override
  void onClose() {
    _socketService.removeEventListener('message-received', _onMessageReceived);
    _socketService.removeEventListener('message-sent', _onMessageSent);
    _socketService.removeEventListener('messages-read', _onMessagesRead);
    _socketService.removeEventListener('typing', _onTyping);
    _socketService.removeEventListener('stop-typing', _onStopTyping);
    _socketService.clearActiveChat(_currentChatPartnerId.value);
    _typingTimer?.cancel();
    messageFeildController.dispose();
    super.onClose();
  }

  /// Initialize socket connection and event listeners
  void _initializeSocketConnection() {
    _socketService = SocketService.instance;

    // Setup event listeners
    _socketService.addEventListener('message-received', _onMessageReceived);
    _socketService.addEventListener('message-sent', _onMessageSent);
    _socketService.addEventListener('messages-read', _onMessagesRead);
    _socketService.addEventListener('typing', _onTyping);
    _socketService.addEventListener('stop-typing', _onStopTyping);

    debugPrint('✅ ConversationController socket events initialized');
  }

  /// Setup text field listener for typing indicators
  void _setupMessageFieldListener() {
    messageFeildController.addListener(() {
      if (messageFeildController.text.isNotEmpty && !_isTyping.value) {
        _startTyping();
      } else if (messageFeildController.text.isEmpty && _isTyping.value) {
        _stopTyping();
      }
    });
  }

  /// Set current chat partner and mark chat as active
  void setChatPartner(String partnerId, String currentUserId) {
    print('🔍 setChatPartner called with:');
    print('   partnerId: "$partnerId"');
    print('   currentUserId: "$currentUserId"');

    if (partnerId.isEmpty) {
      print('❌ Cannot set chat partner: partnerId is empty');
      return;
    }

    if (currentUserId.isEmpty) {
      print('❌ Cannot set chat partner: currentUserId is empty');
      return;
    }

    _currentChatPartnerId.value = partnerId;

    // Set this chat as active
    _socketService.setActiveChat(
      currentUserId: currentUserId,
      chatPartnerId: partnerId,
    );

    // Mark messages as read when opening chat
    _socketService.markMessagesAsRead(
      senderId: partnerId,
      receiverId: currentUserId,
    );

    debugPrint('💬 Chat partner set: $partnerId');
  }

  /// Clear current chat when leaving conversation
  void clearChatPartner() {
    if (_currentChatPartnerId.value.isNotEmpty) {
      _socketService.clearActiveChat(_currentChatPartnerId.value);
      _currentChatPartnerId.value = '';
      _stopTyping();
    }
  }

  Future<void> _startRecording() async {
    debugPrint('Starting recording...');
    if (await _audioRecorder.hasPermission()) {
      debugPrint('permission have...');

      final directory = await getApplicationDocumentsDirectory();

      await _audioRecorder.start(
        const RecordConfig(
          //first argument required
          encoder: AudioEncoder.wav, // or opus, wav, etc.
          bitRate: 128000,
          sampleRate: 44100,
        ),
        //named argument
        path:
            "${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav",
      );
    } else {
      debugPrint('No recording permission granted');
    }
  }

  void toggleRecording() async {
    // Add haptic feedback
    HapticFeedback.lightImpact();

    if (isRecording) {
      // Stop recording
      final recordeAudiodPath = await _audioRecorder.stop();
      isRecording = false;

      ///check if path is null
      if (recordeAudiodPath == null) {
        (true);
        _recording(false);
        debugPrint('Recording failed, no file path returned');
        update();
        return;
      }

      final file = File(recordeAudiodPath);
      if (!await file.exists()) {
        (false);
        _recording(false);
        debugPrint(
          'Recording failed, file does not exist at path: $recordeAudiodPath',
        );
        update();
        return;
      }
      debugPrint('Recorded file size: ${await file.length()} bytes');

      _recording(false);
      _path.value = recordeAudiodPath;
      debugPrint(
        'Recording stopped, file saved. and stored in variable $_path',
      );

      update();
    } else {
      // Start recording
      await _startRecording();
      isRecording = true;
      update();
    }
  }

  //image picker
  void pickImage() async {
    // Add haptic feedback
    HapticFeedback.selectionClick();

    try {
      final imagePicked = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (imagePicked == null) {
        return;
      } else {
        image.value = imagePicked;
        // Optionally send the image immediately or let user send it manually
        // Note: You need to pass the current user's ID here
        sendImageMessage(imagePicked, _socketService.currentUserId);
      }
    } catch (e) {
      debugPrint('error to pick the image> $e');
    }
  }

  // Send text message
  void sendTextMessage(String text, String senderId) {
    if (text.trim().isEmpty || _currentChatPartnerId.value.isEmpty) return;

    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Add message to local UI immediately
    final currentUser = Get.find<AuthController>().currentUser.value;
    messages.add(
      Message(
        text: text,
        isMe: true,
        type: MessageType.text,
        userAvatar: _getFullImageUrl(currentUser?.image),
        userName: currentUser?.firstName ?? 'You',
      ),
    );

    // Send through socket
    _socketService.sendMessage(
      senderId: senderId,
      receiverId: _currentChatPartnerId.value,
      message: text,
    );

    // Clear text field and stop typing
    messageFeildController.clear();
    _stopTyping();

    update();
  }

  // Clear audio recording without sending
  void clearAudio() {
    // Delete the audio file if needed
    if (_path.value.isNotEmpty) {
      try {
        final file = File(_path.value);
        if (file.existsSync()) {
          file.deleteSync();
          debugPrint('Deleted audio file: ${_path.value}');
        }
      } catch (e) {
        debugPrint('Error deleting audio file: $e');
      }
    }

    // Clear the path
    _path.value = '';
    update();
  }

  // ============================================================================
  // SOCKET EVENT HANDLERS
  // ============================================================================

  /// Handle incoming message
  void _onMessageReceived(dynamic data) {
    try {
      debugPrint('📥 ConversationController: Message received: $data');

      final messageData = data as Map<String, dynamic>;
      final senderId = messageData['senderId'] as String?;
      final message = messageData['message'] as String?;
      final imageUrl = messageData['image'] as String?;

      debugPrint(
        '📥 ConversationController: senderId=$senderId, currentPartner=${_currentChatPartnerId.value}',
      );

      // Only add message if it's from current chat partner
      if (senderId == _currentChatPartnerId.value) {
        messages.add(
          Message(
            text: message ?? '',
            isMe: false,
            type: imageUrl != null ? MessageType.image : MessageType.text,
            userAvatar:
                '', // Partner image not available in socket message, will show initials
            userName: _currentPartnerName.value,
            imageUrl: imageUrl != null ? _getFullImageUrl(imageUrl) : null,
          ),
        );

        // Mark as read immediately since user is viewing the chat
        _socketService.markMessagesAsRead(
          senderId: senderId!,
          receiverId: _socketService.currentUserId,
        );

        update();
        debugPrint(
          '📥 ConversationController: Message added to conversation UI',
        );
      } else {
        debugPrint(
          '📥 ConversationController: Message not for current chat partner, ignoring',
        );
      }
    } catch (e) {
      debugPrint(
        '❌ ConversationController: Error handling received message: $e',
      );
    }
  }

  /// Handle message sent confirmation
  void _onMessageSent(dynamic data) {
    debugPrint('✅ Message sent confirmation: $data');
    // You can add logic here to mark messages as sent
  }

  /// Handle messages read confirmation
  void _onMessagesRead(dynamic data) {
    debugPrint('📖 Messages read confirmation: $data');
    // You can add logic here to update message read status
  }

  /// Handle typing indicator from partner
  void _onTyping(dynamic data) {
    try {
      final typingData = data as Map<String, dynamic>;
      final senderId = typingData['senderId'] as String?;

      if (senderId == _currentChatPartnerId.value) {
        _partnerIsTyping.value = true;
        update();
        debugPrint('⌨️ Partner is typing');
      }
    } catch (e) {
      debugPrint('❌ Error handling typing event: $e');
    }
  }

  /// Handle stop typing indicator from partner
  void _onStopTyping(dynamic data) {
    try {
      final typingData = data as Map<String, dynamic>;
      final senderId = typingData['senderId'] as String?;

      if (senderId == _currentChatPartnerId.value) {
        _partnerIsTyping.value = false;
        update();
        debugPrint('⌨️ Partner stopped typing');
      }
    } catch (e) {
      debugPrint('❌ Error handling stop typing event: $e');
    }
  }

  // ============================================================================
  // TYPING INDICATORS
  // ============================================================================

  /// Start typing indicator
  void _startTyping() {
    if (_isTyping.value || _currentChatPartnerId.value.isEmpty) return;

    _isTyping.value = true;
    _socketService.startTyping(
      senderId: _socketService.currentUserId,
      receiverId: _currentChatPartnerId.value,
    );

    // Auto-stop typing after 3 seconds of inactivity
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 3), () {
      _stopTyping();
    });

    debugPrint('⌨️ Started typing');
  }

  /// Stop typing indicator
  void _stopTyping() {
    if (!_isTyping.value || _currentChatPartnerId.value.isEmpty) return;

    _isTyping.value = false;
    _typingTimer?.cancel();

    _socketService.stopTyping(
      senderId: _socketService.currentUserId,
      receiverId: _currentChatPartnerId.value,
    );

    debugPrint('⌨️ Stopped typing');
  }

  // ============================================================================
  // UPDATED MESSAGE METHODS
  // ============================================================================

  // Send image message (updated)
  void sendImageMessage(XFile imageFile, String senderId) {
    if (_currentChatPartnerId.value.isEmpty) return;

    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Add to local UI optimistically
    final currentUser = Get.find<AuthController>().currentUser.value;
    messages.add(
      Message(
        isMe: true,
        type: MessageType.image,
        userAvatar: _getFullImageUrl(currentUser?.image),
        userName: currentUser?.firstName ?? 'You',
        imageFile: imageFile,
      ),
    );

    // Send via API with image upload
    sendMessageWithImage('', imageFile.path);

    // Clear the selected image
    image.value = null;
    update();
  }

  // Send audio message (updated)
  void sendAudioMessage(String audioPath, String senderId) {
    if (audioPath.isEmpty || _currentChatPartnerId.value.isEmpty) return;

    // Add haptic feedback
    HapticFeedback.mediumImpact();

    // Add to local UI
    final currentUser = Get.find<AuthController>().currentUser.value;
    messages.add(
      Message(
        isMe: true,
        type: MessageType.audio,
        userAvatar: _getFullImageUrl(currentUser?.image),
        userName: currentUser?.firstName ?? 'You',
        audioPath: audioPath,
      ),
    );

    // TODO: Upload audio to server and get URL, then send through socket
    // For now, we'll send a text message indicating audio
    _socketService.sendMessage(
      senderId: senderId,
      receiverId: _currentChatPartnerId.value,
      message: '🎤 Audio message sent',
    );

    // Clear the recorded audio path
    _path.value = '';
    update();
  }

  // ============================================================================
  // API INTEGRATION METHODS
  // ============================================================================

  /// Load messages from API with pagination
  Future<void> loadMessages({bool refresh = false}) async {
    if (_isLoadingMessages.value || _currentChatPartnerId.value.isEmpty) {
      print('❌ Cannot load messages:');
      print('   _isLoadingMessages: ${_isLoadingMessages.value}');
      print('   _currentChatPartnerId: "${_currentChatPartnerId.value}"');
      return;
    }

    if (refresh) {
      _currentPage.value = 1;
      messages.clear();
      _hasMoreMessages.value = true;
    }

    if (!_hasMoreMessages.value && !refresh) return;

    _isLoadingMessages.value = true;

    try {
      print('🔍 Debug loadMessages:');
      print('   partnerId: "${_currentChatPartnerId.value}"');
      print('   page: ${_currentPage.value}');

      final response = await _messageApiClient.getChatMessages(
        userId: _currentChatPartnerId.value,
        page: _currentPage.value,
        limit: 20,
      );

      if (response.success) {
        final List<ChatMessage> chatMessages = response.data;

        // Convert ChatMessage to Message objects for UI
        final List<Message> uiMessages = chatMessages.map((chatMsg) {
          final currentUserId =
              Get.find<AuthController>().currentUser.value?.id ?? '';
          final isMe = chatMsg.sender.id == currentUserId;

          final currentUser = Get.find<AuthController>().currentUser.value;
          return Message(
            text: chatMsg.message,
            isMe: isMe,
            type: chatMsg.images.isNotEmpty
                ? MessageType.image
                : MessageType.text,
            userAvatar: isMe
                ? _getFullImageUrl(
                    currentUser?.image,
                  ) // Current user's full image URL
                : _getFullImageUrl(
                    chatMsg.sender.image,
                  ), // Partner's full image URL
            userName: isMe
                ? currentUser?.firstName ?? 'You'
                : chatMsg.sender.fullName,
            imageUrl: chatMsg.images.isNotEmpty
                ? _getFullImageUrl(chatMsg.images.first)
                : null,
          );
        }).toList();

        if (refresh) {
          messages.assignAll(
            uiMessages.reversed.toList(),
          ); // Reverse for newest first
        } else {
          messages.addAll(uiMessages.reversed.toList());
        }

        print('✅ Loaded ${uiMessages.length} messages from API');

        _currentPage.value++;
        _hasMoreMessages.value = chatMessages.length >= 20;
      } else {
        print('❌ Failed to load messages: ${response.message}');

        // Show user-friendly error message
        if (response.message.contains('connected users') ||
            response.message.contains('403')) {
          _hasPermissionError.value = true;

          Get.snackbar(
            'Cannot Start Chat',
            'You can only chat with connected users. Please connect with this person first.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Get.theme.colorScheme.error,
            colorText: Get.theme.colorScheme.onError,
            duration: const Duration(seconds: 4),
            margin: const EdgeInsets.all(16),
          );

          // Navigate back since chat cannot proceed
          Get.back();
        } else {
          Get.snackbar(
            'Error',
            response.message,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Get.theme.colorScheme.error,
            colorText: Get.theme.colorScheme.onError,
            duration: const Duration(seconds: 3),
          );
        }
      }
    } catch (e) {
      print('❌ Error loading messages: $e');
    } finally {
      _isLoadingMessages.value = false;
    }
  }

  /// Send message with image via API
  Future<void> sendMessageWithImage(
    String messageText,
    String imagePath,
  ) async {
    if (_isSendingMessage.value) return;

    _isSendingMessage.value = true;

    try {
      final imageFile = File(imagePath);
      final response = await _messageApiClient.sendMessageWithImage(
        senderId: Get.find<AuthController>().currentUser.value?.id ?? '',
        receiverId: _currentChatPartnerId.value,
        message: messageText,
        imageFile: imageFile,
      );

      if (response.success) {
        // The message will be received via socket, no need to add manually
        print('Message sent successfully via API');
      }
    } catch (e) {
      print('Error sending message with image: $e');
    } finally {
      _isSendingMessage.value = false;
    }
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get socket connection status for debugging
  Map<String, dynamic> getSocketStatus() {
    return _socketService.getConnectionStatus();
  }

  /// Force reconnect socket
  void reconnectSocket() {
    _socketService.reconnect();
  }

  /// Start conversation with a user and load messages
  void startConversation(String partnerId, [String? partnerName]) {
    if (partnerId.isEmpty) {
      print('❌ Cannot start conversation: partnerId is empty');
      Get.snackbar(
        'Error',
        'Invalid user ID. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      Get.back();
      return;
    }

    print('🚀 Starting conversation with partnerId: "$partnerId"');

    // Check current user authentication
    final authController = Get.find<AuthController>();
    final currentUserId = authController.currentUser.value?.id;
    print('🔍 Current user ID: "$currentUserId"');

    if (currentUserId == null || currentUserId.isEmpty) {
      print('❌ Cannot start conversation: Current user not authenticated');
      Get.snackbar(
        'Authentication Error',
        'Please log in again to start chatting.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      Get.back();
      return;
    }

    // Set chat partner and initialize socket connection
    setChatPartner(partnerId, currentUserId);

    // Store partner name for message creation
    _currentPartnerName.value = partnerName ?? 'Partner';

    // Reset conversation state
    _currentPage.value = 1;
    _hasMoreMessages.value = true;
    messages.clear();

    // Load initial messages
    loadMessages(refresh: true);
  }
}
