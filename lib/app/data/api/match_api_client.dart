import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dot_connections/app/core/constants/api_endpoints.dart';
import 'package:dot_connections/app/core/helper/pref_helper.dart';

class MatchApiClient {
  Future<String?> _getAuthToken() async {
    try {
      return await SharedPreferencesHelper.getToken();
    } catch (e) {
      return null;
    }
  }

  Map<String, String> _getHeaders({String? token}) {
    final headers = {'Content-Type': 'application/json'};

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<Map<String, dynamic>> getConnectionRequests({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final token = await _getAuthToken();
      final url = Uri.parse(
        '${ApiEndpoints.getConnectionRequests}?page=$page&limit=$limit',
      );

      final response = await http.get(url, headers: _getHeaders(token: token));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to get connection requests: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching connection requests: $e');
    }
  }

  Future<Map<String, dynamic>> getConnections() async {
    try {
      final token = await _getAuthToken();
      final url = Uri.parse(ApiEndpoints.getConnections);

      final response = await http.get(url, headers: _getHeaders(token: token));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get connections: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching connections: $e');
    }
  }

  Future<Map<String, dynamic>> getSentRequests() async {
    try {
      final token = await _getAuthToken();
      final url = Uri.parse(ApiEndpoints.getSentRequests);

      final response = await http.get(url, headers: _getHeaders(token: token));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get sent requests: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching sent requests: $e');
    }
  }

  Future<Map<String, dynamic>> respondToConnectionRequest(
    String requestId,
    String action, // "accept" or "reject"
  ) async {
    try {
      final token = await _getAuthToken();
      final url = Uri.parse(ApiEndpoints.respondToRequest(requestId));

      final response = await http.patch(
        url,
        headers: _getHeaders(token: token),
        body: json.encode({'action': action}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to respond to request: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error responding to connection request: $e');
    }
  }
}
