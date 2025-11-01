import 'package:dot_connections/app/core/constants/api_endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// Socket service for real-time communication
/// Handles connection, messaging, and user status management
class SocketService extends GetxController {
  static SocketService get instance => Get.find<SocketService>();

  IO.Socket? _socket;
  final RxBool _isConnected = false.obs;
  final RxString _currentUserId = ''.obs;
  final RxString _activeChat = ''.obs;

  // Getters
  bool get isConnected => _isConnected.value;
  String get currentUserId => _currentUserId.value;
  String get activeChat => _activeChat.value;
  IO.Socket? get socket => _socket;

  @override
  void onInit() {
    super.onInit();
    _initializeSocket();
  }

  @override
  void onClose() {
    _disconnect();
    super.onClose();
  }

  /// Initialize socket connection with proper configuration
  void _initializeSocket() {
    try {
      // Get the base URL without /api/v1 for socket connection
      String socketUrl = ApiEndpoints.rootUrl;

      debugPrint('🔌 Initializing socket connection to: $socketUrl');

      _socket = IO.io(
        socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionDelay(1000)
            .setReconnectionAttempts(5)
            .setTimeout(5000)
            .build(),
      );

      _setupEventListeners();
    } catch (e) {
      debugPrint('❌ Socket initialization failed: $e');
    }
  }

  /// Setup all socket event listeners
  void _setupEventListeners() {
    if (_socket == null) return;

    // Connection events
    _socket!.onConnect((_) {
      debugPrint('✅ Socket connected: ${_socket!.id}');
      _isConnected.value = true;

      // Register user if we have a current user ID
      if (_currentUserId.value.isNotEmpty) {
        registerUser(_currentUserId.value);
      }
    });

    _socket!.onDisconnect((_) {
      debugPrint('❌ Socket disconnected');
      _isConnected.value = false;
    });

    _socket!.onConnectError((error) {
      debugPrint('❌ Socket connection error: $error');
      _isConnected.value = false;
    });

    // Message events
    _socket!.on('message-received', _onMessageReceived);
    _socket!.on('message-sent', _onMessageSent);
    _socket!.on('messages-read', _onMessagesRead);
    _socket!.on('user-online', _onUserOnline);
    _socket!.on('user-offline', _onUserOffline);
    _socket!.on('typing', _onTyping);
    _socket!.on('stop-typing', _onStopTyping);

    // Error events
    _socket!.on('error', (error) {
      debugPrint('❌ Socket error: $error');
    });
  }

  /// Register user as online when they connect
  void registerUser(String userId) {
    if (_socket == null || !_isConnected.value) {
      debugPrint('⚠️ Cannot register user: Socket not connected');
      return;
    }

    _currentUserId.value = userId;
    _socket!.emit('register', userId);
    debugPrint('👤 User registered: $userId');
  }

  /// Send a message to another user
  void sendMessage({
    required String senderId,
    required String receiverId,
    String? message,
    String? imageUrl,
  }) {
    if (_socket == null || !_isConnected.value) {
      debugPrint('⚠️ Cannot send message: Socket not connected');
      return;
    }

    if ((message == null || message.isEmpty) &&
        (imageUrl == null || imageUrl.isEmpty)) {
      debugPrint('⚠️ Cannot send message: Both message and image are empty');
      return;
    }

    final messageData = {
      'senderId': senderId,
      'receiverId': receiverId,
      if (message != null && message.isNotEmpty) 'message': message,
      if (imageUrl != null && imageUrl.isNotEmpty) 'image': imageUrl,
      'timestamp': DateTime.now().toIso8601String(),
    };

    _socket!.emit('sendMessage', messageData);
    debugPrint('📤 Message sent: $messageData');
  }

  /// Mark messages as read
  void markMessagesAsRead({
    required String senderId,
    required String receiverId,
  }) {
    if (_socket == null || !_isConnected.value) {
      debugPrint('⚠️ Cannot mark messages as read: Socket not connected');
      return;
    }

    final data = {'senderId': senderId, 'receiverId': receiverId};

    _socket!.emit('markAsRead', data);
    debugPrint('📖 Marked messages as read: $data');
  }

  /// Set active chat session
  void setActiveChat({
    required String currentUserId,
    required String chatPartnerId,
  }) {
    if (_socket == null || !_isConnected.value) {
      debugPrint('⚠️ Cannot set active chat: Socket not connected');
      return;
    }

    _activeChat.value = chatPartnerId;

    final data = {'senderId': currentUserId, 'receiverId': chatPartnerId};

    _socket!.emit('activeChat', data);
    debugPrint('💬 Active chat set: $data');
  }

