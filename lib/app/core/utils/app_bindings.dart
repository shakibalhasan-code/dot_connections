import 'package:finder/app/controllers/app_initial_controller.dart';
import 'package:finder/app/controllers/find_controller.dart'
    show FindController;
import 'package:finder/app/controllers/language_controller.dart';
import 'package:finder/app/controllers/map_screen_contorller.dart';
import 'package:finder/app/controllers/match_controller.dart';
import 'package:finder/app/controllers/parent_controller.dart';
import 'package:finder/app/controllers/profile_contorller.dart';
import 'package:finder/app/controllers/theme_controller.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Core app controllers
    Get.lazyPut(() => ThemeController(), fenix: true);
    Get.lazyPut(() => AppInitialController(), fenix: true);
    Get.lazyPut(() => LanguageController(), fenix: true);

    // Main navigation controllers
    Get.lazyPut(() => ParentController(), fenix: true);

    // Feature-specific controllers
    Get.lazyPut(() => MatchController(), fenix: true);
    Get.lazyPut(() => ProfileContorller(), fenix: true);
    Get.lazyPut(() => FindController(), fenix: true);
    Get.lazyPut(() => MapScreenContorller(), fenix: true);
  }
}
