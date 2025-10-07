import '../../../../controllers/map_screen_contorller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapScreenContorller>(
      builder: (controller) {
        return Scaffold(
          body: FlutterMap(
            options: MapOptions(
              onTap: (tapPosition, latLng) {},
              onMapReady: () {},
              initialCenter: LatLng(49.2827, -123.1207),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
            ],
          ),
        );
      },
    );
  }
}
