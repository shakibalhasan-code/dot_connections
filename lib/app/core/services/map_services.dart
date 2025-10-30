import 'package:dot_connections/app/core/utils/app_utils.dart';
import 'package:dot_connections/app/core/utils/map_marker_utils.dart';
import 'package:dot_connections/app/data/api/nearby_users_api_client.dart';
import 'package:dot_connections/app/data/models/nearby_user_model.dart';
import 'package:dot_connections/app/views/screens/parent/map/widgets/map_user_details_sheet.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MapServices {
  final MatchApiClient _nearbyUsersApi = MatchApiClient();

  // Validate and prepare Google Maps API key from .env
  Future<void> initializeGoogleMaps() async {
    String apiKey = AppUtils.googleMapApiKey; // Get API key from .env

    if (apiKey.isNotEmpty && apiKey != 'your_google_map_api_key_here') {
      print(
        "Google Maps API key loaded from .env: ${apiKey.substring(0, 10)}...",
      );

      // Try to send API key to native platforms via platform channel (optional)
      try {
        await AppUtils.platform.invokeMethod('setGoogleMapsApiKey', {
          'apiKey': apiKey,
        });
        print("Google Maps API key sent to native platforms");
      } catch (e) {
        print(
          "Platform channel not available, but Google Maps should still work with static keys: $e",
        );
        // This is not critical - Google Maps will use the keys in AndroidManifest.xml and Info.plist
      }

      print("Google Maps is ready to use");
    } else {
      print(
        "Google Maps API key is missing or not properly configured in .env file",
      );
      throw Exception("Google Maps API key is required");
    }
  }

  /// Check if location permissions are granted
  Future<bool> hasLocationPermission() async {
    var status = await Permission.location.status;
    return status.isGranted;
  }

  /// Request location permissions
  Future<bool> requestLocationPermission() async {
    var status = await Permission.location.request();
    return status.isGranted;
  }

  /// Get current location
  Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return null;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        return null;
      }

      // Get position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print('Current location: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  /// Fetch nearby users from API
  Future<List<NearbyUser>> getNearbyUsers({int radius = 100}) async {
    try {
      final response = await _nearbyUsersApi.getNearbyUsers(radius: radius);
      if (response.success) {
        print('Successfully fetched ${response.data.length} nearby users');
        return response.data;
      } else {
        print('Failed to fetch nearby users: ${response.message}');
        return [];
      }
    } catch (e) {
      print('Error fetching nearby users: $e');
      return [];
    }
  }

  /// Create markers for nearby users
  Future<Set<Marker>> createUserMarkers(List<NearbyUser> users) async {
    Set<Marker> markers = {};

    for (int i = 0; i < users.length; i++) {
      final user = users[i];

      // Get the first available photo (profile picture or first photo from array)
      String? firstPhotoUrl = user.profilePicture;
      if ((firstPhotoUrl == null || firstPhotoUrl.isEmpty) &&
          user.photos.isNotEmpty) {
        firstPhotoUrl = user.photos.first;
      }

      // Create custom marker with profile picture
      BitmapDescriptor markerIcon = await MapMarkerUtils.createProfileMarker(
        profilePictureUrl: firstPhotoUrl,
        initials: MapMarkerUtils.getInitials(user.name),
        isConnected: user.isConnected,
        size: 120,
      );

      final marker = Marker(
        markerId: MarkerId(user.id),
        position: LatLng(user.location.latitude, user.location.longitude),
        icon: markerIcon,
        infoWindow: InfoWindow(
          title: user.name,
          snippet:
              '${user.age} years old • ${user.distanceKm.toStringAsFixed(1)}km away',
        ),
        onTap: () {
          print('Tapped on user: ${user.name}');
          Get.bottomSheet(
            MapUserDetailsSheet(user: user),
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
          );
        },
      );

      markers.add(marker);
    }

    print('Created ${markers.length} user markers with profile pictures');
    return markers;
  }

  /// Create polylines for connected users
  Set<Polyline> createPolylines(
    Position currentLocation,
    List<NearbyUser> connectedUsers,
  ) {
    Set<Polyline> polylines = {};

    final currentLatLng = LatLng(
      currentLocation.latitude,
      currentLocation.longitude,
    );

    // Filter only connected users
    final connected = connectedUsers.where((user) => user.isConnected).toList();

    for (int i = 0; i < connected.length; i++) {
      final user = connected[i];
      final userLatLng = LatLng(
        user.location.latitude,
        user.location.longitude,
      );

      final polyline = Polyline(
        polylineId: PolylineId('connection_${user.id}'),
        points: [currentLatLng, userLatLng],
        color: const Color(0xFF00FF00), // Green color for connections
        width: 3,
        patterns: [PatternItem.dash(10), PatternItem.gap(5)], // Dashed line
        geodesic: true,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      );

      polylines.add(polyline);
    }

    print('Created ${polylines.length} polylines for connected users');
    return polylines;
  }

  /// Create current location marker
  Future<Marker> createCurrentLocationMarker(Position position) async {
    final markerIcon = await MapMarkerUtils.createCurrentLocationMarker(
      size: 100,
    );

    return Marker(
      markerId: const MarkerId('current_location'),
      position: LatLng(position.latitude, position.longitude),
      icon: markerIcon,
      infoWindow: const InfoWindow(
        title: 'You',
        snippet: 'Your current location',
      ),
    );
  }

  /// Calculate camera position to fit all markers
  CameraPosition calculateCameraPosition(
    Position currentLocation,
    List<NearbyUser> users,
  ) {
    if (users.isEmpty) {
      return CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 15.0,
      );
    }

    // Find bounds that include current location and all users
    double minLat = currentLocation.latitude;
    double maxLat = currentLocation.latitude;
    double minLng = currentLocation.longitude;
    double maxLng = currentLocation.longitude;

    for (final user in users) {
      minLat = minLat < user.location.latitude
          ? minLat
          : user.location.latitude;
      maxLat = maxLat > user.location.latitude
          ? maxLat
          : user.location.latitude;
      minLng = minLng < user.location.longitude
          ? minLng
          : user.location.longitude;
      maxLng = maxLng > user.location.longitude
          ? maxLng
          : user.location.longitude;
    }

    // Calculate center point
    final centerLat = (minLat + maxLat) / 2;
    final centerLng = (minLng + maxLng) / 2;

    return CameraPosition(
      target: LatLng(centerLat, centerLng),
      zoom: 13.0, // You might want to adjust this based on the bounds
    );
  }

  /// Calculate bounds for camera animation
  LatLngBounds calculateBounds(
    Position currentLocation,
    List<NearbyUser> users,
  ) {
    if (users.isEmpty) {
      return LatLngBounds(
        southwest: LatLng(
          currentLocation.latitude - 0.01,
          currentLocation.longitude - 0.01,
        ),
        northeast: LatLng(
          currentLocation.latitude + 0.01,
          currentLocation.longitude + 0.01,
        ),
      );
    }

    double minLat = currentLocation.latitude;
    double maxLat = currentLocation.latitude;
    double minLng = currentLocation.longitude;
    double maxLng = currentLocation.longitude;

    for (final user in users) {
      minLat = minLat < user.location.latitude
          ? minLat
          : user.location.latitude;
      maxLat = maxLat > user.location.latitude
          ? maxLat
          : user.location.latitude;
      minLng = minLng < user.location.longitude
          ? minLng
          : user.location.longitude;
      maxLng = maxLng > user.location.longitude
          ? maxLng
          : user.location.longitude;
    }

    // Add some padding
    const padding = 0.005;
    return LatLngBounds(
      southwest: LatLng(minLat - padding, minLng - padding),
      northeast: LatLng(maxLat + padding, maxLng + padding),
    );
  }
}
