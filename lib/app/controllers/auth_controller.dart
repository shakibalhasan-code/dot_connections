import 'package:dot_connections/app/core/services/socket_service.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/data/models/auth_models.dart' hide Location;
import 'package:dot_connections/app/data/models/user_personal_data.dart';
import 'package:dot_connections/app/data/models/user_profile_model.dart';
import 'package:dot_connections/app/data/repo/auth_repo.dart';
import 'package:dot_connections/app/data/repo/i_auth_repository.dart';
import 'package:dot_connections/app/services/api_services.dart';
import 'package:dot_connections/app/views/screens/initial/how_tall_view.dart';
import 'package:dot_connections/app/views/screens/initial/whats_dob_view.dart';
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

  var userData = {
    'firstName': '',
    'lastName': '',
    'dateOfBirth': DateTime.now(),
    'pushNotification': false,
  }.obs;

  Rx<UserPersonalData> currentUserProfile = UserPersonalData(
    location: Location(
      type: 'Point',
      coordinates: [-74.006, 40.7128],
      address: 'Mohakhali, Dhaka, Bangladesh',
    ),
    gender: 'male', // Using API format
    interestedIn: 'everyone', // Using API format with default
    height: 167, // Default height
    interests: ['travel'], // Initialize with at least one default interest
    lookingFor: 'dating', // Default
    ageRangeMin: 18, // Default min age
    ageRangeMax: 60, // Default max age
    maxDistance: 25, // Default distance
    hometown: 'Not specified', // Default
    workplace: 'Not specified',
    jobTitle: 'Not specified',
    school: 'highSchool', // Using API format
    studyLevel: 'underGraduation', // Default
    religious: 'prefer_not_to_say', // Using API format with default
    smokingStatus: 'Prefer Not to Say', // Default
    drinkingStatus: 'Prefer Not to Say', // Default
    bio: 'About me', // Default
    hiddenFields: HiddenFields(
      religious: false,
      smokingStatus: false,
      gender: false,
      hometown: false,
      workplace: false,
      jobTitle: false,
      school: false,
      studyLevel: false,
      drinkingStatus: false,
    ),
  ).obs;

  @override
  void onInit() {
    super.onInit();

    // Add listeners to text controllers for validation
    emailController.addListener(_validateEmail);
    otpController.addListener(_validateOtp);

    // // Check if user is already logged in
    // checkAuthStatus();
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

      print(
        '🔑 OTP verification response: ${response.success}, message: ${response.message}',
      );

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
          print(
            '🔑 allUserFieldsFilled: ${currentUser.value?.allUserFieldsFilled}',
          );
          print(
            '🔑 allProfileFieldsFilled: ${currentUser.value?.allProfileFieldsFilled}',
          );

          // Navigate based on user profile status
          print('🔑 Navigating based on profile completion status');
          _handleNavigation();
        } else {
          print('🔑 No user data in response, navigating to name input screen');
          // If no user data, still navigate to profile setup
          _handleNavigation();
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
  Future<AuthResponse> fetchUserProfile() async {
    try {
      isLoading.value = true;

      final response = await _authRepository.getMyProfile();

      if (response.success && response.data != null) {
        debugPrint('👤 User profile fetched: ${response.data}');
        currentUser.value = UserDto.fromJson(response.data);
      } else {
        errorMessage.value = response.message;
      }
      debugPrint('👤 User profile fetched: ${response.data}');
      return response;
    } catch (e) {
      debugPrint('👤 Error fetching user profile: $e');
      errorMessage.value = 'Failed to fetch profile: $e';
      throw e;
    } finally {
      isLoading.value = false;
    }
  }

  /// Adds basic user fields (first name, last name, date of birth)
  Future<void> addUserFields() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('👤 Adding user fields: $userData');

      // Convert dateOfBirth to DateTime if it's not already
      final dateOfBirth = userData['dateOfBirth'] is DateTime
          ? userData['dateOfBirth'] as DateTime
          : DateTime.now();

      // Set default for pushNotification if missing
      final pushNotification = userData['pushNotification'] ?? false;

      // Set default for notificationsEnabled if missing
      final notificationsEnabled =
          userData['notificationsEnabled'] as bool? ?? true;

      print(
        '👤 Formatted user fields: firstName=${userData['firstName']}, lastName=${userData['lastName']}, dateOfBirth=$dateOfBirth, pushNotification=$pushNotification',
      );

      final response = await _authRepository.addUserFields(
        firstName: userData['firstName'].toString(),
        lastName: userData['lastName'].toString(),
        dateOfBirth: dateOfBirth,
        pushNotification: notificationsEnabled,
      );

      if (response.success) {
        print('👤 Successfully added user fields');
        Get.to(() => HowTallView());

        // // Refresh user profile
        // await fetchUserProfile();

        // // Check which step we should navigate to next based on where we are in the flow
        // if (Get.currentRoute == AppRoutes.name) {
        //   print('👤 Navigating from Name view to DOB view');
        //   Get.offAllNamed(AppRoutes.dob);
        // } else if (Get.currentRoute == AppRoutes.dob) {
        //   print('👤 Navigating from DOB view to enableNotifications');
        //   Get.offAllNamed(AppRoutes.enableNotifications);
        // } else if (Get.currentRoute == AppRoutes.enableNotifications) {
        //   print('👤 Navigating from enableNotifications to howTall');
        //   Get.to(() => HowTallView());
        // } else {
        //   // Default navigation if the route is unknown
        //   print('👤 Default navigation to howTall from ${Get.currentRoute}');
        //   Get.to(() => HowTallView());
        // }
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
  Future<void> addProfileFields() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Validate and set defaults for any empty values
      validateAndNormalizeProfileData();

      debugPrint(
        '👤 Adding profile fields: ${currentUserProfile.value.toJson()}',
      );

      final response = await _authRepository.addProfileFields(
        profileData: currentUserProfile.value,
      );

      if (response.success) {
        Get.to(() => ParentScreen());
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

  /// Updates user information using FormData (for PATCH /user/update-user endpoint)
  // Future<void> updateUserWithFormData({
  //   String? firstName,
  //   String? lastName,
  //   String? phoneNumber,
  //   bool? pushNotification,
  //   DateTime? dateOfBirth,
  // }) async {
  //   try {
  //     isLoading.value = true;
  //     errorMessage.value = '';

  //     print('👤 Updating user with form data');

  //     final response = await _authRepository.updateUserWithFormData(
  //       firstName: firstName,
  //       lastName: lastName,
  //       phoneNumber: phoneNumber,
  //       dateOfBirth: dateOfBirth,
  //     );

  //     if (response.success) {
  //       print('👤 Successfully updated user data');
  //       // Refresh user profile to get the latest data
  //       await fetchUserProfile();
  //       Get.snackbar('Success', 'User information updated successfully');
  //     } else {
  //       print('👤 Failed to update user data: ${response.message}');
  //       errorMessage.value = response.message;
  //       Get.snackbar(
  //         'Error',
  //         'Failed to update user information: ${response.message}',
  //       );
  //     }
  //   } catch (e) {
  //     print('👤 Exception when updating user: $e');
  //     errorMessage.value = 'Failed to update user: $e';
  //     Get.snackbar('Error', 'Failed to update user information');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  /// Updates only user's first name and last name and handles navigation
  Future<void> updateUserName({
    required String firstName,
    required String lastName,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Validate inputs first
      if (firstName.isEmpty) {
        errorMessage.value = 'First name cannot be empty';
        Get.snackbar('Error', 'First name cannot be empty');
        return;
      }

      print('👤 Updating user name: $firstName $lastName');

      final response = await _authRepository.updateUserName(
        firstName: firstName,
        lastName: lastName,
      );

      if (response.success) {
        print('👤 Successfully updated user name');
        // Refresh user profile to get the latest data
        await fetchUserProfile();

        // Show success snackbar with a callback to navigate back after it completes
        Get.snackbar(
          'Success',
          'Name updated successfully',
          duration: const Duration(seconds: 1),
          snackbarStatus: (status) {
            if (status == SnackbarStatus.CLOSED) {
              // Only navigate back after snackbar is fully closed
              Get.back();
            }
          },
        );
      } else {
        print('👤 Failed to update user name: ${response.message}');
        errorMessage.value = response.message;
        Get.snackbar('Error', 'Failed to update name: ${response.message}');
      }
    } catch (e) {
      print('👤 Exception when updating user name: $e');
      errorMessage.value = 'Failed to update name: $e';
      Get.snackbar('Error', 'Failed to update name. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Updates only user's first name and last name without handling navigation
  /// Returns the AuthResponse for external navigation handling
  Future<AuthResponse> updateUserNameWithoutNavigation({
    required String firstName,
    required String lastName,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Validate inputs first
      if (firstName.isEmpty) {
        errorMessage.value = 'First name cannot be empty';
        return AuthResponse(
          success: false,
          message: 'First name cannot be empty',
        );
      }

      print('👤 Updating user name: $firstName $lastName');

      final response = await _authRepository.updateUserName(
        firstName: firstName,
        lastName: lastName,
      );

      if (response.success) {
        print('👤 Successfully updated user name');
        // Refresh user profile to get the latest data
        await fetchUserProfile();
      } else {
        print('👤 Failed to update user name: ${response.message}');
        errorMessage.value = response.message;
      }

      return response;
    } catch (e) {
      print('👤 Exception when updating user name: $e');
      errorMessage.value = 'Failed to update name: $e';
      return AuthResponse(success: false, message: 'Failed to update name: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Updates only user's phone number
  Future<AuthResponse> updateUserPhone({required String phoneNumber}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('👤 Updating user phone number: $phoneNumber');

      final response = await _authRepository.updateUserPhone(
        phoneNumber: phoneNumber,
      );

      if (response.success) {
        print('👤 Successfully updated phone number');
        // Refresh user profile to get the latest data
        await fetchUserProfile();
      } else {
        print('👤 Failed to update phone number: ${response.message}');
        errorMessage.value = response.message;
      }

      return response;
    } catch (e) {
      print('👤 Exception when updating phone: $e');
      errorMessage.value = 'Failed to update phone number: $e';
      return AuthResponse(
        success: false,
        message: 'Failed to update phone number: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // /// Updates user's profile image
  // Future<void> updateUserImage({required String imagePath}) async {
  //   try {
  //     isLoading.value = true;
  //     errorMessage.value = '';

  //     print('👤 Updating user profile image: $imagePath');

  //     final response = await _authRepository.updateUserImage(
  //       imagePath: imagePath,
  //     );

  //     if (response.success) {
  //       print('👤 Successfully updated profile image');
  //       // Refresh user profile to get the latest data
  //       await fetchUserProfile();

  //       Get.snackbar(
  //         'Success',
  //         'Profile image updated successfully',
  //         duration: const Duration(seconds: 1),
  //       );
  //     } else {
  //       print('👤 Failed to update profile image: ${response.message}');
  //       errorMessage.value = response.message;
  //       Get.snackbar(
  //         'Error',
  //         'Failed to update profile image: ${response.message}',
  //       );
  //     }
  //   } catch (e) {
  //     print('👤 Exception when updating profile image: $e');
  //     errorMessage.value = 'Failed to update profile image: $e';
  //     Get.snackbar('Error', 'Failed to update profile image');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  /// Uploads a single image to the user's profile gallery
  /// Consider using GalleryController for multiple image uploads
  // Future<void> uploadProfileGalleryImage({required String imagePath}) async {
  //   try {
  //     isLoading.value = true;
  //     errorMessage.value = '';

  //     print('👤 Uploading image to profile gallery: $imagePath');

  //     // Call the repository method to upload the gallery image
  //     // Use a list of images even for a single image to use the patch method with file format
  //     final response = await _authRepository.uploadProfileImages(
  //       imagePaths: [imagePath],
  //     );

  //     if (response.success) {
  //       print('👤 Successfully uploaded gallery image');
  //       // Refresh user profile to get the latest data including updated photo gallery
  //       await fetchUserProfile();

  //       // If this is the first image and user doesn't have a profile pic yet, set it as profile pic
  //       if (currentUser.value != null &&
  //           currentUser.value!.image == null &&
  //           currentUser.value!.profile != null &&
  //           currentUser.value!.profile!.photos != null &&
  //           currentUser.value!.profile!.photos!.isNotEmpty) {
  //         print('👤 Setting first gallery image as profile picture');
  //         await updateUserImage(imagePath: imagePath);
  //       }

  //       Get.snackbar(
  //         'Success',
  //         'Photo added to gallery successfully',
  //         duration: const Duration(seconds: 1),
  //       );
  //     } else {
  //       print('👤 Failed to upload gallery image: ${response.message}');
  //       errorMessage.value = response.message;
  //       Get.snackbar('Error', 'Failed to upload photo: ${response.message}');
  //     }
  //   } catch (e) {
  //     print('👤 Exception when uploading gallery image: $e');
  //     errorMessage.value = 'Failed to upload photo: $e';
  //     Get.snackbar('Error', 'Failed to upload photo');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  /// Uploads multiple images to the user's profile gallery
  /// This is a convenience method that delegates to the GalleryController
  // Future<void> uploadMultipleProfileGalleryImages({
  //   required List<String> imagePaths,
  // }) async {
  //   try {
  //     isLoading.value = true;
  //     errorMessage.value = '';

  //     print('👤 Uploading multiple images to profile gallery: $imagePaths');

  //     // Call the repository method to upload the gallery images
  //     final response = await _authRepository.uploadProfileImages(
  //       imagePaths: imagePaths,
  //     );

  //     if (response.success) {
  //       print('👤 Successfully uploaded gallery images');
  //       // Refresh user profile to get the latest data including updated photo gallery
  //       await fetchUserProfile();

  //       // If this is the first image and user doesn't have a profile pic yet, set it as profile pic
  //       if (currentUser.value != null &&
  //           currentUser.value!.image == null &&
  //           currentUser.value!.profile != null &&
  //           currentUser.value!.profile!.photos != null &&
  //           currentUser.value!.profile!.photos!.isNotEmpty) {
  //         print('👤 Setting first gallery image as profile picture');
  //         await updateUserImage(imagePath: imagePaths.first);
  //       }

  //       Get.snackbar(
  //         'Success',
  //         'Photos added to gallery successfully',
  //         duration: const Duration(seconds: 1),
  //       );
  //     } else {
  //       print('👤 Failed to upload gallery images: ${response.message}');
  //       errorMessage.value = response.message;
  //       Get.snackbar('Error', 'Failed to upload photos: ${response.message}');
  //     }
  //   } catch (e) {
  //     print('👤 Exception when uploading gallery images: $e');
  //     errorMessage.value = 'Failed to upload photos: $e';
  //     Get.snackbar('Error', 'Failed to upload photos');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

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

  /// Validates and ensures all profile fields have proper values before submitting
  void validateAndNormalizeProfileData() {
    // Create a local reference to avoid null issues
    var profile = currentUserProfile.value;

    // Ensure gender has a valid value
    if (profile.gender.isEmpty) {
      profile.gender = 'male';
    }

    // Ensure interestedIn has a valid value
    if (profile.interestedIn.isEmpty) {
      profile.interestedIn = 'everyone';
    }

    // Ensure height has a reasonable default
    if (profile.height < 100) {
      profile.height = 167;
    }

    // Ensure interests has at least one value
    if (profile.interests.isEmpty) {
      profile.interests = ['travel'];
    }

    // Ensure lookingFor has a valid value
    if (profile.lookingFor.isEmpty) {
      profile.lookingFor = 'dating';
    }

    // Ensure age range has reasonable defaults
    if (profile.ageRangeMin < 18) {
      profile.ageRangeMin = 18;
    }

    if (profile.ageRangeMax < profile.ageRangeMin) {
      profile.ageRangeMax = profile.ageRangeMin + 20; // Default 20-year range
    }

    // Ensure maxDistance has a reasonable default
    if (profile.maxDistance <= 0) {
      profile.maxDistance = 25;
    }

    // Ensure other profile fields have defaults
    if (profile.hometown.isEmpty) {
      profile.hometown = 'Not specified';
    }

    if (profile.workplace.isEmpty) {
      profile.workplace = 'Not specified';
    }

    if (profile.jobTitle.isEmpty) {
      profile.jobTitle = 'Not specified';
    }

    if (profile.school.isEmpty) {
      profile.school = 'highSchool';
    }

    if (profile.studyLevel.isEmpty) {
      profile.studyLevel = 'underGraduation';
    }

    if (profile.religious.isEmpty) {
      profile.religious = 'prefer_not_to_say';
    }

    if (profile.smokingStatus.isEmpty) {
      profile.smokingStatus = 'Prefer Not to Say';
    }

    if (profile.drinkingStatus.isEmpty) {
      profile.drinkingStatus = 'Prefer Not to Say';
    }

    if (profile.bio.isEmpty) {
      profile.bio = 'About me';
    }

    // Update the profile
    currentUserProfile.value = profile;
    currentUserProfile.refresh();
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
  // Note: This method is currently not used but kept for potential future use
  // ignore: unused_element
  void _handleNavigation() {
    print('🧭 Handling navigation after authentication');

    // Close any open dialogs or bottom sheets first
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    if (currentUser.value == null) {
      print(
        '🧭 Current user is null, navigating to name input: ${AppRoutes.name}',
      );
      // Clear all previous screens and go to name input
      Get.offAll(() => const WhatsNameView(), transition: Transition.fadeIn);
      return;
    }

    print('🧭 User data: ${currentUser.value!.toJson()}');
    print('🧭 allUserFieldsFilled: ${currentUser.value!.allUserFieldsFilled}');
    print(
      '🧭 allProfileFieldsFilled: ${currentUser.value!.allProfileFieldsFilled}',
    );

    // Check if user fields are filled
    if (!currentUser.value!.allUserFieldsFilled) {
      print(
        '🧭 User fields not filled, navigating to name input: ${AppRoutes.name}',
      );
      // Clear all previous screens and go to name input
      Get.offAll(() => const WhatsNameView(), transition: Transition.fadeIn);
      return;
    }

    // Check if profile fields are filled
    if (!currentUser.value!.allProfileFieldsFilled) {
      print(
        '🧭 Profile fields not filled, navigating to height input: ${AppRoutes.howTall}',
      );
      // Clear all previous screens and go to how tall view
      Get.offAll(() => const HowTallView(), transition: Transition.fadeIn);
      return;
    }

    // BOTH fields must be filled to proceed to main app
    if (currentUser.value!.allUserFieldsFilled &&
        currentUser.value!.allProfileFieldsFilled) {
      print(
        '🧭 Both user and profile fields are filled, navigating to main app: ${AppRoutes.parent}',
      );

      // Register user with socket service for real-time features
      _registerWithSocketService();

      // Clear all previous screens and go to parent screen
      Get.offAll(() => const ParentScreen(), transition: Transition.fadeIn);
    } else {
      print(
        '🧭 Warning: Reached end of navigation logic without both fields filled',
      );
      // Fallback - this should not happen given the checks above
      Get.offAll(() => const WhatsNameView(), transition: Transition.fadeIn);
    }
  }

  /// Register user with socket service for real-time features
  void _registerWithSocketService() {
    try {
      if (currentUser.value?.id != null) {
        final socketService = SocketService.instance;
        socketService.registerUser(currentUser.value!.id);
        debugPrint(
          '🔌 User registered with socket service: ${currentUser.value!.id}',
        );
      }
    } catch (e) {
      debugPrint('❌ Failed to register with socket service: $e');
    }
  }
}
