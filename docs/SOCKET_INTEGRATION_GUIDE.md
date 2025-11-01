# 🔌 Socket Integration Guide for Dot Connections

## Overview

This guide explains how to implement real-time messaging and communication features using Socket.IO in the Dot Connections Flutter app. The implementation follows the backend socket API specification and provides a robust, scalable solution for real-time features.

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   UI Layer      │    │  Controller     │    │ Socket Service  │
│                 │    │  Layer          │    │                 │
│ - Conversation  │◄──►│ - Conversation  │◄──►│ - Connection    │
│   Screen        │    │   Controller    │    │ - Event Handling│
│ - Chat Widgets  │    │ - Auth         │    │ - State Mgmt    │
│                 │    │   Controller    │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                       │
                                               ┌─────────────────┐
                                               │  Backend API    │
                                               │                 │
                                               │ - Socket.IO     │
                                               │ - Message Store │
                                               │ - User Status   │
                                               └─────────────────┘
```

## Files Structure

```
lib/app/
├── core/services/
│   └── socket_service.dart              # Main socket service
├── controllers/
│   ├── conversation_controller.dart     # Updated with socket integration
│   └── auth_controller.dart            # Updated with socket registration
├── views/screens/
│   └── conversation_sample_screen.dart  # Example implementation
└── core/utils/
    └── app_bindings.dart               # Updated with socket service
```

## 1. Socket Service (SocketService)

### Features

- ✅ Automatic connection management with reconnection logic
- ✅ Event-driven architecture for real-time updates
- ✅ User registration and status management
- ✅ Typing indicators
- ✅ Message delivery and read receipts
- ✅ Active chat session tracking
- ✅ Error handling and logging

### Key Methods

#### Connection Management

```dart
// Get socket service instance
final socketService = SocketService.instance;

// Check connection status
bool isConnected = socketService.isConnected;

// Manual reconnection
socketService.reconnect();
```

#### User Registration

```dart
// Register user as online (called automatically after authentication)
socketService.registerUser('507f1f77bcf86cd799439011');
```

#### Messaging

```dart
// Send text message
socketService.sendMessage(
  senderId: 'user123',
  receiverId: 'user456',
  message: 'Hello! How are you?',
);

// Send image message
socketService.sendMessage(
  senderId: 'user123',
  receiverId: 'user456',
  imageUrl: '/uploads/images/photo-123.jpg',
);
```

#### Chat Session Management

```dart
// Set active chat (prevents duplicate notifications)
socketService.setActiveChat(
  currentUserId: 'user123',
  chatPartnerId: 'user456',
);

// Clear active chat when leaving conversation
socketService.clearActiveChat('user456');
```

#### Typing Indicators

```dart
// Start typing
socketService.startTyping(
  senderId: 'user123',
  receiverId: 'user456',
);

// Stop typing
socketService.stopTyping(
  senderId: 'user123',
  receiverId: 'user456',
);
```

#### Read Receipts

```dart
// Mark messages as read
socketService.markMessagesAsRead(
  senderId: 'user456',  // Who sent the messages
  receiverId: 'user123', // Who is reading them
);
```

## 2. Conversation Controller

### Updated Features

- ✅ Real-time message sending and receiving
- ✅ Automatic typing indicator management
- ✅ Message read status tracking
- ✅ Chat partner management
- ✅ Socket event handling
- ✅ Audio and image message support

### Usage in Controllers

```dart
class ConversationController extends GetxController {
  // Set chat partner when opening conversation
  void setChatPartner(String partnerId, String currentUserId) {
    // Automatically sets up socket listeners and active chat
  }

  // Send text message
  void sendTextMessage(String text, String senderId) {
    // Adds to local UI and sends via socket
  }

  // Handle incoming messages (automatic via socket events)
  void _onMessageReceived(dynamic data) {
    // Updates UI with new messages
  }
}
```

## 3. Integration with Authentication

The socket service automatically registers users when they log in:

```dart
// In AuthController._handleNavigation()
void _registerWithSocketService() {
  if (currentUser.value?.id != null) {
    final socketService = SocketService.instance;
    socketService.registerUser(currentUser.value!.id);
  }
}
```

## 4. UI Integration Example

### Conversation Screen Implementation

```dart
class ConversationScreen extends StatefulWidget {
  final String chatPartnerId;
  final String chatPartnerName;
  
  @override
  void initState() {
    super.initState();
    conversationController = Get.put(ConversationController());
    authController = Get.find<AuthController>();
    
    // Set up chat partner
    conversationController.setChatPartner(
      chatPartnerId,
      authController.currentUser.value?.id ?? '',
    );
  }
  
  @override
  void dispose() {
    // Important: Clear chat partner when leaving
    conversationController.clearChatPartner();
    super.dispose();
  }
}
```

### Real-time UI Updates

```dart
// Message list with real-time updates
Obx(() {
  return ListView.builder(
    itemCount: conversationController.messages.length,
    itemBuilder: (context, index) {
      final message = conversationController.messages[index];
      return _buildMessageBubble(message);
    },
  );
}),

