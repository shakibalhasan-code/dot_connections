import 'dart:convert';
import 'dart:io';
import 'package:dot_connections/app/core/constants/api_endpoints.dart';
import 'package:dot_connections/app/services/api_services.dart';
import 'package:dot_connections/app/core/helper/pref_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

/// User model for chat messages
class ChatUser {
  final String id;
  final String firstName;
  final String lastName;
  final String? image;

  ChatUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.image,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      image: json['image'],
    );
  }

  String get fullName => '$firstName $lastName';
}

/// Individual chat message model
class ChatMessage {
  final String id;
  final ChatUser sender;
  final ChatUser receiver;
  final String message;
  final List<String> images;
  final String messageType;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? readAt;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.message,
    required this.images,
    required this.messageType,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    this.readAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'] ?? '',
      sender: ChatUser.fromJson(json['sender'] ?? {}),
      receiver: ChatUser.fromJson(json['receiver'] ?? {}),
      message: json['message'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      messageType: json['messageType'] ?? 'text',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
    );
  }
}

/// Chat list item model
class ChatListItem {
  final String id;
  final ChatUser participant;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isRead;

  ChatListItem({
    required this.id,
    required this.participant,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isRead,
  });

  factory ChatListItem.fromJson(Map<String, dynamic> json) {
    return ChatListItem(
      id: json['_id'] ?? '',
      participant: ChatUser.fromJson(json['participant'] ?? {}),
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: DateTime.parse(
        json['lastMessageTime'] ?? DateTime.now().toIso8601String(),
      ),
      unreadCount: json['unreadCount'] ?? 0,
      isRead: json['isRead'] ?? false,
    );
  }
}

/// API response model for chat messages
class ChatMessagesResponse {
  final bool success;
  final String message;
  final List<ChatMessage> data;
  final MessageMeta meta;

  ChatMessagesResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory ChatMessagesResponse.fromJson(Map<String, dynamic> json) {
    return ChatMessagesResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => ChatMessage.fromJson(item))
              .toList() ??
          [],
      meta: MessageMeta.fromJson(json['meta'] ?? {}),
    );
  }
}

/// API response model for chat list
class ChatListResponse {
  final bool success;
  final String message;
  final List<ChatListItem> data;

  ChatListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ChatListResponse.fromJson(Map<String, dynamic> json) {
    return ChatListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => ChatListItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

/// Individual message data model
class MessageData {
  final String id;
  final MessageUser sender;
  final MessageUser receiver;
  final String message;
  final String? image;
  final String messageType;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  MessageData({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.message,
    this.image,
    required this.messageType,
    required this.isRead,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      id: json['_id'] ?? '',
      sender: MessageUser.fromJson(json['sender'] ?? {}),
      receiver: MessageUser.fromJson(json['receiver'] ?? {}),
      message: json['message'] ?? '',
      image: json['image'],
      messageType: json['messageType'] ?? 'text',
      isRead: json['isRead'] ?? false,
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  /// Get full image URL if image is a relative path
  String? get fullImageUrl {
    if (image == null || image!.isEmpty) return null;
    if (image!.startsWith('http')) return image;
    return '${ApiEndpoints.rootUrl}$image';
  }
}

/// User data in message
class MessageUser {
  final String id;
  final String firstName;
  final String lastName;
  final String? image;

  MessageUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.image,
  });

  factory MessageUser.fromJson(Map<String, dynamic> json) {
    return MessageUser(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      image: json['image'],
    );
  }

  String get fullName => '$firstName $lastName'.trim();

  /// Get full image URL if image is a relative path
  String? get fullImageUrl {
    if (image == null || image!.isEmpty) return null;
    if (image!.startsWith('http')) return image;
    return '${ApiEndpoints.rootUrl}$image';
  }
}

/// Pagination metadata
class MessageMeta {
  final int page;
  final int limit;
  final int total;
  final int totalPage;

  MessageMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPage,
  });

  factory MessageMeta.fromJson(Map<String, dynamic> json) {
    return MessageMeta(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 50,
      total: json['total'] ?? 0,
      totalPage: json['totalPage'] ?? 1,
    );
  }
}

