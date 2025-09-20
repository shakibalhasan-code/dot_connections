# 🔌 API Integration Guide

This guide explains how to integrate Dot Connections with your backend API. The app is designed with a flexible architecture that makes it easy to replace mock data with real API endpoints.

## 📋 Table of Contents

- [Overview](#overview)
- [API Architecture](#api-architecture)
- [Authentication](#authentication)
- [Core Endpoints](#core-endpoints)
- [Real-time Features](#real-time-features)
- [File Uploads](#file-uploads)
- [Error Handling](#error-handling)
- [Testing](#testing)

## 🏗️ Overview

The app follows a repository pattern with service layers that abstract API calls. All network requests are handled through dedicated service classes that can be easily modified to connect to your backend.

### Current Architecture
```
UI Layer (Screens/Widgets)
       ↓
Controller Layer (GetX Controllers) 
       ↓
Service Layer (API Services)
       ↓
Network Layer (HTTP Client)
       ↓
Backend API
```

## 🔧 API Architecture

### Base Configuration

Update the API configuration in `lib/app/core/config/app_config.dart`:

```dart
class AppConfig {
  // API Settings
  static const String apiBaseUrl = 'https://your-api.com/v1';
  static const String apiKey = 'your-api-key';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Endpoints
  static const String authEndpoint = '/auth';
  static const String usersEndpoint = '/users';
  static const String matchesEndpoint = '/matches';
  static const String messagesEndpoint = '/messages';
  static const String uploadsEndpoint = '/uploads';
}
```

### HTTP Client Setup

Create a base API service in `lib/app/core/services/api_service.dart`:

```dart
import 'package:get/get.dart';
import 'package:dot_connections/app/core/config/app_config.dart';

class ApiService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = AppConfig.apiBaseUrl;
    httpClient.timeout = AppConfig.apiTimeout;
    
    // Add default headers
    httpClient.defaultContentType = 'application/json';
    httpClient.addRequestModifier<void>((request) {
      request.headers['Authorization'] = 'Bearer ${_getAuthToken()}';
      request.headers['X-API-Key'] = AppConfig.apiKey;
      return request;
    });
    
    // Add response interceptor
    httpClient.addResponseModifier((request, response) {
      _logResponse(request, response);
      return response;
    });
    
    super.onInit();
  }
  
  String _getAuthToken() {
    // Get stored auth token
    return GetStorage().read('auth_token') ?? '';
  }
  
  void _logResponse(Request request, Response response) {
    if (AppConfig.enableApiLogging) {
      print('${request.method} ${request.url}');
      print('Status: ${response.status}');
      print('Response: ${response.bodyString}');
    }
  }
}
```

## 🔐 Authentication

### Auth Service Implementation

Replace the mock authentication in `lib/app/core/services/auth_service.dart`:

```dart
class AuthService extends ApiService {
  
  // Login with email and password
  Future<ApiResponse<User>> login(String email, String password) async {
    try {
      final response = await post('/auth/login', {
        'email': email,
        'password': password,
        'device_id': await _getDeviceId(),
        'device_type': Platform.isAndroid ? 'android' : 'ios',
      });
      
      if (response.status.hasError) {
        return ApiResponse.error(response.statusText ?? 'Login failed');
      }
      
      final data = response.body;
      final user = User.fromJson(data['user']);
      final token = data['token'];
      
      // Store authentication token
      await GetStorage().write('auth_token', token);
      await GetStorage().write('user_data', user.toJson());
      
      return ApiResponse.success(user);
      
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  // Register new user
  Future<ApiResponse<User>> register(Map<String, dynamic> userData) async {
    try {
      final response = await post('/auth/register', userData);
      
      if (response.status.hasError) {
        return ApiResponse.error(response.statusText ?? 'Registration failed');
      }
      
      final data = response.body;
      final user = User.fromJson(data['user']);
      final token = data['token'];
      
      await GetStorage().write('auth_token', token);
      await GetStorage().write('user_data', user.toJson());
      
      return ApiResponse.success(user);
      
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  // Verify OTP
  Future<ApiResponse<bool>> verifyOtp(String phone, String otp) async {
    try {
      final response = await post('/auth/verify-otp', {
        'phone': phone,
        'otp': otp,
      });
      
      if (response.status.hasError) {
        return ApiResponse.error(response.statusText ?? 'OTP verification failed');
      }
      
      return ApiResponse.success(true);
      
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  // Logout
  Future<void> logout() async {
    try {
      await post('/auth/logout', {});
    } catch (e) {
      print('Logout API error: $e');
    } finally {
      // Clear local storage regardless of API success
      await GetStorage().remove('auth_token');
      await GetStorage().remove('user_data');
    }
  }
  
  Future<String> _getDeviceId() async {
    // Implement device ID generation
    return 'device_id_placeholder';
  }
}
```

### API Response Wrapper

Create a standardized response wrapper in `lib/app/models/api_response.dart`:

```dart
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, dynamic>? errors;
  
  ApiResponse.success(this.data) 
    : success = true, 
      message = null, 
      errors = null;
  
  ApiResponse.error(this.message, {this.errors}) 
    : success = false, 
      data = null;
  
  bool get isError => !success;
  bool get isSuccess => success;
}
```

## 👤 User Management API

### User Service Implementation

Replace mock data in `lib/app/core/services/user_service.dart`:

```dart
class UserService extends ApiService {
  
  // Get user profile
  Future<ApiResponse<User>> getUserProfile(String userId) async {
    try {
      final response = await get('/users/$userId');
      
      if (response.status.hasError) {
        return ApiResponse.error('Failed to load user profile');
      }
      
      final user = User.fromJson(response.body['data']);
      return ApiResponse.success(user);
      
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  // Update user profile
  Future<ApiResponse<User>> updateUserProfile(Map<String, dynamic> userData) async {
    try {
      final response = await put('/users/profile', userData);
      
      if (response.status.hasError) {
        return ApiResponse.error('Failed to update profile');
      }
      
      final user = User.fromJson(response.body['data']);
      return ApiResponse.success(user);
      
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  // Get nearby users
  Future<ApiResponse<List<User>>> getNearbyUsers({
    required double latitude,
    required double longitude,
    int radius = 50,
    int ageMin = 18,
    int ageMax = 100,
    String? gender,
  }) async {
    try {
      final response = await get('/users/nearby', query: {
        'lat': latitude,
        'lng': longitude,
        'radius': radius,
        'age_min': ageMin,
        'age_max': ageMax,
        if (gender != null) 'gender': gender,
      });
      
      if (response.status.hasError) {
        return ApiResponse.error('Failed to load nearby users');
      }
      
      final List<dynamic> usersJson = response.body['data'];
      final users = usersJson.map((json) => User.fromJson(json)).toList();
      
      return ApiResponse.success(users);
      
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  // Block user
  Future<ApiResponse<bool>> blockUser(String userId) async {
    try {
      final response = await post('/users/block', {'user_id': userId});
      
      if (response.status.hasError) {
        return ApiResponse.error('Failed to block user');
      }
      
      return ApiResponse.success(true);
      
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  // Report user
  Future<ApiResponse<bool>> reportUser(String userId, String reason, String? details) async {
    try {
      final response = await post('/users/report', {
        'user_id': userId,
        'reason': reason,
        'details': details,
      });
      
      if (response.status.hasError) {
        return ApiResponse.error('Failed to report user');
      }
      
      return ApiResponse.success(true);
      
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
}
```

## 💕 Matching System API

### Match Service Implementation

```dart
class MatchService extends ApiService {
  
  // Swipe on user (like/pass)
  Future<ApiResponse<MatchResult>> swipeUser(String userId, bool isLike) async {
    try {
      final response = await post('/matches/swipe', {
        'target_user_id': userId,
        'action': isLike ? 'like' : 'pass',
        'timestamp': DateTime.now().toIso8601String(),
      });
      
      if (response.status.hasError) {
        return ApiResponse.error('Swipe action failed');
      }
      
      final result = MatchResult.fromJson(response.body['data']);
      return ApiResponse.success(result);
      
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  // Get user matches
  Future<ApiResponse<List<Match>>> getMatches() async {
    try {
      final response = await get('/matches');
      
      if (response.status.hasError) {
        return ApiResponse.error('Failed to load matches');
      }
      
      final List<dynamic> matchesJson = response.body['data'];
      final matches = matchesJson.map((json) => Match.fromJson(json)).toList();
      
      return ApiResponse.success(matches);
      
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  // Unmatch user
  Future<ApiResponse<bool>> unmatchUser(String matchId) async {
    try {
      final response = await delete('/matches/$matchId');
      
      if (response.status.hasError) {
        return ApiResponse.error('Failed to unmatch user');
      }
      
      return ApiResponse.success(true);
      
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
}

class MatchResult {
  final bool isMatch;
  final String? matchId;
  final User? matchedUser;
  
  MatchResult({
    required this.isMatch,
    this.matchId,
    this.matchedUser,
  });
  
  factory MatchResult.fromJson(Map<String, dynamic> json) {
    return MatchResult(
      isMatch: json['is_match'] ?? false,
      matchId: json['match_id'],
      matchedUser: json['matched_user'] != null 
        ? User.fromJson(json['matched_user']) 
        : null,
    );
  }
}
```

## 💬 Chat & Messaging API

### Message Service Implementation

```dart
class MessageService extends ApiService {
  
  // Get conversations
  Future<ApiResponse<List<Conversation>>> getConversations() async {
    try {
      final response = await get('/messages/conversations');
      
      if (response.status.hasError) {
        return ApiResponse.error('Failed to load conversations');
      }
      
      final List<dynamic> conversationsJson = response.body['data'];
      final conversations = conversationsJson
          .map((json) => Conversation.fromJson(json))
          .toList();
      
      return ApiResponse.success(conversations);
      
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  // Get messages for conversation
  Future<ApiResponse<List<Message>>> getMessages(String conversationId, {int page = 1}) async {
    try {
      final response = await get('/messages/$conversationId', query: {
        'page': page,
        'limit': 50,
      });
      
      if (response.status.hasError) {
        return ApiResponse.error('Failed to load messages');
      }
      
      final List<dynamic> messagesJson = response.body['data'];
      final messages = messagesJson.map((json) => Message.fromJson(json)).toList();
      
      return ApiResponse.success(messages);
      
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  // Send text message
  Future<ApiResponse<Message>> sendMessage(String conversationId, String text) async {
    try {
      final response = await post('/messages/$conversationId', {
        'type': 'text',
        'content': text,
        'timestamp': DateTime.now().toIso8601String(),
      });
      
      if (response.status.hasError) {
        return ApiResponse.error('Failed to send message');
      }
      
      final message = Message.fromJson(response.body['data']);
      return ApiResponse.success(message);
      
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  // Send audio message
  Future<ApiResponse<Message>> sendAudioMessage(String conversationId, String audioPath) async {
    try {
      // Upload audio file first
      final uploadResponse = await uploadFile(audioPath, 'audio');
      if (uploadResponse.isError) {
        return ApiResponse.error(uploadResponse.message!);
      }
      
      final response = await post('/messages/$conversationId', {
        'type': 'audio',
        'content': uploadResponse.data!['url'],
        'duration': uploadResponse.data!['duration'],
        'timestamp': DateTime.now().toIso8601String(),
      });
      
      if (response.status.hasError) {
        return ApiResponse.error('Failed to send audio message');
      }
      
      final message = Message.fromJson(response.body['data']);
      return ApiResponse.success(message);
      
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  // Send image message
  Future<ApiResponse<Message>> sendImageMessage(String conversationId, String imagePath) async {
    try {
      // Upload image file first
      final uploadResponse = await uploadFile(imagePath, 'image');
      if (uploadResponse.isError) {
        return ApiResponse.error(uploadResponse.message!);
      }
      
      final response = await post('/messages/$conversationId', {
        'type': 'image',
        'content': uploadResponse.data!['url'],
        'thumbnail': uploadResponse.data!['thumbnail'],
        'timestamp': DateTime.now().toIso8601String(),
      });
      
      if (response.status.hasError) {
        return ApiResponse.error('Failed to send image message');
      }
      
      final message = Message.fromJson(response.body['data']);
      return ApiResponse.success(message);
      
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
  
  // Mark messages as read
  Future<ApiResponse<bool>> markAsRead(String conversationId, List<String> messageIds) async {
    try {
      final response = await post('/messages/$conversationId/read', {
        'message_ids': messageIds,
      });
      
      if (response.status.hasError) {
        return ApiResponse.error('Failed to mark messages as read');
      }
      
      return ApiResponse.success(true);
      
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
}
```

## 📤 File Upload Service

### Upload Service Implementation

```dart
class UploadService extends ApiService {
  
  // Upload file (image/audio)
  Future<ApiResponse<Map<String, dynamic>>> uploadFile(String filePath, String type) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return ApiResponse.error('File does not exist');
      }
      
      final formData = FormData({
        'file': MultipartFile(file, filename: path.basename(filePath)),
        'type': type,
      });
      
      final response = await post('/uploads', formData);
      
      if (response.status.hasError) {
        return ApiResponse.error('Upload failed');
      }
      
      return ApiResponse.success(response.body['data']);
      
    } catch (e) {
      return ApiResponse.error('Upload error: $e');
    }
  }
  
  // Upload multiple images
  Future<ApiResponse<List<String>>> uploadImages(List<String> imagePaths) async {
    try {
      final uploadFutures = imagePaths.map((path) => uploadFile(path, 'image'));
      final results = await Future.wait(uploadFutures);
      
      final urls = <String>[];
      for (final result in results) {
        if (result.isError) {
          return ApiResponse.error('One or more uploads failed');
        }
        urls.add(result.data!['url']);
      }
      
      return ApiResponse.success(urls);
      
    } catch (e) {
      return ApiResponse.error('Upload error: $e');
    }
  }
}
```

## 🔄 Real-time Features

### WebSocket Integration

For real-time messaging, implement WebSocket connection:

```dart
class WebSocketService extends GetxService {
  IOWebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _messageController = 
      StreamController.broadcast();
  
  Stream<Map<String, dynamic>> get messages => _messageController.stream;
  
  void connect(String userId, String authToken) {
    try {
      final uri = Uri.parse('${AppConfig.wsBaseUrl}/ws?user_id=$userId&token=$authToken');
      _channel = IOWebSocketChannel.connect(uri);
      
      _channel!.stream.listen(
        (data) {
          final message = json.decode(data);
          _messageController.add(message);
        },
        onError: (error) {
          print('WebSocket error: $error');
          _reconnect(userId, authToken);
        },
        onDone: () {
          print('WebSocket connection closed');
          _reconnect(userId, authToken);
        },
      );
      
    } catch (e) {
      print('WebSocket connection failed: $e');
    }
  }
  
  void sendMessage(Map<String, dynamic> message) {
    if (_channel != null) {
      _channel!.sink.add(json.encode(message));
    }
  }
  
  void _reconnect(String userId, String authToken) {
    Timer(Duration(seconds: 5), () {
      connect(userId, authToken);
    });
  }
  
  void disconnect() {
    _channel?.sink.close();
    _messageController.close();
  }
}
```

## ⚠️ Error Handling

### Error Response Models

```dart
class ApiError {
  final String code;
  final String message;
  final Map<String, dynamic>? details;
  
  ApiError({
    required this.code,
    required this.message,
    this.details,
  });
  
  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] ?? 'unknown_error',
      message: json['message'] ?? 'An unknown error occurred',
      details: json['details'],
    );
  }
}
```

### Global Error Handler

```dart
class ErrorHandler {
  static void handleApiError(Response response) {
    switch (response.status.code) {
      case 401:
        // Unauthorized - redirect to login
        Get.offAllNamed(AppRoutes.signIn);
        break;
      case 403:
        // Forbidden
        Get.snackbar('Access Denied', 'You do not have permission for this action');
        break;
      case 404:
        // Not found
        Get.snackbar('Not Found', 'The requested resource was not found');
        break;
      case 422:
        // Validation errors
        _handleValidationErrors(response.body);
        break;
      case 500:
        // Server error
        Get.snackbar('Server Error', 'Please try again later');
        break;
      default:
        Get.snackbar('Error', 'Something went wrong');
    }
  }
  
  static void _handleValidationErrors(dynamic body) {
    if (body['errors'] != null) {
      final errors = body['errors'] as Map<String, dynamic>;
      final firstError = errors.values.first;
      Get.snackbar('Validation Error', firstError.toString());
    }
  }
}
```

## 🧪 Testing API Integration

### Mock vs Real API Toggle

In your controllers, check for mock mode:

```dart
class FindController extends GetxController {
  final UserService _userService = Get.find<UserService>();
  
  Future<void> loadNearbyUsers() async {
    if (AppConfig.enableMockData) {
      // Use mock data for testing
      final mockUsers = MockDataService.instance.getUsers();
      cardList.value = mockUsers;
    } else {
      // Use real API
      final result = await _userService.getNearbyUsers(
        latitude: currentLatitude,
        longitude: currentLongitude,
      );
      
      if (result.isSuccess) {
        cardList.value = result.data!;
      } else {
        // Handle error
        Get.snackbar('Error', result.message ?? 'Failed to load users');
      }
    }
    update();
  }
}
```

### API Testing Tools

1. **Postman Collection**: Create API tests for all endpoints
2. **Unit Tests**: Test service methods with mock responses
3. **Integration Tests**: Test complete user flows

```dart
// Example test
testWidgets('should load nearby users from API', (WidgetTester tester) async {
  // Mock API response
  when(mockUserService.getNearbyUsers(any, any))
      .thenAnswer((_) async => ApiResponse.success([testUser]));
  
  // Test widget
  await tester.pumpWidget(MyApp());
  
  // Verify result
  expect(find.text(testUser.name), findsOneWidget);
});
```

## 📚 API Documentation Requirements

Your backend should provide:

1. **OpenAPI/Swagger Documentation**
2. **Authentication Flow Diagrams**  
3. **Rate Limiting Information**
4. **Error Code Reference**
5. **Webhook Documentation** (for real-time features)
6. **File Upload Specifications**

## 🔗 Next Steps

1. **Replace Mock Services**: Gradually replace each mock service with real API calls
2. **Test Thoroughly**: Ensure all API integrations work correctly
3. **Error Handling**: Implement comprehensive error handling
4. **Performance**: Optimize API calls with caching and pagination
5. **Security**: Implement proper authentication and data validation
6. **Documentation**: Keep API integration documented for future maintenance

For specific implementation help, refer to the individual service files and the main app configuration.