// Typing indicator
Obx(() {
  if (conversationController.partnerIsTyping) {
    return Text('${partnerName} is typing...');
  }
  return SizedBox.shrink();
}),

// Connection status indicator
Obx(() {
  final socketService = SocketService.instance;
  return Icon(
    Icons.circle,
    color: socketService.isConnected ? Colors.green : Colors.red,
  );
}),
```

## 5. Socket Events Reference

### Client to Server Events

| Event | Description | Parameters |
|-------|-------------|------------|
| `register` | Register user as online | `userId: String` |
| `sendMessage` | Send message to user | `senderId, receiverId, message?, image?` |
| `markAsRead` | Mark messages as read | `senderId, receiverId` |
| `activeChat` | Set/clear active chat | `senderId?, receiverId` |
| `typing` | Start typing indicator | `senderId, receiverId` |
| `stop-typing` | Stop typing indicator | `senderId, receiverId` |

### Server to Client Events

| Event | Description | Data |
|-------|-------------|------|
| `message-received` | New message received | `senderId, receiverId, message?, image?, timestamp` |
| `message-sent` | Message sent confirmation | `messageId, status` |
| `messages-read` | Messages read confirmation | `senderId, receiverId, readCount` |
| `user-online` | User came online | `userId, timestamp` |
| `user-offline` | User went offline | `userId, timestamp` |
| `typing` | User started typing | `senderId, receiverId` |
| `stop-typing` | User stopped typing | `senderId, receiverId` |

## 6. Configuration

### Environment Setup

Ensure your `.env` file has the correct socket server URL:

```env
API_BASE_URL=https://your-api.com/v1
API_ROOT_URL=https://your-api.com  # Socket connects to this URL
```

### Dependency Injection

The socket service is registered in `AppBindings`:

```dart
// Core services - Initialize socket service early
Get.put(SocketService(), permanent: true);
```

## 7. Error Handling

### Connection Errors

```dart
// Listen for connection status changes
socketService.addEventListener('connect_error', (error) {
  // Handle connection errors
  debugPrint('Socket connection error: $error');
});
```

### Message Errors

```dart
// Handle message sending errors
socketService.addEventListener('error', (error) {
  // Show error message to user
  Get.snackbar('Error', 'Failed to send message');
});
```

## 8. Testing and Debugging

### Connection Status

```dart
// Get detailed connection status
Map<String, dynamic> status = socketService.getConnectionStatus();
print('Socket Status: $status');
```

### Debug Logging

All socket events are logged with appropriate emojis for easy debugging:

```
🔌 Initializing socket connection to: http://localhost:5000
✅ Socket connected: abc123
📤 Message sent: {senderId: user123, receiverId: user456, message: Hello}
📥 Message received: {senderId: user456, message: Hi there!}
⌨️ User typing: user456
```

## 9. Performance Considerations

### Memory Management

- Socket service uses `permanent: true` in dependency injection
- Event listeners are properly cleaned up in `onClose()`
- Message lists should implement pagination for large conversations

### Network Efficiency

- Automatic reconnection with exponential backoff
- Event batching for multiple rapid messages
- Typing indicators auto-stop after 3 seconds of inactivity

## 10. Security Notes

⚠️ **Important Security Considerations:**

1. **Authentication**: Socket connections should validate user tokens
2. **Rate Limiting**: Implement rate limiting for message sending
3. **Input Validation**: Sanitize all message content before displaying
4. **Image Uploads**: Implement proper image upload and validation before sending URLs

## 11. Production Deployment

### Environment Variables

```env
# Production
API_BASE_URL=https://api.dotconnections.com/v1
API_ROOT_URL=https://api.dotconnections.com
WS_BASE_URL=wss://api.dotconnections.com
```

### Build Configuration

```dart
// Update socket URL for production
String socketUrl = kDebugMode 
  ? 'http://localhost:5000' 
  : 'https://api.dotconnections.com';
```

## 12. Next Steps

1. **Image Upload Integration**: Implement proper image upload before sending image messages
2. **Audio Message Support**: Add audio file upload and playback
3. **Message Encryption**: Add end-to-end encryption for sensitive conversations  
4. **Push Notifications**: Integrate with FCM for background message notifications
5. **Message Persistence**: Add local database storage for offline message access
6. **Group Chats**: Extend socket events to support group conversations

## Troubleshooting

### Common Issues

1. **Socket not connecting**: Check API_ROOT_URL in `.env` file
2. **Messages not received**: Verify user registration with `registerUser()`
3. **Typing indicators not working**: Check active chat session setup
4. **Memory leaks**: Ensure `clearChatPartner()` is called in `dispose()`

### Debug Commands

```dart
// Force reconnection
SocketService.instance.reconnect();

// Check current user registration
print('Current user: ${SocketService.instance.currentUserId}');

// Verify active chat
print('Active chat: ${SocketService.instance.activeChat}');
```
