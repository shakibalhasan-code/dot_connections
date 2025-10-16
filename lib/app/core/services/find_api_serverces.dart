import 'dart:convert';

import 'package:dot_connections/app/core/constants/api_endpoints.dart';
import 'package:dot_connections/app/data/models/user_model.dart';
import 'package:dot_connections/app/services/api_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FindApiServices {
  /// Fetches potential user matches from the API
  Future<List<UserModel>> fetchProfiles() async {
    try {
      final response = await ApiServices.getData(ApiEndpoints.getAllUsers);

      if (response.statusCode == 200) {
        // Successfully fetched profiles
        debugPrint(
          'Profiles API response received - status: ${response.statusCode}',
        );

        try {
          final Map<String, dynamic> responseData = jsonDecode(response.body);

          if (responseData['success'] == true &&
              responseData.containsKey('data')) {
            // Handle the data field properly regardless of whether it's a list or single object
            if (responseData['data'] is List) {
              // Convert the list of data to UserModel objects
              List<UserModel> profiles = [];

              for (var userJson in responseData['data']) {
                try {
                  if (userJson is Map<String, dynamic>) {
                    final UserModel user = UserModel.fromJson(userJson);
                    profiles.add(user);
                  }
                } catch (parseError) {
                  debugPrint('Error parsing individual user: $parseError');
                }
              }

              debugPrint('Successfully parsed ${profiles[0]} profiles');
              if (profiles.isNotEmpty) {
                debugPrint('First profile: ${profiles.first}');
              }

              return profiles;
            } else if (responseData['data'] is Map<String, dynamic>) {
              // Handle single user object
              try {
                final user = UserModel.fromJson(
                  responseData['data'] as Map<String, dynamic>,
                );
                debugPrint('Single user profile parsed: $user');
                return [user];
              } catch (e) {
                debugPrint('Error parsing single user: $e');
                return [];
              }
            }
          }

          debugPrint(
            'Invalid response format: ${responseData['message'] ?? "Unknown error"}',
          );
          return [];
        } catch (jsonError) {
          debugPrint('Error decoding JSON: $jsonError');
          return [];
        }
      } else {
        debugPrint(
          'Failed to fetch profiles: ${response.statusCode} - ${response.body}',
        );
        return [];
      }
    } catch (e) {
      debugPrint('Error in fetchProfiles method: $e');
      return []; // Return empty list instead of rethrowing to prevent app crashes
    }
  }
}
