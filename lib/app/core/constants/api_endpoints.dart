import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  // Base URL from environment variables
  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://10.10.12.125:5009/api/v1';

  // Auth Endpoints
  static String get user => '$baseUrl/user';
  static String get verifyOtp => '$baseUrl/user/verify-otp';
  static String get getMe => '$baseUrl/user/getme';
  static String get addUserFields => '$baseUrl/user/add-user-fields';
  static String get addProfileFields => '$baseUrl/user/add-profile-fields';
  static String get updateUser => '$baseUrl/user/update-user';
  static String get updateProfile => '$baseUrl/user/update-profile';
  static String get updateHiddenFields => '$baseUrl/user/update-hidden-fields';
  static String get deleteProfileImage =>
      '$baseUrl/user/profile/image'; // Append imageIndex
  static String get nearbyUsers => '$baseUrl/user/nearby';
  static String get getUserById => '$baseUrl/user'; // Append user ID
  static String get updateUserStatus =>
      '$baseUrl/user'; // Append user ID + /status
  static String get deleteAccount => '$baseUrl/user/delete';

  ///get users for matching
  ///GET /api/v1/match/potential
  static String get getAllUsers => '$baseUrl/match/potential';

  ///get potential matches with better formatting
  static String get getPotentialMatches => '$baseUrl/match/potential';
  static String get updateUserRole => '$baseUrl/user'; // Append user ID + /role
}
