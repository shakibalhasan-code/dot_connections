import 'package:dot_connections/app/controllers/map_screen_contorller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapScreenContorller controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<MapScreenContorller>();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapScreenContorller>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: Stack(
            children: [
              // Google Maps
              _buildMapWidget(controller),

              // Search bar at the top
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 20,
                right: 70, // Make room for settings button
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      const Icon(Icons.search, color: Colors.grey, size: 20),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search location',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: controller.refreshNearbyUsers,
                        icon: controller.isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.refresh,
                                color: Colors.grey,
                                size: 20,
                              ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),

              // Settings button (top right)
              Positioned(
                top: MediaQuery.of(context).padding.top + 18,
                right: 20,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Handle settings action
                      _showMapSettings(context, controller);
                    },
                    icon: const Icon(Icons.tune, color: Colors.grey, size: 20),
                  ),
                ),
              ),

              // Connected users info panel
              if (controller.connectedUsers.isNotEmpty)
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${controller.connectedUsers.length} Connected Users',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...controller.connectedUsers.map(
                          (user) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    '${user.name} (${user.distanceKm.toStringAsFixed(1)}km)',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Loading overlay
              if (controller.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Loading nearby users...'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: controller.moveToCurrentLocation,
            child: const Icon(Icons.my_location),
          ),
        );
      },
    );
  }

  Widget _buildMapWidget(MapScreenContorller controller) {
    if (controller.currentLocation == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Getting your location...'),
            const SizedBox(height: 8),
            Text(
              'Loading: ${controller.isLoading}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Test button to manually trigger map initialization
                print('🔄 Manual map initialization triggered');
                controller.refreshNearbyUsers();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    try {
      return GoogleMap(
        onMapCreated: (GoogleMapController mapController) {
          print('🗺️ GoogleMap onMapCreated called successfully');
          controller.onMapCreated(mapController);
        },
        initialCameraPosition: controller.initialCameraPosition,
        markers: controller.markers,
        polylines: controller.polylines,
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        mapType: MapType.normal,
        zoomControlsEnabled: false,
        compassEnabled: true,
        rotateGesturesEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        tiltGesturesEnabled: true,
        buildingsEnabled: true,
        indoorViewEnabled: true,
        trafficEnabled: false,
        onCameraMove: (CameraPosition position) {
          // Handle camera movement
        },
      );
    } catch (e) {
      print('❌ Error creating GoogleMap widget: $e');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            const Text('Failed to load map'),
            const SizedBox(height: 8),
            Text('Error: $e', style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Trigger rebuild
                });
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
  }

  void _showMapSettings(BuildContext context, MapScreenContorller controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Map Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Refresh Nearby Users'),
              onTap: () {
                Navigator.pop(context);
                controller.refreshNearbyUsers();
              },
            ),
            ListTile(
              leading: const Icon(Icons.my_location),
              title: const Text('Go to My Location'),
              onTap: () {
                Navigator.pop(context);
                controller.moveToCurrentLocation();
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: Text('Show ${controller.nearbyUsers.length} Nearby Users'),
              onTap: () {
                Navigator.pop(context);
                // Could show a list of users
              },
            ),
            ListTile(
              leading: const Icon(Icons.timeline),
              title: Text(
                'Connected Users: ${controller.connectedUsers.length}',
              ),
              onTap: () {
                Navigator.pop(context);
                // Could show connected users details
              },
            ),
          ],
        ),
      ),
    );
  }
}