/// Single message response (for sending messages)
class SingleMessageResponse {
  final bool success;
  final String message;
  final MessageData data;

  SingleMessageResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SingleMessageResponse.fromJson(Map<String, dynamic> json) {
    return SingleMessageResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: MessageData.fromJson(json['data']),
    );
  }
}

/// Message API client for handling all message-related API calls
class MessageApiClient {
  /// Get chat messages with a specific user
  Future<ChatMessagesResponse> getChatMessages({
    required String userId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      // Add validation for empty user ID
      if (userId.isEmpty) {
        debugPrint('❌ Cannot fetch messages: userId is empty');
        return ChatMessagesResponse(
          success: false,
          message: 'Invalid user ID provided',
          data: [],
          meta: MessageMeta(page: 1, limit: limit, total: 0, totalPage: 1),
        );
      }

      debugPrint('📥 Fetching chat messages with user: $userId (page: $page)');

      final url =
          '${ApiEndpoints.getChatMessages(userId)}?page=$page&limit=$limit';

      debugPrint('🌐 API URL: $url');

      final response = await ApiServices.getData(url);

      debugPrint('📥 Messages API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final messageResponse = ChatMessagesResponse.fromJson(jsonResponse);

        debugPrint(
          '📥 Successfully fetched ${messageResponse.data.length} messages',
        );
        return messageResponse;
      } else {
        debugPrint('❌ Failed to fetch messages: ${response.statusCode}');
        debugPrint('📥 Response body: ${response.body}');

        // Try to parse error message from response
        String errorMessage =
            'Failed to fetch messages: ${response.statusCode}';
        try {
          final errorResponse = jsonDecode(response.body);
          if (errorResponse['message'] != null) {
            errorMessage = errorResponse['message'];
          }
        } catch (e) {
          debugPrint('Could not parse error response: $e');
        }

        return ChatMessagesResponse(
          success: false,
          message: errorMessage,
          data: [],
          meta: MessageMeta(page: 1, limit: limit, total: 0, totalPage: 1),
        );
      }
    } catch (e) {
      debugPrint('❌ Error fetching messages: $e');
      return ChatMessagesResponse(
        success: false,
        message: 'Error fetching messages: $e',
        data: [],
        meta: MessageMeta(page: 1, limit: limit, total: 0, totalPage: 1),
      );
    }
  }

  /// Get chat list
  Future<ChatListResponse> getChatList() async {
    try {
      debugPrint('📥 Fetching chat list...');

      final url = ApiEndpoints.getChatList;

      debugPrint('🌐 API URL: $url');

      final response = await ApiServices.getData(url);

      debugPrint('📥 Chat list API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final chatListResponse = ChatListResponse.fromJson(jsonResponse);

        debugPrint(
          '📥 Successfully fetched ${chatListResponse.data.length} chats',
        );
        return chatListResponse;
      } else {
        debugPrint('❌ Failed to fetch chat list: ${response.statusCode}');
        debugPrint('📥 Response body: ${response.body}');
        return ChatListResponse(
          success: false,
          message: 'Failed to fetch chat list: ${response.statusCode}',
          data: [],
        );
      }
    } catch (e) {
      debugPrint('❌ Error fetching chat list: $e');
      return ChatListResponse(
        success: false,
        message: 'Error fetching chat list: $e',
        data: [],
      );
    }
  }

