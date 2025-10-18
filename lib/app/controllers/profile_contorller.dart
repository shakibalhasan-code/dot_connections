import 'dart:convert';

import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/constants/api_endpoints.dart';
import 'package:dot_connections/app/core/helper/pref_helper.dart';
import 'package:dot_connections/app/core/helper/widget_helper.dart';
import 'package:dot_connections/app/data/models/auth_models.dart';
import 'package:dot_connections/app/data/repo/auth_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Added for CircularProgressIndicator
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart'; // Import for MediaType

class ProfileContorller extends GetxController {
  // Text controllers for editing user data
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Observable user data
  final Rx<UserDto?> user = Rx<UserDto?>(null);

  // Photo gallery from user profile
  final photoGllery = RxList<String>([]);

  ///instances
  final ImagePicker imagePicker = ImagePicker();

  ///selected_files/value
  late XFile selectedImage;

  /// List of selected images for multiple upload
  final RxList<XFile> selectedImages = <XFile>[].obs;

  /// PHOTO-GALLERY LOGIC <=======================

  ///pick the image and upload it to the photo gallery
  void pickImage() async {
    try {
      final imagePicked = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Compress image for faster upload
      );

      if (imagePicked == null) {
        debugPrint('No image selected');
        return;
      } else {
        debugPrint('Image picked: ${imagePicked.path}');
        selectedImage = imagePicked;

        // Show loading indicator
        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        // Upload image to gallery
        final authController = Get.find<AuthController>();
        await uploadMultipleImages(imagePaths: [imagePicked.path], data: {});

        // Close loading dialog
        Get.back();

        // Force refresh to get updated photo list from server
        await refreshUserData();

        // Check if this is the first photo and update UI accordingly
        if (user.value != null &&
            user.value!.profile != null &&
            user.value!.profile!.photos != null &&
            user.value!.profile!.photos!.length == 1) {
          // First photo was just added, might need to update UI in other places
          update();
        }
      }
    } catch (e) {
      // Close loading dialog if open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      debugPrint('Error picking/uploading image: $e');
      Get.snackbar('Error', 'Failed to upload profile image');
    }
  }

  /// Pick multiple images and upload them to the photo gallery
  Future<void> uploadMultipleImages({
    required List<String> imagePaths,
    required Map<String, dynamic> data,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getToken();
      // Replace with your actual API endpoint
      final url = Uri.parse(ApiEndpoints.updateProfile);

      // Create a multipart request
      final request = http.MultipartRequest('PATCH', url);
      request.headers.addAll({'Authorization': 'Bearer $token'});

      request.fields['data'] = json.encode(data);

      // Add the image files
      for (final imagePath in imagePaths) {
        // Determine the MIME type of the file
        final mimeType = lookupMimeType(imagePath);

        // Ensure mimeType is not null, and provide a default if it is.
        // The mimeType string is split to get the primary type and subtype.
        final contentType = mimeType != null
            ? MediaType.parse(mimeType)
            : MediaType('application', 'octet-stream'); // A default fallback

        request.files.add(
          await http.MultipartFile.fromPath(
            'image', // This is the key for the image file(s)
            imagePath,
            contentType: contentType, // <-- IMPORTANT: Set the content type
          ),
        );
      }

      // Send the request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      // Check the response
      if (response.statusCode == 200) {
        print('Images uploaded successfully!');
        print('Response body: $responseBody');
      } else {
        print('Error uploading images: ${response.statusCode}');
        print('Response body: $responseBody');
      }
    } catch (e) {
      print('Error uploading images: $e');
    }
  }

  //update the- reorder
  void updatePhoto({required int newIndex, required int oldIndex}) {
    ///get the current index and remove that from our gallery list
    final myPhoto = photoGllery.removeAt(oldIndex);

    ///Place THE new item in the list
    photoGllery.insert(newIndex, myPhoto);
    update();

    // Note: If the API supports reordering photos, we would make an API call here
    // For now, we're just handling it locally since the current API doesn't
    // appear to have a reordering endpoint. The photos would need to be uploaded
    // in the desired order when uploading new ones.

    // For a future enhancement: Implement API reordering if available
    // final authRepo = Get.find<AuthRepository>();
    // authRepo.reorderProfileImages(oldIndex, newIndex);
  }

  ///remove the photo from gallery
  void deletePhoto(int index) {
    WidgetHelper.showAlertDialog(
      dialogStatus: Status.warning,
      subTitle: 'Are you sure want to delete this photo?',
      buttonText: 'Okay, Delete',
      onTap: () async {
        // Show loading indicator
        Get.back(); // Close confirmation dialog

        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        try {
          final authRepo = Get.find<AuthRepository>();

          final response = await authRepo.deleteProfileImage(index);

          // Close loading dialog
          Get.back();

          if (response.success) {
            // Update local photo list (temporarily)
            photoGllery.removeAt(index);
            update();

            // Force refresh to get updated photo list from server
            await refreshUserData();

            Get.snackbar(
              'Success',
              'Photo deleted successfully',
              duration: const Duration(seconds: 2),
            );
          } else {
            Get.snackbar('Error', response.message);
          }
        } catch (e) {
          // Close loading dialog if still showing
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
          debugPrint('Error deleting image: $e');
          Get.snackbar('Error', 'Failed to delete photo');
        }
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    loadUserData();

    // Set up a listener for changes to the currentUser in AuthController
    final authController = Get.find<AuthController>();
    ever(authController.currentUser, (_) {
      loadUserData();
      debugPrint('👤 ProfileController: User data updated from AuthController');
    });
  }

  /// Load user data from AuthController
  void loadUserData() {
    final authController = Get.find<AuthController>();
    if (authController.currentUser.value != null) {
      debugPrint('👤 ProfileController: Loading user data from AuthController');
      debugPrint(
        '👤 ProfileController: User data - firstName: ${authController.currentUser.value?.firstName}, lastName: ${authController.currentUser.value?.lastName}, email: ${authController.currentUser.value?.email}',
      );

      // Make a direct assignment to ensure we get the current reference
      user.value = authController.currentUser.value;

      // Initialize text controllers with current values
      if (user.value != null) {
        firstNameController.text = user.value!.firstName ?? '';
        lastNameController.text = user.value!.lastName ?? '';
        phoneController.text = user.value!.phoneNumber ?? '';

        // Load photos from the profile
        if (user.value!.profile?.photos != null &&
            user.value!.profile!.photos!.isNotEmpty) {
          debugPrint(
            '📸 ProfileController: Loading ${user.value!.profile!.photos!.length} photos from profile',
          );
          photoGllery.value = user.value!.profile!.photos!;
        } else {
          debugPrint('� ProfileController: No photos found in profile');
          photoGllery.clear();
        }

        debugPrint(
          '�👤 ProfileController: Text controllers updated with - firstName: ${firstNameController.text}, lastName: ${lastNameController.text}',
        );
      } else {
        debugPrint('👤 ProfileController: User value is null after assignment');
      }

      // Explicitly update to ensure the UI refreshes
      update();
    } else {
      debugPrint('👤 ProfileController: AuthController currentUser is null');

      // Try to fetch the user profile again
      authController.fetchUserProfile().then((_) {
        if (authController.currentUser.value != null) {
          user.value = authController.currentUser.value;

          // Load photos from the profile after fetching
          if (user.value!.profile?.photos != null &&
              user.value!.profile!.photos!.isNotEmpty) {
            debugPrint(
              '📸 ProfileController: Loading ${user.value!.profile!.photos!.length} photos from profile after fetch',
            );
            photoGllery.value = user.value!.profile!.photos!;
          } else {
            debugPrint(
              '📸 ProfileController: No photos found in profile after fetch',
            );
            photoGllery.clear();
          }

          update();
          debugPrint(
            '👤 ProfileController: Fetched user data after initial null check',
          );
        }
      });
    }
  }

  /// Force refresh user data from API
  Future<void> refreshUserData() async {
    debugPrint('👤 ProfileController: Forcing data refresh');
    final authController = Get.find<AuthController>();
    await authController.fetchUserProfile();
    loadUserData();
  }

  /// Update first and last name using targeted method
  Future<void> updateFullName() async {
    if (firstNameController.text.isEmpty) {
      Get.snackbar('Error', 'First name cannot be empty');
      return;
    }

    // Show loading indicator
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final authController = Get.find<AuthController>();
      final response = await authController.updateUserNameWithoutNavigation(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
      );

      // Close loading dialog
      Get.back();

      if (response.success) {
        // Refresh local user data
        loadUserData();

        // Show success message and navigate back
        Get.snackbar(
          'Success',
          'Name updated successfully',
          duration: const Duration(seconds: 1),
        );

        // Navigate back after a short delay to allow snackbar to appear
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (Get.currentRoute.contains('update_full_name')) {
            Get.back();
          }
        });
      } else {
        // Show error message
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      // Close loading dialog if still showing
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.snackbar('Error', 'Failed to update name. Please try again.');
    }
  }

  /// Update phone number using targeted method
  Future<void> updatePhoneNumber() async {
    if (phoneController.text.isEmpty) {
      Get.snackbar('Error', 'Phone number cannot be empty');
      return;
    }

    // Show loading indicator
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final authController = Get.find<AuthController>();
      final response = await authController.updateUserPhone(
        phoneNumber: phoneController.text,
      );

      // Close loading dialog
      Get.back();

      if (response.success) {
        // Refresh local user data
        loadUserData();

        // Show success message and navigate back
        Get.snackbar(
          'Success',
          'Phone number updated successfully',
          duration: const Duration(seconds: 1),
        );

        // Navigate back after a short delay to allow snackbar to appear
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (Get.currentRoute.contains('update_phone')) {
            Get.back();
          }
        });
      } else {
        // Show error message
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      // Close loading dialog if still showing
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.snackbar('Error', 'Failed to update phone number. Please try again.');
    }
  }

  /// Shows a safe snackbar that won't conflict with navigation
  void showSafeSnackbar({
    required String title,
    required String message,
    bool navigateBack = false,
    Duration duration = const Duration(seconds: 1),
  }) {
    // Cancel any existing snackbars to avoid conflicts
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      title,
      message,
      duration: duration,
      snackbarStatus: (status) {
        if (navigateBack && status == SnackbarStatus.CLOSED) {
          // Only navigate back after snackbar is fully closed
          Get.back();
        }
      },
    );
  }

  /// Get full name from user data
  String getFullName() {
    final firstName = user.value?.firstName ?? '';
    final lastName = user.value?.lastName ?? '';
    return '$firstName $lastName'.trim().isNotEmpty
        ? '$firstName $lastName'.trim()
        : 'User';
  }

  /// Get email from user data
  String getEmail() {
    return user.value?.email ?? 'No email';
  }

  /// Get phone number from user data
  String getPhoneNumber() {
    return user.value?.phoneNumber ?? 'No phone number';
  }

  /// Get user photos from profile
  List<String> getProfilePhotos() {
    return user.value?.profile?.photos ?? [];
  }
}
