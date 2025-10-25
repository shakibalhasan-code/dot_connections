import 'dart:convert';
import 'package:dot_connections/app/core/constants/api_endpoints.dart';
import 'package:dot_connections/app/data/models/nearby_user_model.dart';
import 'package:dot_connections/app/services/api_services.dart';

/// Match API client that handles all match-related API calls
class MatchApiClient {
  /// Fetches nearby users within the specified radius
  Future<NearbyUsersResponse> getNearbyUsers({int radius = 100}) async {
    try {
      print('🚀 Fetching nearby users with radius: $radius');
      print(
        '🚀 Using API endpoint: ${ApiEndpoints.nearbyUsers}?radius=$radius',
      );

      final response = await ApiServices.getData(
        '${ApiEndpoints.nearbyUsers}?radius=$radius',
      );

      print('📥 Response status code: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return NearbyUsersResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to fetch nearby users: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching nearby users: $e');
      throw Exception('Failed to fetch nearby users: $e');
    }
  }

  /// Fetches nearby users with custom parameters
  Future<NearbyUsersResponse> getNearbyUsersWithParams({
    int radius = 100,
    double? latitude,
    double? longitude,
    int? ageMin,
    int? ageMax,
    String? gender,
    String? interestedIn,
  }) async {
    try {
      final queryParams = <String, String>{'radius': radius.toString()};

      if (latitude != null) queryParams['latitude'] = latitude.toString();
      if (longitude != null) queryParams['longitude'] = longitude.toString();
      if (ageMin != null) queryParams['ageMin'] = ageMin.toString();
      if (ageMax != null) queryParams['ageMax'] = ageMax.toString();
      if (gender != null) queryParams['gender'] = gender;
      if (interestedIn != null) queryParams['interestedIn'] = interestedIn;

      final queryString = '?${Uri(queryParameters: queryParams).query}';
      final url = '${ApiEndpoints.nearbyUsers}$queryString';

      print('🚀 Fetching nearby users with params: $queryParams');
      print('🚀 Using API endpoint: $url');

      final response = await ApiServices.getData(url);

      print('📥 Response status code: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return NearbyUsersResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to fetch nearby users: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching nearby users: $e');
      throw Exception('Failed to fetch nearby users: $e');
    }
  }
}
