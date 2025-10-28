import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/services/location_services.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:dot_connections/app/data/models/user_personal_data.dart';
import '../controllers/where_live_controller.dart';

class LocationSearchField extends StatelessWidget {
  final WhereLiveController controller;

  const LocationSearchField({Key? key, required this.controller})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller.locationController,
        decoration: InputDecoration(
          hintText: 'Where do you live?',
          hintStyle: AppTextStyle.primaryTextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
        onChanged: (pattern) async {
          if (pattern.isEmpty) return;
          final suggestions = await LocationServices.getPlacePredictions(
            pattern,
          );
          if (suggestions.isNotEmpty) {
            final suggestion = suggestions.first;
            final locationData = await LocationServices.getPlaceDetails(
              suggestion['place_id'],
            );

            if (locationData != null) {
              final latLng = LocationServices.locationToLatLng(locationData);
              controller.selectedLocation.value = latLng;
              controller.mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(latLng, 15),
              );

              final userLocation = Location(
                type: 'Point',
                coordinates: [latLng.longitude, latLng.latitude],
                address: suggestion['description'] ?? '',
              );

              final authController = Get.find<AuthController>();
              authController.currentUserProfile.update((profile) {
                if (profile != null) {
                  profile.location = userLocation;
                }
              });
            }
          }
        },
      ),
    );
  }
}
