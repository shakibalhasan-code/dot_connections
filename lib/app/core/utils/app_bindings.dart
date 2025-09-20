import 'package:dot_connections/app/controllers/app_initial_controller.dart';
import 'package:dot_connections/app/controllers/find_controller.dart';
import 'package:dot_connections/app/controllers/map_screen_contorller.dart';
import 'package:dot_connections/app/controllers/match_controller.dart';
import 'package:dot_connections/app/controllers/parent_controller.dart';
import 'package:dot_connections/app/controllers/profile_contorller.dart';
import 'package:dot_connections/app/controllers/theme_controller.dart';
import 'package:get/get.dart';

/// AppBindings sets up dependency injection for the entire application
///
/// This class initializes all controllers and services that need to be
/// available globally throughout the app. Using lazy loading ensures
/// controllers are only created when needed, improving app startup time.
///
/// The fenix: true parameter ensures controllers persist across route changes
/// and are automatically recreated if disposed.
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Core app controllers
    Get.lazyPut(() => ThemeController(), fenix: true);
    Get.lazyPut(() => AppInitialController(), fenix: true);

    // Main navigation controllers
    Get.lazyPut(() => ParentController(), fenix: true);

    // Feature-specific controllers
    Get.lazyPut(() => MatchController(), fenix: true);
    Get.lazyPut(() => ProfileContorller(), fenix: true);
    Get.lazyPut(() => FindController(), fenix: true);
    Get.lazyPut(() => MapScreenContorller(), fenix: true);

    // TODO: Add other global services here
    // Examples:
    // Get.lazyPut(() => AuthService(), fenix: true);
    // Get.lazyPut(() => ApiService(), fenix: true);
    // Get.lazyPut(() => StorageService(), fenix: true);
    // Get.lazyPut(() => NotificationService(), fenix: true);
  }
}
