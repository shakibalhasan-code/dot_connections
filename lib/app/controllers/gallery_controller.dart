import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/data/models/auth_models.dart';
import 'package:dot_connections/app/data/repo/auth_repo.dart';
import 'package:dot_connections/app/data/repo/i_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for managing gallery operations
class GalleryController extends GetxController {
  final IAuthRepository _authRepository;
  final AuthController _authController = Get.find<AuthController>();

  // Observable state variables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<String> selectedImages = <String>[].obs;

  GalleryController({IAuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository();

  /// Adds a path to the selected images
  void addSelectedImage(String path) {
    if (!selectedImages.contains(path)) {
      selectedImages.add(path);
    }
  }

  /// Removes a path from the selected images
  void removeSelectedImage(String path) {
    selectedImages.remove(path);
  }

  /// Clears the selected images
  void clearSelectedImages() {
    selectedImages.clear();
  }

  /// Uploads multiple images to the user's profile gallery
  // Future<void> uploadMultipleGalleryImages() async {
  //   if (selectedImages.isEmpty) {
  //     Get.snackbar(
  //       'Error',
  //       'No images selected',
  //       backgroundColor: Colors.red.withOpacity(0.3),
  //     );
  //     return;
  //   }

  //   try {
  //     isLoading.value = true;
  //     errorMessage.value = '';

  //     print('📸 Uploading ${selectedImages.length} images to gallery');

  //     final response = await _authRepository.uploadProfileImages(
  //       imagePaths: selectedImages.toList(),
  //     );

  //     if (response.success) {
  //       print('📸 Successfully uploaded gallery images');

  //       // Refresh user profile to get the latest data including updated photo gallery
  //       await _authController.fetchUserProfile();

  //       // If user doesn't have a profile pic yet, set the first image as profile pic
  //       if (_authController.currentUser.value != null &&
  //           _authController.currentUser.value!.image == null &&
  //           _authController.currentUser.value!.profile != null &&
  //           _authController.currentUser.value!.profile!.photos != null &&
  //           _authController.currentUser.value!.profile!.photos!.isNotEmpty) {
  //         print('📸 Setting first gallery image as profile picture');
  //         await _authController.updateUserImage(
  //           imagePath: selectedImages.first,
  //         );
  //       }

  //       // Clear selected images after successful upload
  //       clearSelectedImages();

  //       Get.snackbar(
  //         'Success',
  //         'Photos added to gallery successfully',
  //         duration: const Duration(seconds: 1),
  //       );
  //     } else {
  //       print('📸 Failed to upload gallery images: ${response.message}');
  //       errorMessage.value = response.message;
  //       Get.snackbar('Error', 'Failed to upload photos: ${response.message}');
  //     }
  //   } catch (e) {
  //     print('📸 Exception when uploading gallery images: $e');
  //     errorMessage.value = 'Failed to upload photos: $e';
  //     Get.snackbar('Error', 'Failed to upload photos');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  /// Uploads a single image to the user's profile gallery
  // Future<void> uploadSingleGalleryImage(String imagePath) async {
  //   try {
  //     isLoading.value = true;
  //     errorMessage.value = '';

  //     print('📸 Uploading single image to gallery: $imagePath');

  //     final response = await _authRepository.uploadProfileImages(
  //       imagePaths: [imagePath],
  //     );

  //     if (response.success) {
  //       print('📸 Successfully uploaded gallery image');

  //       // Refresh user profile to get the latest data
  //       await _authController.fetchUserProfile();

  //       // If user doesn't have a profile pic yet, set this image as profile pic
  //       if (_authController.currentUser.value != null &&
  //           _authController.currentUser.value!.image == null &&
  //           _authController.currentUser.value!.profile != null &&
  //           _authController.currentUser.value!.profile!.photos != null &&
  //           _authController.currentUser.value!.profile!.photos!.isNotEmpty) {
  //         print('📸 Setting gallery image as profile picture');
  //         await _authController.updateUserImage(imagePath: imagePath);
  //       }

  //       Get.snackbar(
  //         'Success',
  //         'Photo added to gallery successfully',
  //         duration: const Duration(seconds: 1),
  //       );
  //     } else {
  //       print('📸 Failed to upload gallery image: ${response.message}');
  //       errorMessage.value = response.message;
  //       Get.snackbar('Error', 'Failed to upload photo: ${response.message}');
  //     }
  //   } catch (e) {
  //     print('📸 Exception when uploading gallery image: $e');
  //     errorMessage.value = 'Failed to upload photo: $e';
  //     Get.snackbar('Error', 'Failed to upload photo');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  /// Deletes a profile image by index
  Future<AuthResponse> deleteProfileImage(int imageIndex) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('📸 Deleting profile image at index: $imageIndex');

      final response = await _authRepository.deleteProfileImage(imageIndex);

      if (response.success) {
        print('📸 Successfully deleted profile image');

        // Refresh user profile to get the latest data
        await _authController.fetchUserProfile();

        Get.snackbar(
          'Success',
          'Photo deleted successfully',
          duration: const Duration(seconds: 1),
        );
      } else {
        print('📸 Failed to delete profile image: ${response.message}');
        errorMessage.value = response.message;
        Get.snackbar('Error', 'Failed to delete photo: ${response.message}');
      }

      return response;
    } catch (e) {
      print('📸 Exception when deleting profile image: $e');
      errorMessage.value = 'Failed to delete photo: $e';
      Get.snackbar('Error', 'Failed to delete photo');
      return AuthResponse(
        success: false,
        message: 'Failed to delete photo: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
