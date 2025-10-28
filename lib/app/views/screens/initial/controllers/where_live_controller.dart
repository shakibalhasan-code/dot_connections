import 'package:dot_connections/app/core/services/location_services.dart';
import 'package:dot_connections/app/core/services/map_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WhereLiveController extends GetxController {
  final MapServices _mapServices = MapServices();
  final TextEditingController locationController = TextEditingController();
  GoogleMapController? mapController;
  final Rx<LatLng> selectedLocation = Rx<LatLng>(
    const LatLng(
      23.7104,
      90.4074,
    ), // Default location until we get user's location
  );
  final isMapLoading = true.obs;
  final isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    getUserLocation();
  }

  Future<void> getUserLocation() async {
    final position = await _mapServices.getCurrentLocation();
    if (position != null) {
      selectedLocation.value = LatLng(position.latitude, position.longitude);
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(selectedLocation.value, 15),
      );
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    isMapLoading.value = false;
    getUserLocation(); // Try to get user location when map is ready
  }

  void onCameraMove(CameraPosition position) {
    selectedLocation.value = position.target;
    isSearching.value = true;
  }

  Future<void> onCameraIdle() async {
    try {
      final address = await LocationServices.getAddressFromCoordinates(
        selectedLocation.value.latitude,
        selectedLocation.value.longitude,
      );

      if (address != null) {
        locationController.text = address;
      }
    } catch (e) {
      print('Error getting address: $e');
    } finally {
      isSearching.value = false;
    }
  }

  @override
  void onClose() {
    locationController.dispose();
    mapController?.dispose();
    super.onClose();
  }
}
