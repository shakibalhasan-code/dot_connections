import 'package:dot_connections/app/data/models/auth_models.dart';

abstract class IAuthRepository {
  /// Sends an OTP to the provided email for login or registration
  Future<AuthResponse> sendOtp(String email);

  /// Verifies OTP and completes login/registration
  Future<AuthResponse> verifyOtp(String email, String otp);

  /// Gets the current logged-in user's profile
  Future<AuthResponse> getMyProfile();

  /// Adds basic user fields after initial registration
  Future<AuthResponse> addUserFields({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required bool pushNotification,
  });

  /// Adds complete profile information
  Future<AuthResponse> addProfileFields({
    required Location location,
    required String gender,
    required String interestedIn,
    required int height,
    required List<String> interests,
    required String lookingFor,
    required int ageRangeMin,
    required int ageRangeMax,
    required int maxDistance,
    required String hometown,
    required String workplace,
    required String jobTitle,
    required String school,
    required String studyLevel,
    required String religious,
    required String smokingStatus,
    required String drinkingStatus,
    required String bio,
    required Map<String, bool> hiddenFields,
  });

  /// Updates basic user information
  Future<AuthResponse> updateUser(Map<String, dynamic> userData);

  /// Updates profile information
  Future<AuthResponse> updateProfile(Map<String, dynamic> profileData);

  /// Updates which profile fields are hidden from others
  Future<AuthResponse> updateHiddenFields(Map<String, bool> hiddenFields);

  /// Deletes a profile image by index
  Future<AuthResponse> deleteProfileImage(int imageIndex);

  /// Gets nearby users based on parameters
  Future<AuthResponse> getNearbyUsers({
    int? radius,
    double? latitude,
    double? longitude,
    String? gender,
    String? interests,
    String? interestedIn,
    String? lookingFor,
    String? religious,
    String? studyLevel,
  });

  /// Gets user by ID
  Future<AuthResponse> getUserById(String userId);

  /// Updates user status (active or delete)
  Future<AuthResponse> updateUserStatus(String userId, String status);

  /// Deletes user account (sets status to deleted)
  Future<AuthResponse> deleteAccount();

  /// Gets all users (admin only)
  Future<AuthResponse> getAllUsers({
    int page = 1,
    int limit = 10,
    String? searchTerm,
    String? sortBy,
    String? sortOrder,
  });

  /// Updates user role (admin only)
  Future<AuthResponse> updateUserRole(String userId, String role);

  /// Stores the authentication token
  Future<void> saveAuthToken(String token);

  /// Gets the authentication token
  Future<String?> getAuthToken();

  /// Removes the authentication token (logout)
  Future<void> removeAuthToken();
}
