import 'dart:convert';

import 'package:dot_connections/app/core/constants/api_endpoints.dart';
import 'package:dot_connections/app/core/helper/widget_helper.dart';
import 'package:dot_connections/app/data/models/user_model.dart';
import 'package:dot_connections/app/data/models/potential_matches_response.dart';
import 'package:dot_connections/app/services/api_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class FindApiServices {
  /// Fetches potential user matches from the API
  Future<List<UserModel>> fetchProfiles() async {
    try {
      final response = await ApiServices.getData(
        ApiEndpoints.getPotentialMatches,
      );

      if (response.statusCode == 200) {
        // Successfully fetched profiles
        debugPrint(
          'Potential matches API response received - status: ${response.statusCode}',
        );

        try {
          final Map<String, dynamic> responseData = jsonDecode(response.body);

          if (responseData['success'] == true &&
              responseData.containsKey('data')) {
            debugPrint('Response meta: ${responseData['meta']}');
            debugPrint('Response message: ${responseData['message']}');

            // Parse using the new PotentialMatchesResponse model
            final potentialMatchesResponse = PotentialMatchesResponse.fromJson(
              responseData,
            );

            debugPrint(
              'Total matches found: ${potentialMatchesResponse.meta.total}',
            );
            debugPrint('Current page: ${potentialMatchesResponse.meta.page}');
            debugPrint(
              'Matches on this page: ${potentialMatchesResponse.data.length}',
            );

            // Convert PotentialMatch objects to UserModel objects
            List<UserModel> profiles = [];

            for (var potentialMatch in potentialMatchesResponse.data) {
              try {
                final UserModel user = potentialMatch.toUserModel();
                profiles.add(user);
                debugPrint(
                  'Successfully converted user: ${user.name}, Age: ${user.age}, Distance: ${user.distance}km',
                );
                debugPrint('User interests: ${user.interests}');
                debugPrint('User photos: ${user.photoUrls.length} photos');
              } catch (parseError) {
                debugPrint(
                  'Error converting potential match to user model: $parseError',
                );
                debugPrint('Potential match: ${potentialMatch.fullName}');
              }
            }

            debugPrint(
              'Successfully parsed ${profiles.length} profiles from potential matches API',
            );
            if (profiles.isNotEmpty) {
              debugPrint(
                'First profile: ${profiles.first.name} (${profiles.first.age}), Distance: ${profiles.first.distance}km',
              );
              debugPrint('Profile photos: ${profiles.first.photoUrls}');
              debugPrint('Profile interests: ${profiles.first.interests}');
              debugPrint('Profile bio: ${profiles.first.bio}');
            }

            return profiles;
          }

          debugPrint(
            'Invalid response format: ${responseData['message'] ?? "Unknown error"}',
          );
          return [];
        } catch (jsonError) {
          debugPrint('Error decoding JSON: $jsonError');
          debugPrint('Response body: ${response.body}');
          return [];
        }
      } else {
        debugPrint(
          'Failed to fetch potential matches: ${response.statusCode} - ${response.body}',
        );
        return [];
      }
    } catch (e) {
      debugPrint('Error in fetchProfiles method: $e');
      return []; // Return empty list instead of rethrowing to prevent app crashes
    }
  }

  Future<void> swipeActions({
    required String toUserId,
    required bool isLiked,
    required String profileName,
  }) async {
    try {
      final response = await ApiServices.postData(ApiEndpoints.doLike, {
        "toUserId": toUserId,
        "action": isLiked ? "love" : "skip",
      });

      if (response.statusCode == 200) {
        WidgetHelper.showToast(
          message: isLiked
              ? 'You liked $profileName'
              : 'You skipped $profileName',
          status: isLiked ? Status.success : Status.warning,
          toastContext: Get.context!,
        );
        debugPrint('Like action successful: ${response.body}');
      } else {
        debugPrint(
          'Failed to perform like action: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Error in doLike method: $e');
    }
  }
}
