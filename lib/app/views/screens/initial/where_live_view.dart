import 'package:dot_connections/app/controllers/app_initial_controller.dart';
import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/utils/app_utils.dart'; // Assuming your API key is here
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:dot_connections/app/data/models/user_personal_data.dart'
    as user_models;
import 'package:dot_connections/app/views/screens/initial/workplace_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';

class WhereLiveView extends StatelessWidget {
  const WhereLiveView({super.key});

  static final searchTheme = ThemeData(
    useMaterial3: true,
    searchBarTheme: const SearchBarThemeData(
      shadowColor: MaterialStatePropertyAll(Colors.transparent),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppInitialController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Where do you live?",
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "By sharing your location, get match near you",
                  style: AppTextStyle.primaryTextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Obx(
                          () => GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: controller.selectedLocation.value,
                              zoom: 15,
                            ),
                            onMapCreated: controller.onMapCreated,
                            onCameraMove: controller.onCameraMove,
                            onCameraIdle: controller.onCameraIdle,
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                            zoomControlsEnabled: false,
                            markers: controller.mapMarkers.toSet(),
                          ),
                        ),
                      ),
                      if (controller.isMapLoading.value)
                        Center(
                          child: Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: const CircularProgressIndicator(),
                          ),
                        ),
                      if (controller.isSearching.value)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            margin: EdgeInsets.all(8.r),
                            padding: EdgeInsets.symmetric(
                              vertical: 8.r,
                              horizontal: 16.r,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 16.r,
                                  height: 16.r,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 8.r),
                                Text(
                                  'Getting address...',
                                  style: AppTextStyle.primaryTextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
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
                  child: GooglePlacesAutoCompleteTextFormField(
                    textEditingController: controller.locationController,
                    config: GoogleApiConfig(
                      apiKey: AppUtils.googleMapApiKey,
                      fetchPlaceDetailsWithCoordinates: true,
                      debounceTime: 400,
                    ),
                    onPredictionWithCoordinatesReceived: (prediction) {
                      if (prediction.lat != null && prediction.lng != null) {
                        print("Selected Address: ${prediction.description}");
                        print("Latitude: ${prediction.lat}");
                        print("Longitude: ${prediction.lng}");

                        final newLocation = LatLng(
                          double.parse(prediction.lat!),
                          double.parse(prediction.lng!),
                        );

                        controller.selectedLocation.value = newLocation;
                        controller.locationController.text =
                            prediction.description ?? '';

                        // Update marker for the selected location
                        controller.updateSelectedLocationMarker(
                          newLocation,
                          prediction.description ?? '',
                        );

                        // Move the map to the selected location
                        controller.mapController?.animateCamera(
                          CameraUpdate.newLatLng(newLocation),
                        );
                      }
                    },
                    onSuggestionClicked: (prediction) {
                      controller.locationController.text =
                          prediction.description!;
                      controller
                          .locationController
                          .selection = TextSelection.fromPosition(
                        TextPosition(offset: prediction.description!.length),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {
                    final authController = Get.find<AuthController>();
                    final location = user_models.Location(
                      type: 'Point',
                      coordinates: [
                        controller.selectedLocation.value.longitude,
                        controller.selectedLocation.value.latitude,
                      ],
                      address: controller.locationController.text,
                    );

                    // Update current user profile with new location
                    authController.currentUserProfile.update((profile) {
                      profile?.location = location;
                    });

                    // Save the profile changes
                    authController.updateProfile({
                      'location': {
                        'type': location.type,
                        'coordinates': location.coordinates,
                        'address': location.address,
                      },
                    });

                    Get.to(() => WorkplaceView());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: AppTextStyle.primaryTextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
