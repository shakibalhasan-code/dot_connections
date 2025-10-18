import 'package:dot_connections/app/data/models/auth_models.dart';
import 'package:dot_connections/app/data/models/user_personal_data.dart';

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
    required UserPersonalData profileData,
  });

  /// Updates basic user information
  Future<AuthResponse> updateUser(Map<String, dynamic> userData);

  /// Updates user information with form data (for PATCH /user/update-user endpoint)
  Future<AuthResponse> updateUserWithFormData({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    DateTime? dateOfBirth,
  });

  /// Updates only the user's name (first name and last name)
  Future<AuthResponse> updateUserName({
    required String firstName,
    required String lastName,
  });

  /// Updates only the user's phone number
  Future<AuthResponse> updateUserPhone({required String phoneNumber});

  // /// Updates only the user's profile image
  // Future<AuthResponse> updateUserImage({required String imagePath});

  // /// Upload multiple images to the user's profile gallery
  // Future<AuthResponse> uploadProfileImages({required List<String> imagePaths});

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
