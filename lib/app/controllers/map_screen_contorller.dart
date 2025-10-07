import '../core/services/map_services.dart';
import 'package:get/get.dart';

class MapScreenContorller extends GetxController {
  final MapServices _mapServices = MapServices();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _mapServices.initializeGoogleMaps();
  }
}
