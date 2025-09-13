import 'package:dot_connections/app/controllers/app_initial_controller.dart';
import 'package:dot_connections/app/controllers/profile_contorller.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppInitialController(),fenix: true);
    Get.lazyPut(() => ProfileContorller(), fenix: true);
  }
}
