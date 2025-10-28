import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/data/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  // Instead of finding the controller directly, we'll get it when needed
  AuthController? _authController;

  // Getter to ensure the controller is available
  AuthController get authController {
    if (_authController == null) {
      // Try to find existing controller
      if (Get.isRegistered<AuthController>()) {
        _authController = Get.find<AuthController>();
      } else {
        // If not found, make sure repository exists
        if (!Get.isRegistered<AuthRepository>()) {
          Get.put(AuthRepository());
        }
        // Create and register the controller
        _authController = Get.put(
          AuthController(authRepository: Get.find<AuthRepository>()),
        );
      }
    }
    return _authController!;
  }

  @override
  RouteSettings? redirect(String? route) {
    // Check if user is authenticated
    if (authController.isAuthenticated.value) {
      final user = authController.currentUser.value;

      // If we don't have user data yet, proceed to current route
      if (user == null) {
        return null;
      }

      // If basic fields are not filled, redirect to name input
      if (!user.allUserFieldsFilled) {
        return RouteSettings(name: AppRoutes.name);
      }

      // If profile fields are not filled, redirect to profile setup
      if (!user.allProfileFieldsFilled) {
        return RouteSettings(name: AppRoutes.howTall);
      }

      // If attempting to access auth or setup screens when BOTH fields are filled,
      // redirect to main app
      if ((user.allUserFieldsFilled && user.allProfileFieldsFilled) &&
          (route == AppRoutes.initial ||
              route == AppRoutes.email ||
              route == AppRoutes.otp ||
              route == AppRoutes.name ||
              route == AppRoutes.dob)) {
        return RouteSettings(name: AppRoutes.parent);
      }

      // If trying to access parent screen but not all fields are filled, redirect appropriately
      if (route == AppRoutes.parent &&
          !(user.allUserFieldsFilled && user.allProfileFieldsFilled)) {
        if (!user.allUserFieldsFilled) {
          return RouteSettings(name: AppRoutes.name);
        } else if (!user.allProfileFieldsFilled) {
          return RouteSettings(name: AppRoutes.howTall);
        }
      }
    } else {
      // If unauthenticated user tries to access protected routes, redirect to initial
      if (route != AppRoutes.initial &&
          route != AppRoutes.email &&
          route != AppRoutes.otp) {
        return RouteSettings(name: AppRoutes.initial);
      }
    }

    // No redirect needed, proceed to requested route
    return null;
  }
}
