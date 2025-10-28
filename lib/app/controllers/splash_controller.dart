import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/data/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final AuthRepository _authRepository;
  final AuthController _authController;

  // Observable state variables
  final RxBool isLoading = true.obs;

  SplashController({
    AuthRepository? authRepository,
    AuthController? authController,
  }) : _authRepository = authRepository ?? Get.find<AuthRepository>(),
       _authController = authController ?? Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    // Check auth status after a short delay to allow splash screen to show
    _checkAuthStatus();
  }

  /// Checks if the user is authenticated and navigates accordingly
  Future<void> _checkAuthStatus() async {
    try {
      isLoading.value = true;

      // Wait for animation to play at least 2 seconds
      await Future.delayed(const Duration(seconds: 2));

      // Check if we have an auth token
      final token = await _authRepository.getAuthToken();

      if (token != null) {
        debugPrint('🔑 Token found, user is authenticated');
        _authController.isAuthenticated.value = true;

        try {
          // Fetch user profile
          final profileResponse = await _authController.fetchUserProfile();
          if (!profileResponse.success) {
            debugPrint('❌ Failed to fetch user profile');
            Get.snackbar(
              'Error',
              'Failed to load user profile',
              duration: const Duration(seconds: 3),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
            );
            // Clear token and navigate to initial screen
            await _authRepository.removeAuthToken();
            _authController.isAuthenticated.value = false;
            Get.offAllNamed(AppRoutes.initial);
            return;
          }

          // If profile fetch was successful, navigate to ParentScreen
          Get.offAllNamed(AppRoutes.parent);
        } catch (e) {
          debugPrint('❌ Error fetching user profile: $e');
          Get.snackbar(
            'Error',
            'Failed to load user profile',
            duration: const Duration(seconds: 3),
            snackPosition: SnackPosition.BOTTOM,
          );
          // Clear token and navigate to initial screen
          await _authRepository.removeAuthToken();
          _authController.isAuthenticated.value = false;
          Get.offAllNamed(AppRoutes.initial);
        }
      } else {
        debugPrint('🔑 No token found, user is not authenticated');
        // Navigate to initial screen for authentication
        Get.offAllNamed(AppRoutes.initial);
      }
    } catch (e) {
      debugPrint('🔑 Error checking auth status: $e');
      Get.snackbar(
        'Error',
        'Authentication error',
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      );
      // In case of error, navigate to initial screen
      Get.offAllNamed(AppRoutes.initial);
    } finally {
      isLoading.value = false;
    }
  }
}
