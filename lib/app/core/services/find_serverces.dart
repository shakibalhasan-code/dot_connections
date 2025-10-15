import 'dart:convert';

import 'package:dot_connections/app/core/constants/api_endpoints.dart';
import 'package:dot_connections/app/data/models/user_model.dart';
import 'package:dot_connections/app/services/api_services.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class FindServices {
  Future<List<UserModel>> fetchProfiles() async {
    try {
      final response = await ApiServices.getData(ApiEndpoints.getAllUsers);
      if (response.statusCode == 200) {
        // Successfully fetched profiles
        print('Profiles fetched successfully: ${response.body}');

        final data = jsonDecode(response.body);
        final List<UserModel> profiles = (data as List)
            .map((json) => UserModel.fromJson(json))
            .toList();

        debugPrint('Parsed profiles: $profiles');
        return profiles;
      } else {
        debugPrint(
          'Failed to fetch profiles: ${response.statusCode} - ${response.body}',
        );
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching profiles: $e');
      rethrow; // Rethrow the error for further handling
    }
  }
}
