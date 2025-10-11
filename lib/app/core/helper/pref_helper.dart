import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _tokenKey = 'bearer_token';

  /// Saves the bearer token to SharedPreferences.
  static Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    } catch (e) {
      // Handle exceptions, e.g., by logging them
      print('Failed to save token: $e');
      rethrow;
    }
  }

  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      // Handle exceptions
      print('Failed to retrieve token: $e');
      return null;
    }
  }

  /// Deletes the bearer token from SharedPreferences.
  static Future<void> deleteToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
    } catch (e) {
      // Handle exceptions
      print('Failed to delete token: $e');
      rethrow;
    }
  }
}
