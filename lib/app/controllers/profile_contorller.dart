import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/helper/widget_helper.dart';
import 'package:dot_connections/app/data/models/auth_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Added for CircularProgressIndicator
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileContorller extends GetxController {
  // Text controllers for editing user data
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Observable user data
  final Rx<UserDto?> user = Rx<UserDto?>(null);

  ///list of photo_gallery
  final photoGllery = RxList<String>([
    'https://plus.unsplash.com/premium_photo-1688740375397-34605b6abe48?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8ZmVtYWxlJTIwcHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D',
    'https://www.shutterstock.com/image-photo/close-head-shot-portrait-preppy-600nw-1433809418.jpg',
    'https://c.pxhere.com/photos/42/e1/blond_female_girl_model_person_portrait_woman-911371.jpg!d',
  ]);

  ///instances
  final ImagePicker imagePicker = ImagePicker();

  ///selected_files/value
  late XFile selectedImage;

  /// PHOTO-GALLERY LOGIC <=======================

  ///pick the image and upload it as user profile image
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

        // Upload image
        final authController = Get.find<AuthController>();
        await authController.updateUserImage(imagePath: imagePicked.path);

        // Close loading dialog
        Get.back();

        // Refresh local user data
        loadUserData();
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

  //update the- reorder
  void updatePhoto({required int newIndex, required int oldIndex}) {
    ///get the current index and remove that from our gallery list
    final myPhoto = photoGllery.removeAt(oldIndex);

    ///Place THE new item in the list
    photoGllery.insert(newIndex, myPhoto);
    update();
  }

  ///remove the photo from gallery
  void deletePhoto(int index) {
    WidgetHelper.showAlertDialog(
      dialogStatus: Status.warning,
      subTitle: 'Are you sure want to delete this photo?',
      buttonText: 'Okay, Delete',
      onTap: () {
        photoGllery.removeAt(index);
        update();
        Get.back();
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

        debugPrint(
          '👤 ProfileController: Text controllers updated with - firstName: ${firstNameController.text}, lastName: ${lastNameController.text}',
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
}
