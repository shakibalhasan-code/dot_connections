import 'dart:convert';
import 'package:dot_connections/app/core/helper/pref_helper.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static Future<Map<String, String>> _getHeaders({
    bool isFormData = false,
  }) async {
    final token = await SharedPreferencesHelper.getToken();
    final Map<String, String> headers = isFormData
        ? <String, String>{}
        : <String, String>{"Content-Type": "application/json"};
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
      print('📤 MULTIPART PATCH Request to: $url');

      // 1. Create a MultipartRequest instance.
      // Use 'POST' or 'PATCH' to match your server's required HTTP method.
      final request = http.MultipartRequest('PATCH', Uri.parse(url));

      // 2. Add the headers to the request.
      request.headers.addAll(headers);

      // 3. The `updateUserName` function sends a map like: {'data': {'firstName': ..., 'lastName': ...}}
      // We need to JSON encode the inner map and add it as a text field.
      if (data.containsKey('data')) {
        request.fields['data'] = jsonEncode(data['data']);
      }

      print('📤 Request fields: ${request.fields}');

      // 4. Send the request.
      final streamedResponse = await request.send();

      // 5. Convert the response stream back to a standard http.Response.
      final response = await http.Response.fromStream(streamedResponse);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response headers: ${response.headers}');
      print('📥 Response body: ${response.body}');

      return response;
    } catch (e) {
      print('❌ Error in MULTIPART request: $e');
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

  /// Patches data at the given URL with FormData (Update operation).
  static Future<http.Response> patchFormData(
    String url,
    Map<String, dynamic> data,
  ) async {
    try {
      final headers = await _getHeaders(isFormData: true);
      print('📤 PATCH Request to: $url');
      print('📤 Request headers: $headers');
      print('📤 Request form data: $data');

      // Create multipart request for FormData
      final request = http.MultipartRequest('PATCH', Uri.parse(url));

      // Add headers
      request.headers.addAll(headers);

      // Add form fields
      data.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      // Send request and get response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response headers: ${response.headers}');
      print('📥 Response body: ${response.body}');

      return response;
    } catch (e) {
      print('❌ Error in PATCH request: $e');
      rethrow;
    }
  }

  static Future<http.Response> updateDataPatch(
    String url,
    Map<String, dynamic> data,
  ) async {
    try {
      final headers = await _getHeaders(isFormData: true);
      print('📤 PATCH Request to: $url');
      print('📤 Request headers: $headers');
      print('📤 Request form data: $data');

      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response headers: ${response.headers}');
      print('📥 Response body: ${response.body}');

      return response;
    } catch (e) {
      print('❌ Error in PATCH request: $e');
      rethrow;
    }
  }

  /// Patches data with file uploads at the given URL with FormData (Update operation).
  static Future<http.Response> patchFormDataWithFile(
    String url,
    Map<String, dynamic> fields,
    Map<String, String> files, // Map of field name to file path
  ) async {
    try {
      final headers = await _getHeaders(isFormData: true);
      print('📤 PATCH Request with file to: $url');
      print('📤 Request headers: $headers');
      print('📤 Request form fields: $fields');
      print('📤 Request files: $files');

      // Create multipart request for FormData
      final request = http.MultipartRequest('PATCH', Uri.parse(url));

      // Add headers
      request.headers.addAll(headers);

      // Add form fields
      fields.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      // Add files
      for (var entry in files.entries) {
        final fieldName = entry.key;
        final filePath = entry.value;
        print('📤 Adding file: $fieldName from path: $filePath');
        try {
          final file = await http.MultipartFile.fromPath(fieldName, filePath);
          request.files.add(file);
          print('📤 Successfully added file: ${file.length} bytes');
        } catch (fileError) {
          print('❌ Error adding file $fieldName: $fileError');
          // Continue with the request even if one file fails
        }
      }

      // Send request and get response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response headers: ${response.headers}');
      print('📥 Response body: ${response.body}');

      // Check for server error and try to extract the actual error message
      if (response.statusCode >= 400) {
        print('❌ Server error: HTTP ${response.statusCode}');
        try {
          // Try to extract error message from JSON response if possible
          final errorJson = jsonDecode(response.body);
          print('❌ Server error details: $errorJson');
        } catch (_) {
          print('❌ Could not parse error response: ${response.body}');
        }
      }

      return response;
    } catch (e) {
      print('❌ Error in PATCH request with file: $e');
      rethrow;
    }
  }
}
