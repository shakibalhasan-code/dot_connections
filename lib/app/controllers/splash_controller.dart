import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/data/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for the splash screen
///
/// This controller is responsible for:
/// - Checking authentication status
/// - Handling initial app loading
/// - Redirecting to appropriate screen based on auth status
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

        // Fetch user profile in background
        await _authController.fetchUserProfile();

        // Navigate to ParentScreen
        Get.offAllNamed(AppRoutes.parent);
      } else {
        debugPrint('🔑 No token found, user is not authenticated');
        // Navigate to initial screen for authentication
        Get.offAllNamed(AppRoutes.initial);
      }
    } catch (e) {
      debugPrint('🔑 Error checking auth status: $e');
      // In case of error, navigate to initial screen
      Get.offAllNamed(AppRoutes.initial);
    } finally {
      isLoading.value = false;
    }
  }
}
