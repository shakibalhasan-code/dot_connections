import 'package:dot_connections/app/core/helper/pref_helper.dart';
import 'package:dot_connections/app/data/api/auth_api_client.dart';
import 'package:dot_connections/app/data/models/auth_models.dart';
import 'package:dot_connections/app/data/repo/i_auth_repository.dart';

/// Implementation of the Authentication Repository
///
/// This class provides the concrete implementation of the IAuthRepository interface,
/// managing all authentication-related operations through the API client and local storage.
class AuthRepository implements IAuthRepository {
  final AuthApiClient _apiClient;

  AuthRepository({AuthApiClient? apiClient})
    : _apiClient = apiClient ?? AuthApiClient();

  @override
  Future<AuthResponse> sendOtp(String email) async {
    return await _apiClient.sendOtp(email);
  }

  @override
  Future<AuthResponse> verifyOtp(String email, String otp) async {
    final request = OtpVerificationRequest(email: email, otp: otp);
    final response = await _apiClient.verifyOtp(request);

    // If successful and token is provided, store it
    if (response.success && response.data is Map<String, dynamic>) {
      final data = AuthResult.fromJson(response.data);
      if (data.accessToken != null) {
        await saveAuthToken(data.accessToken!);
      }
    }

    return response;
  }

  @override
  Future<AuthResponse> getMyProfile() async {
    return await _apiClient.getMyProfile();
  }

  @override
  Future<AuthResponse> addUserFields({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required bool pushNotification,
  }) async {
    final userFields = UserFields(
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth.toIso8601String(),
      pushNotification: pushNotification,
    );

    return await _apiClient.addUserFields(userFields);
  }

  @override
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
  }) async {
    final profileFields = ProfileFields(
      location: location,
      gender: gender,
      interestedIn: interestedIn,
      height: height,
      interests: interests,
      lookingFor: lookingFor,
      ageRangeMin: ageRangeMin,
      ageRangeMax: ageRangeMax,
      maxDistance: maxDistance,
      hometown: hometown,
      workplace: workplace,
      jobTitle: jobTitle,
      school: school,
      studyLevel: studyLevel,
      religious: religious,
      smokingStatus: smokingStatus,
      drinkingStatus: drinkingStatus,
      bio: bio,
      hiddenFields: hiddenFields,
    );

    return await _apiClient.addProfileFields(profileFields);
  }

  @override
  Future<AuthResponse> updateUser(Map<String, dynamic> userData) async {
    return await _apiClient.updateUser(userData);
  }

  @override
  Future<AuthResponse> updateProfile(Map<String, dynamic> profileData) async {
    return await _apiClient.updateProfile(profileData);
  }

  @override
  Future<AuthResponse> updateHiddenFields(
    Map<String, bool> hiddenFields,
  ) async {
    return await _apiClient.updateHiddenFields(hiddenFields);
  }

  @override
  Future<AuthResponse> deleteProfileImage(int imageIndex) async {
    return await _apiClient.deleteProfileImage(imageIndex);
  }

  @override
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
  }) async {
    final params = NearbyUserParams(
      radius: radius,
      latitude: latitude,
      longitude: longitude,
      gender: gender,
      interests: interests,
      interestedIn: interestedIn,
      lookingFor: lookingFor,
      religious: religious,
      studyLevel: studyLevel,
    );

    return await _apiClient.getNearbyUsers(params);
  }

  @override
  Future<AuthResponse> getUserById(String userId) async {
    return await _apiClient.getUserById(userId);
  }

  @override
  Future<AuthResponse> updateUserStatus(String userId, String status) async {
    return await _apiClient.updateUserStatus(userId, status);
  }

  @override
  Future<AuthResponse> deleteAccount() async {
    final response = await _apiClient.deleteAccount();

    if (response.success) {
      // Clear local auth token on successful account deletion
      await removeAuthToken();
    }

    return response;
  }

  @override
  Future<AuthResponse> getAllUsers({
    int page = 1,
    int limit = 10,
    String? searchTerm,
    String? sortBy,
    String? sortOrder,
  }) async {
    return await _apiClient.getAllUsers(
      page: page,
      limit: limit,
      searchTerm: searchTerm,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }

  @override
  Future<AuthResponse> updateUserRole(String userId, String role) async {
    return await _apiClient.updateUserRole(userId, role);
  }

  @override
  Future<void> saveAuthToken(String token) async {
    await SharedPreferencesHelper.saveToken(token);
  }

  @override
  Future<String?> getAuthToken() async {
    return await SharedPreferencesHelper.getToken();
  }

  @override
  Future<void> removeAuthToken() async {
    await SharedPreferencesHelper.deleteToken();
  }
}
