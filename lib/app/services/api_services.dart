import 'dart:convert';
import 'package:dot_connections/app/core/helper/pref_helper.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static Future<Map<String, String>> _getHeaders() async {
    final token = await SharedPreferencesHelper.getToken();
    final headers = {"Content-Type": "application/json"};
    if (token != null) {
      headers["Authorization"] = "Bearer $token";
    }
    return headers;
  }

  /// Fetches data from the given URL (Read operation).
  static Future<http.Response> getData(String url) async {
    try {
      final headers = await _getHeaders();
      print('📤 GET Request to: $url');
      print('📤 Request headers: $headers');

      final response = await http.get(Uri.parse(url), headers: headers);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response headers: ${response.headers}');

      return response;
    } catch (e) {
      print('❌ Error in GET request: $e');
      rethrow;
    }
  }

  /// Posts data to the given URL (Create operation).
  static Future<http.Response> postData(
    String url,
    Map<String, dynamic> data,
  ) async {
    try {
      final headers = await _getHeaders();
      print('📤 POST Request to: $url');
      print('📤 Request headers: $headers');
      print('📤 Request body: ${jsonEncode(data)}');

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response headers: ${response.headers}');

      return response;
    } catch (e) {
      print('❌ Error in POST request: $e');
      rethrow;
    }
  }

  static Future<http.Response> updateData(
    String url,
    Map<String, dynamic> data,
  ) async {
    try {
      final headers = await _getHeaders();
      print('📤 PUT Request to: $url');
      print('📤 Request headers: $headers');
      print('📤 Request body: ${jsonEncode(data)}');

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response headers: ${response.headers}');

      return response;
    } catch (e) {
      print('❌ Error in PUT request: $e');
      rethrow;
    }
  }

  /// Deletes data at the given URL (Delete operation).
  static Future<http.Response> deleteData(String url) async {
    try {
      final headers = await _getHeaders();
      print('📤 DELETE Request to: $url');
      print('📤 Request headers: $headers');

      final response = await http.delete(Uri.parse(url), headers: headers);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response headers: ${response.headers}');

      return response;
    } catch (e) {
      print('❌ Error in DELETE request: $e');
      rethrow;
    }
  }
}
