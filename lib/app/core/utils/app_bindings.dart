import 'package:dot_connections/app/controllers/app_initial_controller.dart';
import 'package:dot_connections/app/controllers/find_controller.dart';
import 'package:dot_connections/app/controllers/map_screen_contorller.dart';
import 'package:dot_connections/app/controllers/match_controller.dart';
import 'package:dot_connections/app/controllers/parent_controller.dart';
import 'package:dot_connections/app/controllers/profile_contorller.dart';
import 'package:dot_connections/app/views/screens/parent/map/map_screen.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppInitialController(), fenix: true);
    Get.lazyPut(() => ParentController(), fenix: true);
    Get.lazyPut(() => MatchController(), fenix: true);
    Get.lazyPut(() => ProfileContorller(), fenix: true);
    Get.lazyPut(() => FindController(), fenix: true);
    Get.lazyPut(() => MapScreenContorller(), fenix: true);
  }
}
