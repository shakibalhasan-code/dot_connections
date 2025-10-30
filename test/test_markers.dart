import 'package:flutter/material.dart';
import 'package:dot_connections/app/core/utils/map_marker_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Test marker creation
  try {
    print('Testing profile marker creation...');

    // Test with profile picture URL
    final markerWithImage = await MapMarkerUtils.createProfileMarker(
      profilePictureUrl: 'https://example.com/profile.jpg',
      initials: 'JD',
      isConnected: false,
      size: 120,
    );
    print('✅ Marker with image created successfully');

    // Test with initials only
    final markerWithInitials = await MapMarkerUtils.createProfileMarker(
      profilePictureUrl: null,
      initials: 'AB',
      isConnected: true,
      size: 120,
    );
    print('✅ Marker with initials created successfully');

    // Test current location marker
    final currentLocationMarker =
        await MapMarkerUtils.createCurrentLocationMarker(size: 100);
    print('✅ Current location marker created successfully');

    print('🎉 All marker tests passed!');
  } catch (e) {
    print('❌ Error in marker tests: $e');
  }
}
