import 'dart:convert';
import 'package:dot_connections/app/core/constants/api_endpoints.dart';
import 'package:dot_connections/app/data/models/auth_models.dart';
import 'package:dot_connections/app/services/api_services.dart';
import 'package:http/http.dart' as http;

/// Auth API client that handles all authentication-related API calls
class AuthApiClient {
  /// Sends an OTP to the provided email for login or registration
  Future<AuthResponse> sendOtp(String email) async {
    try {
      print('🚀 Sending OTP to email: $email');
      print('🚀 Using API endpoint: ${ApiEndpoints.user}');

      final response = await ApiServices.postData(ApiEndpoints.user, {
        'email': email,
      });

      print('📥 Response status code: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      final jsonResponse = jsonDecode(response.body);
      return AuthResponse.fromJson(jsonResponse);
    } catch (e) {
      print('❌ Error sending OTP: $e');
      throw Exception('Failed to send OTP: $e');
    }
  }

  /// Verifies OTP and completes login/registration
  Future<AuthResponse> verifyOtp(OtpVerificationRequest request) async {
    try {
      print('🚀 Verifying OTP for email: ${request.email}');
      print('🚀 Using API endpoint: ${ApiEndpoints.verifyOtp}');

      final response = await ApiServices.postData(
        ApiEndpoints.verifyOtp,
        request.toJson(),
      );

      print('📥 Response status code: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      final jsonResponse = jsonDecode(response.body);
      return AuthResponse.fromJson(jsonResponse);
    } catch (e) {
      print('❌ Error verifying OTP: $e');
      throw Exception('Failed to verify OTP: $e');
    }
  }

  /// Gets the current user's profile
  Future<AuthResponse> getMyProfile() async {
    try {
      final response = await ApiServices.getData(ApiEndpoints.getMe);
      final jsonResponse = jsonDecode(response.body);
      return AuthResponse.fromJson(jsonResponse);
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Adds basic user fields after initial registration
  Future<AuthResponse> addUserFields(UserFields userFields) async {
    try {
      final response = await ApiServices.updateData(
        ApiEndpoints.addUserFields,
        userFields.toJson(),
      );

      final jsonResponse = jsonDecode(response.body);
      return AuthResponse.fromJson(jsonResponse);
    } catch (e) {
      throw Exception('Failed to add user fields: $e');
    }
  }

  /// Adds profile fields to complete user profile
  Future<AuthResponse> addProfileFields(ProfileFields profileFields) async {
    try {
      final response = await ApiServices.updateData(
        ApiEndpoints.addProfileFields,
        profileFields.toJson(),
      );

      final jsonResponse = jsonDecode(response.body);
      return AuthResponse.fromJson(jsonResponse);
    } catch (e) {
      throw Exception('Failed to add profile fields: $e');
    }
  }

  /// Updates user information
  Future<AuthResponse> updateUser(Map<String, dynamic> userData) async {
    try {
      final response = await ApiServices.postData(
        ApiEndpoints.updateUser,
        userData,
      );

      final jsonResponse = jsonDecode(response.body);
      return AuthResponse.fromJson(jsonResponse);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  /// Updates profile information
  Future<AuthResponse> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await ApiServices.postData(
        ApiEndpoints.updateProfile,
        profileData,
      );

      final jsonResponse = jsonDecode(response.body);
      return AuthResponse.fromJson(jsonResponse);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Updates which profile fields are hidden from others
  Future<AuthResponse> updateHiddenFields(
    Map<String, bool> hiddenFields,
  ) async {
    try {
      final response = await ApiServices.postData(
        ApiEndpoints.updateHiddenFields,
        {'hiddenFields': hiddenFields},
      );

      final jsonResponse = jsonDecode(response.body);
      return AuthResponse.fromJson(jsonResponse);
    } catch (e) {
      throw Exception('Failed to update hidden fields: $e');
    }
  }

  /// Deletes a profile image by index
  Future<AuthResponse> deleteProfileImage(int imageIndex) async {
    try {
      final response = await ApiServices.deleteData(
        '${ApiEndpoints.deleteProfileImage}/$imageIndex',
      );

      final jsonResponse = jsonDecode(response.body);
      return AuthResponse.fromJson(jsonResponse);
    } catch (e) {
      throw Exception('Failed to delete profile image: $e');
    }
  }

  /// Gets nearby users based on parameters
  Future<AuthResponse> getNearbyUsers(NearbyUserParams params) async {
    try {
      final queryParams = params.toQueryParams();
      final queryString = queryParams.isNotEmpty
          ? '?${Uri(queryParameters: queryParams).query}'
          : '';

      final response = await ApiServices.getData(
        '${ApiEndpoints.nearbyUsers}$queryString',
      );

      final jsonResponse = jsonDecode(response.body);
      return AuthResponse.fromJson(jsonResponse);
    } catch (e) {
      throw Exception('Failed to get nearby users: $e');
    }
  }

  /// Gets user by ID
  Future<AuthResponse> getUserById(String userId) async {
    try {
      final response = await ApiServices.getData(
        '${ApiEndpoints.getUserById}/$userId',
      );

      final jsonResponse = jsonDecode(response.body);
      return AuthResponse.fromJson(jsonResponse);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  /// Updates user status
  Future<AuthResponse> updateUserStatus(String userId, String status) async {
    try {
      final response = await ApiServices.postData(
        '${ApiEndpoints.updateUserStatus}/$userId/status',
        {'status': status},
      );

      final jsonResponse = jsonDecode(response.body);
      return AuthResponse.fromJson(jsonResponse);
    } catch (e) {
      throw Exception('Failed to update user status: $e');
    }
  }

  /// Deletes user account
  Future<AuthResponse> deleteAccount() async {
    try {
      final response = await ApiServices.deleteData(ApiEndpoints.deleteAccount);
      final jsonResponse = jsonDecode(response.body);
      return AuthResponse.fromJson(jsonResponse);
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  /// Gets all users (admin only)
  Future<AuthResponse> getAllUsers({
    int page = 1,
    int limit = 10,
    String? searchTerm,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (searchTerm != null) queryParams['searchTerm'] = searchTerm;
      if (sortBy != null) queryParams['sortBy'] = sortBy;
      if (sortOrder != null) queryParams['sortOrder'] = sortOrder;

      final queryString = '?${Uri(queryParameters: queryParams).query}';

      final response = await ApiServices.getData(
        '${ApiEndpoints.getAllUsers}$queryString',
      );

      final jsonResponse = jsonDecode(response.body);
      return AuthResponse.fromJson(jsonResponse);
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }

  /// Updates user role (admin only)
  Future<AuthResponse> updateUserRole(String userId, String role) async {
    try {
      final response = await ApiServices.postData(
        '${ApiEndpoints.updateUserRole}/$userId/role',
        {'role': role},
      );

      final jsonResponse = jsonDecode(response.body);
      return AuthResponse.fromJson(jsonResponse);
    } catch (e) {
      throw Exception('Failed to update user role: $e');
    }
  }
}
