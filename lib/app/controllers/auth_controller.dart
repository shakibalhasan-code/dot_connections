import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/data/models/auth_models.dart';
import 'package:dot_connections/app/data/repo/auth_repo.dart';
import 'package:dot_connections/app/data/repo/i_auth_repository.dart';
import 'package:dot_connections/app/views/screens/initial/how_tall_view.dart';
import 'package:dot_connections/app/views/screens/initial/whats_name_view.dart';
import 'package:dot_connections/app/views/screens/parent/parent_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for authentication related operations
///
/// This controller manages the authentication state and provides methods
/// for login, registration, profile management, and other auth-related actions.
class AuthController extends GetxController {
  final IAuthRepository _authRepository;

  // Text controllers
  final emailController = TextEditingController();
  final otpController = TextEditingController();

  // Observable state variables
  final Rx<UserDto?> currentUser = Rx<UserDto?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isAuthenticated = false.obs;

  // Form validation observables
  final RxBool isEmailValid = false.obs;
  final RxBool isOtpValid = false.obs;

  AuthController({IAuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository();

  @override
  void onInit() {
    super.onInit();

    // Add listeners to text controllers for validation
    emailController.addListener(_validateEmail);
    otpController.addListener(_validateOtp);

    // Check if user is already logged in
    checkAuthStatus();
  }

  @override
  void onClose() {
    // Clean up controllers
    emailController.dispose();
    otpController.dispose();
    super.onClose();
  }

  /// Validates the email input
  void _validateEmail() {
    isEmailValid.value = GetUtils.isEmail(emailController.text.trim());
  }

  /// Validates the OTP input
  void _validateOtp() {
    isOtpValid.value = otpController.text.length == 6;
  }

  /// Checks if the user is already authenticated
  Future<void> checkAuthStatus() async {
    try {
      isLoading.value = true;

      // Check if we have a token
      final token = await _authRepository.getAuthToken();
      isAuthenticated.value = token != null;

      // If authenticated, fetch user profile
      if (isAuthenticated.value) {
        await fetchUserProfile();
      }
    } catch (e) {
      errorMessage.value = 'Error checking authentication status';
      isAuthenticated.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Sends an OTP to the user's email for login or registration
  Future<void> sendOtp() async {
    try {
      if (!isEmailValid.value) {
        errorMessage.value = 'Please enter a valid email address';
        return;
      }

      isLoading.value = true;
      errorMessage.value = '';

      final response = await _authRepository.sendOtp(
        emailController.text.trim(),
      );

      if (response.success) {
        Get.toNamed(AppRoutes.otp);
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Failed to send OTP: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Verifies the OTP and completes the login/registration process
  Future<void> verifyOtp() async {
    try {
      if (!isOtpValid.value) {
        errorMessage.value = 'Please enter a valid 6-digit OTP';
        return;
      }

      isLoading.value = true;
      errorMessage.value = '';

      print('🔑 Verifying OTP for email: ${emailController.text.trim()}');
      
      final response = await _authRepository.verifyOtp(
        emailController.text.trim(),
        otpController.text.trim(),
      );

      print('🔑 OTP verification response: ${response.success}, message: ${response.message}');
      
      if (response.success) {
        isAuthenticated.value = true;

        // Parse user data from response
        if (response.data != null && response.data['user'] != null) {
          final userData = response.data['user'];
          print('🔑 User data received: $userData');
          
          // Make sure the token was saved by repository
          if (response.data['accessToken'] != null) {
            print('🔑 Access token exists in response');
            // Explicitly save it again to be safe
            await _authRepository.saveAuthToken(response.data['accessToken']);
            print('🔑 Access token saved explicitly');
          }
          
          // Create user object
          currentUser.value = UserDto.fromJson(userData);
          print('🔑 User object created: ${currentUser.value?.id}');
          print('🔑 allUserFieldsFilled: ${currentUser.value?.allUserFieldsFilled}');
          print('🔑 allProfileFieldsFilled: ${currentUser.value?.allProfileFieldsFilled}');
          
          // Navigate based on user profile status
          print('🔑 Navigating based on profile completion status');
          _handleNavigation();
        } else {
          print('🔑 No user data in response, navigating to name input screen');
          // If no user data, still navigate to profile setup
          Get.offAllNamed(AppRoutes.name);
        }
      } else {
        errorMessage.value = response.message;
        print('🔑 OTP verification failed: ${response.message}');
      }
    } catch (e) {
      errorMessage.value = 'Failed to verify OTP: $e';
      print('🔑 Exception during OTP verification: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches the user's profile
  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;

      final response = await _authRepository.getMyProfile();

      if (response.success && response.data != null) {
        currentUser.value = UserDto.fromJson(response.data);
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Failed to fetch profile: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Adds basic user fields (first name, last name, date of birth)
  Future<void> addUserFields({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required bool pushNotification,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('👤 Adding user fields: firstName=$firstName, lastName=$lastName');
      
      final response = await _authRepository.addUserFields(
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
        pushNotification: pushNotification,
      );

      if (response.success) {
        print('👤 Successfully added user fields');
        
        // Refresh user profile
        await fetchUserProfile();

        // Check which step we should navigate to next based on where we are in the flow
        if (Get.currentRoute == AppRoutes.name) {
          print('👤 Navigating from Name view to DOB view');
          Get.offAllNamed(AppRoutes.dob);
        } else if (Get.currentRoute == AppRoutes.dob) {
          print('👤 Navigating from DOB view to enableNotifications');
          Get.offAllNamed(AppRoutes.enableNotifications);
        } else if (Get.currentRoute == AppRoutes.enableNotifications) {
          print('👤 Navigating from enableNotifications to howTall');
          Get.offAllNamed(AppRoutes.howTall);
        } else {
          // Default navigation if the route is unknown
          print('👤 Default navigation to howTall from ${Get.currentRoute}');
          Get.offAllNamed(AppRoutes.howTall);
        }
      } else {
        print('👤 Failed to add user fields: ${response.message}');
        errorMessage.value = response.message;
      }
    } catch (e) {
      print('👤 Exception when adding user fields: $e');
      errorMessage.value = 'Failed to add user fields: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Adds profile fields to complete the user's profile
  Future<void> addProfileFields({
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
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _authRepository.addProfileFields(
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

      if (response.success) {
        // Refresh user profile
        await fetchUserProfile();

        // Navigate to main app
        Get.offAllNamed(AppRoutes.parent);
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Failed to add profile fields: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Updates user information
  Future<void> updateUser(Map<String, dynamic> userData) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _authRepository.updateUser(userData);

      if (response.success) {
        // Refresh user profile
        await fetchUserProfile();
        Get.snackbar('Success', 'User information updated');
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Failed to update user: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Updates profile information
  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('👤 Updating profile with data: $profileData');
      final response = await _authRepository.updateProfile(profileData);

      if (response.success) {
        print('👤 Successfully updated profile');
        
        // Refresh user profile
        await fetchUserProfile();
        
        // Only show snackbar if we're not in the onboarding flow
        if (![
          AppRoutes.name,
          AppRoutes.dob,
          AppRoutes.enableNotifications,
          AppRoutes.howTall,
          AppRoutes.whoToDate,
          AppRoutes.iAmA,
          AppRoutes.whereLive,
        ].contains(Get.currentRoute)) {
          Get.snackbar('Success', 'Profile updated');
        }
      } else {
        print('👤 Failed to update profile: ${response.message}');
        errorMessage.value = response.message;
      }
    } catch (e) {
      print('👤 Exception when updating profile: $e');
      errorMessage.value = 'Failed to update profile: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Updates which profile fields are hidden from others
  Future<void> updateHiddenFields(Map<String, bool> hiddenFields) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _authRepository.updateHiddenFields(hiddenFields);

      if (response.success) {
        // Refresh user profile
        await fetchUserProfile();
        Get.snackbar('Success', 'Privacy settings updated');
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Failed to update privacy settings: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Logs the user out
  Future<void> logout() async {
    try {
      isLoading.value = true;

      await _authRepository.removeAuthToken();

      isAuthenticated.value = false;
      currentUser.value = null;

      // Clear controllers
      emailController.clear();
      otpController.clear();

      // Navigate back to initial screen
      Get.offAllNamed(AppRoutes.initial);
    } catch (e) {
      errorMessage.value = 'Failed to log out: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Deletes the user's account
  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _authRepository.deleteAccount();

      if (response.success) {
        isAuthenticated.value = false;
        currentUser.value = null;

        // Navigate back to initial screen
        Get.offAllNamed(AppRoutes.initial);
        Get.snackbar('Account Deleted', 'Your account has been deleted');
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Failed to delete account: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Handles navigation based on profile completion status
  void _handleNavigation() {
    print('🧭 Handling navigation after authentication');
    
    // Close any open dialogs or bottom sheets first
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
    
    if (currentUser.value == null) {
      print('🧭 Current user is null, navigating to name input: ${AppRoutes.name}');
      // Clear all previous screens and go to name input
      Get.offAll(() => const WhatsNameView(), transition: Transition.fadeIn);
      return;
    }

    print('🧭 User data: ${currentUser.value!.toJson()}');
    print('🧭 allUserFieldsFilled: ${currentUser.value!.allUserFieldsFilled}');
    print('🧭 allProfileFieldsFilled: ${currentUser.value!.allProfileFieldsFilled}');

    // Check if user fields are filled
    if (!currentUser.value!.allUserFieldsFilled) {
      print('🧭 User fields not filled, navigating to name input: ${AppRoutes.name}');
      // Clear all previous screens and go to name input
      Get.offAll(() => const WhatsNameView(), transition: Transition.fadeIn);
      return;
    }

    // Check if profile fields are filled
    if (!currentUser.value!.allProfileFieldsFilled) {
      print('🧭 Profile fields not filled, navigating to height input: ${AppRoutes.howTall}');
      // Clear all previous screens and go to how tall view
      Get.offAll(() => const HowTallView(), transition: Transition.fadeIn);
      return;
    }

    // All fields filled, go to main app
    print('🧭 All fields filled, navigating to main app: ${AppRoutes.parent}');
    // Clear all previous screens and go to parent screen
    Get.offAll(() => const ParentScreen(), transition: Transition.fadeIn);
  }
}