  /// Clear active chat session
  void clearActiveChat(String chatPartnerId) {
    if (_socket == null || !_isConnected.value) {
      debugPrint('⚠️ Cannot clear active chat: Socket not connected');
      return;
    }

    _activeChat.value = '';

    final data = {'receiverId': chatPartnerId};

    _socket!.emit('activeChat', data);
    debugPrint('❌ Active chat cleared for: $chatPartnerId');
  }

  /// Send typing indicator
  void startTyping({required String senderId, required String receiverId}) {
    if (_socket == null || !_isConnected.value) return;

    _socket!.emit('typing', {'senderId': senderId, 'receiverId': receiverId});
  }

  /// Stop typing indicator
  void stopTyping({required String senderId, required String receiverId}) {
    if (_socket == null || !_isConnected.value) return;

    _socket!.emit('stop-typing', {
      'senderId': senderId,
      'receiverId': receiverId,
    });
  }

  /// Manually connect socket
  void connect() {
    if (_socket != null && !_isConnected.value) {
      _socket!.connect();
      debugPrint('🔌 Socket connection requested');
    }
  }

  /// Disconnect socket
  void _disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      _isConnected.value = false;
      debugPrint('🔌 Socket disconnected and disposed');
    }
  }

  /// Reconnect socket
  void reconnect() {
    _disconnect();
    _initializeSocket();
    debugPrint('🔄 Socket reconnection initiated');
  }

  // Event handlers for incoming socket events
  void _onMessageReceived(dynamic data) {
    debugPrint('📥 SocketService: Message received: $data');
    debugPrint(
      '📥 Broadcasting to ${_eventListeners['message-received']?.length ?? 0} listeners',
    );
    // Emit to other parts of the app
    Get.find<SocketService>()._broadcastEvent('message-received', data);
  }

  void _onMessageSent(dynamic data) {
    debugPrint('✅ Message sent confirmation: $data');
    Get.find<SocketService>()._broadcastEvent('message-sent', data);
  }

  void _onMessagesRead(dynamic data) {
    debugPrint('📖 Messages read confirmation: $data');
    Get.find<SocketService>()._broadcastEvent('messages-read', data);
  }

  void _onUserOnline(dynamic data) {
    debugPrint('🟢 User online: $data');
    Get.find<SocketService>()._broadcastEvent('user-online', data);
  }

  void _onUserOffline(dynamic data) {
    debugPrint('🔴 User offline: $data');
    Get.find<SocketService>()._broadcastEvent('user-offline', data);
  }

  void _onTyping(dynamic data) {
    debugPrint('⌨️ User typing: $data');
    Get.find<SocketService>()._broadcastEvent('typing', data);
  }

  void _onStopTyping(dynamic data) {
    debugPrint('⌨️ User stopped typing: $data');
    Get.find<SocketService>()._broadcastEvent('stop-typing', data);
  }

  // Internal event broadcasting system for other controllers to listen
  final Map<String, List<Function(dynamic)>> _eventListeners = {};

  void addEventListener(String event, Function(dynamic) callback) {
    if (!_eventListeners.containsKey(event)) {
      _eventListeners[event] = [];
    }
    _eventListeners[event]!.add(callback);
    debugPrint(
      '👂 Event listener added for "$event". Total listeners: ${_eventListeners[event]!.length}',
    );
  }

  void removeEventListener(String event, Function(dynamic) callback) {
    _eventListeners[event]?.remove(callback);
  }

  void _broadcastEvent(String event, dynamic data) {
    debugPrint(
      '📡 Broadcasting event "$event" to ${_eventListeners[event]?.length ?? 0} listeners',
    );

    if (_eventListeners.containsKey(event)) {
      for (final callback in _eventListeners[event]!) {
        try {
          callback(data);
        } catch (e) {
          debugPrint('❌ Error in event callback for $event: $e');
        }
      }
    } else {
      debugPrint('⚠️ No listeners registered for event: $event');
    }
  }

  /// Get socket connection status for debugging
  Map<String, dynamic> getConnectionStatus() {
    return {
      'isConnected': _isConnected.value,
      'socketId': _socket?.id,
      'currentUserId': _currentUserId.value,
      'activeChat': _activeChat.value,
      'socketConnected': _socket?.connected ?? false,
    };
  }
}
