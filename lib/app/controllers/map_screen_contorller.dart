import 'package:dot_connections/app/core/services/map_services.dart';
import 'package:dot_connections/app/data/models/nearby_user_model.dart';
import 'package:flutter/rendering.dart';
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
  
  // Search radius in kilometers (default 5km)
  double _searchRadius = 5.0;
  double _pendingRadius = 5.0;
  bool _hasPendingRadiusChange = false;

  // Map elements
  Set<Marker> markers = <Marker>{};
  Set<Polyline> polylines = <Polyline>{};

  // Loading state
  bool isLoading = false;

  // Radius getter and setter
  double get searchRadius => _searchRadius;
  double get pendingRadius => _pendingRadius;
  bool get hasPendingRadiusChange => _hasPendingRadiusChange;
  
  void setSearchRadius(double radius) {
    if (_pendingRadius != radius) {
      _pendingRadius = radius;
      _hasPendingRadiusChange = (_pendingRadius != _searchRadius);
      print('🔄 Pending search radius set to ${radius}km');
      update();
    }
  }
  
  Future<void> applyPendingRadius() async {
    if (_hasPendingRadiusChange) {
      _searchRadius = _pendingRadius;
      _hasPendingRadiusChange = false;
      print('✅ Applied search radius: ${_searchRadius}km');
      update();
      await refreshNearbyUsers();
    }
  }

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
    // Initialize pending radius with current radius
    _pendingRadius = _searchRadius;
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
      final users = await _mapServices.getNearbyUsers(radius: _searchRadius.round());
      nearbyUsers = users;
      connectedUsers = users.where((user) => user.isConnected).toList();

      await _updateMapElements();

      print(
        'Fetched ${nearbyUsers.length} nearby users within ${_searchRadius}km radius, ${connectedUsers.length} connected',
      );
      if (nearbyUsers.isNotEmpty) {
        print(
          'First user location: ${nearbyUsers[0].location.latitude}, ${nearbyUsers[0].location.longitude}',
        );
      }
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
      print('🗺️ Updating map elements for ${nearbyUsers.length} nearby users');
      
      // Clear existing markers and polylines
      markers.clear();
      polylines.clear();

      // Add current location marker
      final currentLocationMarker = _mapServices.createCurrentLocationMarker(
        currentLocation!,
      );
      markers.add(currentLocationMarker);

      // Add user markers only if we have nearby users
      if (nearbyUsers.isNotEmpty) {
        final userMarkers = await _mapServices.createUserMarkers(nearbyUsers);
        markers.addAll(userMarkers);
        print('✅ Added ${userMarkers.length} user markers to map');
      }

      // Add polylines for connected users only if we have connected users
      if (connectedUsers.isNotEmpty) {
        final userPolylines = _mapServices.createPolylines(
          currentLocation!,
          connectedUsers,
        );
        polylines.addAll(userPolylines);
        print('✅ Added ${userPolylines.length} polylines for connected users');
      }

      print('🗺️ Map elements updated: ${markers.length} markers, ${polylines.length} polylines');
      update();
    } catch (e) {
      print('❌ Error updating map elements: $e');
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

      // Fetch nearby users again with current radius
      await _fetchNearbyUsers();

      // Update camera to fit all markers if we have users
      if (_mapController != null && nearbyUsers.isNotEmpty) {
        _fitCameraToBounds();
      }

      Get.snackbar(
        'Success',
        'Found ${nearbyUsers.length} users within ${_searchRadius}km',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('❌ Error refreshing nearby users: $e');
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
