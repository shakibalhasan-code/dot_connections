import 'package:dot_connections/app/core/services/map_services.dart';
import 'package:dot_connections/app/data/models/nearby_user_model.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreenContorller extends GetxController {
  final MapServices _mapServices = MapServices();

  // Google Maps Controller
  GoogleMapController? _mapController;

  // Location and user data
  Position? currentLocation;
  List<NearbyUser> nearbyUsers = [];
  List<NearbyUser> connectedUsers = [];

  // Map elements
  Set<Marker> markers = <Marker>{};
  Set<Polyline> polylines = <Polyline>{};

  // Loading state
  bool isLoading = false;

  // Initial camera position (will be updated when location is obtained)
  CameraPosition get initialCameraPosition {
    if (currentLocation != null) {
      print(
        '🎯 Using current location for camera: ${currentLocation!.latitude}, ${currentLocation!.longitude}',
      );
      return CameraPosition(
        target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
        zoom: 14.0,
      );
    }
    // Default to Dhaka, Bangladesh if no location
    print('🎯 Using default location for camera: Dhaka');
    return const CameraPosition(target: LatLng(23.8103, 90.4125), zoom: 14.0);
  }

  @override
  void onInit() {
    print('🎯 MapScreenController onInit called');
    super.onInit();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      setLoading(true);
      print('🚀 Starting map initialization...');

      // Initialize Google Maps
      print('🔑 Initializing Google Maps API...');
      await _mapServices.initializeGoogleMaps();
      print('✅ Google Maps API initialized');

      // Get current location
      print('📍 Getting current location...');
      await _getCurrentLocation();
      print('✅ Current location obtained');

      // Fetch nearby users
      print('👥 Fetching nearby users...');
      await _fetchNearbyUsers();
      print('✅ Nearby users fetched');
    } catch (e) {
      print('❌ Error initializing map: $e');
      Get.snackbar(
        'Error',
        'Failed to initialize map: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setLoading(false);
      print('🏁 Map initialization finished. Loading: $isLoading');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      print('📍 Getting current location...');
      final position = await _mapServices.getCurrentLocation();
      if (position != null) {
        currentLocation = position;
        print('📍 Location set, calling update()');
        update();
        print(
          '✅ Current location obtained: ${position.latitude}, ${position.longitude}',
        );
      } else {
        print('❌ Current location is null');
        Get.snackbar(
          'Location Error',
          'Could not get your current location',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('❌ Error getting current location: $e');
    }
  }

  Future<void> _fetchNearbyUsers() async {
    try {
      final users = await _mapServices.getNearbyUsers(radius: 100);
      nearbyUsers = users;
      connectedUsers = users.where((user) => user.isConnected).toList();

      await _updateMapElements();

      print(
        'Fetched ${nearbyUsers.length} nearby users, ${connectedUsers.length} connected',
      );
      update();
    } catch (e) {
      print('Error fetching nearby users: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch nearby users: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _updateMapElements() async {
    if (currentLocation == null) return;

    try {
      // Clear existing markers and polylines
      markers.clear();
      polylines.clear();

      // Add current location marker
      final currentLocationMarker = _mapServices.createCurrentLocationMarker(
        currentLocation!,
      );
      markers.add(currentLocationMarker);

      // Add user markers
      final userMarkers = await _mapServices.createUserMarkers(nearbyUsers);
      markers.addAll(userMarkers);

      // Add polylines for connected users
      final userPolylines = _mapServices.createPolylines(
        currentLocation!,
        connectedUsers,
      );
      polylines.addAll(userPolylines);

      update();
    } catch (e) {
      print('Error updating map elements: $e');
    }
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // Move camera to fit all markers if we have users
    if (currentLocation != null && nearbyUsers.isNotEmpty) {
      _fitCameraToBounds();
    }
  }

  void _fitCameraToBounds() {
    if (_mapController == null || currentLocation == null) return;

    try {
      final bounds = _mapServices.calculateBounds(
        currentLocation!,
        nearbyUsers,
      );
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100.0),
      );
    } catch (e) {
      print('Error fitting camera to bounds: $e');
    }
  }

  void moveToCurrentLocation() {
    if (_mapController == null || currentLocation == null) return;

    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
          zoom: 16.0,
        ),
      ),
    );
  }

  Future<void> refreshNearbyUsers() async {
    try {
      setLoading(true);

      // Refresh current location
      await _getCurrentLocation();

      // Fetch nearby users again
      await _fetchNearbyUsers();

      Get.snackbar(
        'Success',
        'Nearby users refreshed',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error refreshing nearby users: $e');
      Get.snackbar(
        'Error',
        'Failed to refresh nearby users',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool loading) {
    isLoading = loading;
    update();
  }

  @override
  void onClose() {
    _mapController?.dispose();
    super.onClose();
  }
}