  /// Send message with image using multipart/form-data
  Future<SingleMessageResponse> sendMessageWithImage({
    required String senderId,
    required String receiverId,
    required String message,
    required File imageFile,
  }) async {
    try {
      debugPrint('📤 Sending message with image: $senderId → $receiverId');

      final url = ApiEndpoints.sendMessageWithImage;
      final uri = Uri.parse(url);

      // Create multipart request
      final request = http.MultipartRequest('POST', uri);

      // Add headers (including auth token)
      final token = await SharedPreferencesHelper.getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add JSON data
      final jsonData = {
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
      };
      request.fields['data'] = jsonEncode(jsonData);

      // Add image file
      final mimeType = lookupMimeType(imageFile.path);
      final multipartFile = await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: mimeType != null ? MediaType.parse(mimeType) : null,
      );
      request.files.add(multipartFile);

      debugPrint('📤 Sending multipart request to: $url');
      debugPrint('📤 Request headers: ${request.headers}');
      debugPrint('📤 Request fields: ${request.fields}');
      debugPrint('📤 Image file: ${imageFile.path}');

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint(
        '📤 Image message API response status: ${response.statusCode}',
      );
      debugPrint('📤 Image message API response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final jsonResponse = jsonDecode(response.body);
          debugPrint('📤 Parsed JSON response: $jsonResponse');

          final messageResponse = SingleMessageResponse.fromJson(jsonResponse);
          debugPrint('✅ Successfully sent message with image');
          return messageResponse;
        } catch (parseError) {
          debugPrint('❌ Failed to parse JSON response: $parseError');
          debugPrint('📤 Raw response body: ${response.body}');

          // Return a simplified success response if parsing fails but status is success
          return SingleMessageResponse(
            success: true,
            message: 'Message sent successfully',
            data: MessageData(
              id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
              sender: MessageUser(
                id: senderId,
                firstName: 'User',
                lastName: '',
                image: null,
              ),
              receiver: MessageUser(
                id: receiverId,
                firstName: 'User',
                lastName: '',
                image: null,
              ),
              message: message,
              image: null, // Will be updated when we get proper response
              messageType: 'image',
              isRead: false,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
        }
      } else {
        debugPrint(
          '❌ Failed to send message with image: ${response.statusCode}',
        );
        throw Exception(
          'Failed to send message with image: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('❌ Error sending message with image: $e');
      throw Exception('Error sending message with image: $e');
    }
  }

  /// Send text-only message (if you have a separate endpoint for this)
  /// This can be used as a fallback or for text-only messages
  Future<SingleMessageResponse> sendTextMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    try {
      debugPrint('📤 Sending text message: $senderId → $receiverId');

      // You can create a dedicated text message endpoint or reuse the image endpoint
      // For now, I'll assume you might have a separate endpoint
      final url = '${ApiEndpoints.baseUrl}/message/send'; // Adjust as needed

      final data = {
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
      };

      final response = await ApiServices.postData(url, data);

      debugPrint('📤 Text message API response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final messageResponse = SingleMessageResponse.fromJson(jsonResponse);

        debugPrint('✅ Successfully sent text message');
        return messageResponse;
      } else {
        debugPrint('❌ Failed to send text message: ${response.statusCode}');
        throw Exception('Failed to send text message: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error sending text message: $e');
      throw Exception('Error sending text message: $e');
    }
  }

  /// Mark messages as read (if you have a separate endpoint for this)
  Future<bool> markMessagesAsRead({
    required String senderId,
    required String receiverId,
  }) async {
    try {
      debugPrint('📖 Marking messages as read: $senderId → $receiverId');

      // Adjust URL based on your actual API
      final url = '${ApiEndpoints.baseUrl}/message/mark-read';

      final data = {'senderId': senderId, 'receiverId': receiverId};

      final response = await ApiServices.postData(url, data);

      if (response.statusCode == 200) {
        debugPrint('✅ Successfully marked messages as read');
        return true;
      } else {
        debugPrint('❌ Failed to mark messages as read: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error marking messages as read: $e');
      return false;
    }
  }

  /// Get conversation list (if you have an endpoint for this)
  Future<List<MessageData>> getConversations(String userId) async {
    try {
      debugPrint('📋 Fetching conversations for user: $userId');

      final url = '${ApiEndpoints.baseUrl}/message/conversations/$userId';
      final response = await ApiServices.getData(url);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Assuming the response has a similar structure to messages
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          final List<dynamic> conversationsData = jsonResponse['data'];
          final conversations = conversationsData
              .map((item) => MessageData.fromJson(item))
              .toList();

          debugPrint(
            '📋 Successfully fetched ${conversations.length} conversations',
          );
          return conversations;
        }
      }

      debugPrint('❌ Failed to fetch conversations: ${response.statusCode}');
      return [];
    } catch (e) {
      debugPrint('❌ Error fetching conversations: $e');
      return [];
    }
  }
}
