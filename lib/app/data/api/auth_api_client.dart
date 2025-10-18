import 'dart:convert';
import 'package:dot_connections/app/core/constants/api_endpoints.dart';
import 'package:dot_connections/app/data/models/auth_models.dart';
import 'package:dot_connections/app/data/models/user_personal_data.dart';
import 'package:dot_connections/app/services/api_services.dart';
import 'package:flutter/material.dart';
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
  Future<AuthResponse> addProfileFields(UserPersonalData profileFields) async {
    try {
      debugPrint('🚀 Adding profile fields: ${profileFields.toJson()}');

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

  /// Updates user information using FormData (PATCH method)
  Future<AuthResponse> updateUserWithFormData(
    Map<String, dynamic> userData,
  ) async {
    try {
      print('🚀 Updating user with FormData: $userData');

      final response = await ApiServices.patchFormData(
        ApiEndpoints.updateUser,
        userData,
      );

      print('📥 Response status code: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      final jsonResponse = jsonDecode(response.body);
      return AuthResponse.fromJson(jsonResponse);
    } catch (e) {
      print('❌ Error updating user: $e');
      throw Exception('Failed to update user: $e');
    }
  }

  /// Updates only user's first name and last name
  Future<AuthResponse> updateUserName(String firstName, String lastName) async {
    try {
      print('🚀 Updating user name: $firstName $lastName');

      // Make sure both fields are non-empty strings
      if (firstName.isEmpty || lastName.isEmpty) {
        throw Exception('First name and last name cannot be empty');
      }

      final userData = {'firstName': firstName, 'lastName': lastName};

      // For debugging - show what we're sending
      print('🚀 Update user data payload: $userData');

      final response = await ApiServices.updateData(ApiEndpoints.updateUser, {
        'data': userData,
      });

      print('📥 Response status code: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      final jsonResponse = jsonDecode(response.body);
      return AuthResponse.fromJson(jsonResponse);
    } catch (e) {
      print('❌ Error updating user name: $e');
      throw Exception('Failed to update user name: $e');
    }
  }

  /// Updates only user's phone number
  Future<AuthResponse> updateUserPhone(String phoneNumber) async {
    try {
      print('🚀 Updating user phone number: $phoneNumber');

      // Make sure the phone number is not empty
      if (phoneNumber.isEmpty) {
        throw Exception('Phone number cannot be empty');
      }

      final userData = {'phoneNumber': phoneNumber};

      // For debugging - show what we're sending
      print('🚀 Update phone data payload: $userData');

      // Try using the regular postData method instead of patchFormData
      // The server might be expecting JSON instead of FormData for this endpoint
      final response = await ApiServices.updateData(ApiEndpoints.updateUser, {
        "data": userData,
      });

      print('📥 Response status code: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      final jsonResponse = jsonDecode(response.body);
      return AuthResponse.fromJson(jsonResponse);
    } catch (e) {
      print('❌ Error updating user phone: $e');
      throw Exception('Failed to update user phone: $e');
    }
  }

  /// Updates user's profile image
  Future<AuthResponse> updateUserImage(String imagePath) async {
    try {
      print('🚀 Updating user image from: $imagePath');

      // For image upload, we need to keep using FormData with multipart
      // Empty fields since we're only sending the image
      final fields = <String, dynamic>{};

      // File mapping - 'image' is the field name expected by the API
      final files = {'image': imagePath};

      print('🚀 Uploading image with path: $imagePath');

      final response = await ApiServices.patchFormDataWithFile(
        ApiEndpoints.updateUser,
        fields,
        files,
      );

      print('📥 Response status code: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      // Check if the response body is empty or invalid
      if (response.body.isEmpty || response.body.trim() == 'undefined') {
        print('❌ Received empty or invalid response body');
        return AuthResponse(
          success: false,
          message: 'Received empty response from server',
        );
      }

      final jsonResponse = jsonDecode(response.body);
      return AuthResponse.fromJson(jsonResponse);
    } catch (e) {
      print('❌ Error updating user image: $e');
      throw Exception('Failed to update user image: $e');
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
