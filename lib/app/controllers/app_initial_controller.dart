import 'dart:async';
import 'package:dot_connections/app/core/services/location_services.dart';
import 'package:dot_connections/app/core/services/map_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppInitialController extends GetxController {
  final emailController = TextEditingController();
  final RxString email = ''.obs;
  final RxBool isMarketingChecked = true.obs;
  final otpController = TextEditingController();
  final RxString otp = ''.obs;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final RxString firstName = ''.obs;
  final RxString lastName = ''.obs;

  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxInt age = 0.obs;

  final RxBool notificationsEnabled = false.obs;

  final List<String> heights = [
    "5'3\" (161 cm)",
    "5'4\" (163 cm)",
    "5'5\" (165 cm)",
    "5'6\" (167 cm)",
    "5'7\" (169 cm)",
    "5'8\" (171 cm)",
    "5'9\" (173 cm)",
  ];
  final RxString selectedHeight = "5'6\" (167 cm)".obs;

  // Map and location search state
  GoogleMapController? mapController;
  final RxBool isMapLoading = true.obs;
  final RxBool isSearching = false.obs;
  final Rx<LatLng> selectedLocation = LatLng(
    23.7104,
    90.4074,
  ).obs; // Default to Dhaka
  final RxList<Map<String, dynamic>> searchResults =
      <Map<String, dynamic>>[].obs;
  Timer? _debounceTimer;

  // Map markers
  final RxSet<Marker> mapMarkers = <Marker>{}.obs;

  // Updated to match API format - lowercase
  final List<String> datingOptions = ['Men', 'Women', 'Everyone'];
  final List<String> datingApiValues = ['male', 'female', 'everyone'];
  final RxString datingPreference = 'Everyone'.obs;

  // Updated to match API format - lowercase
  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> genderApiValues = ['male', 'female', 'other'];
  final RxString gender = 'Male'.obs;
  final RxBool showGenderOnProfile = false.obs;

  final locationController = TextEditingController();

  // Updated display values for passions
  final List<String> passions = [
    'Travel',
    'Photography',
    'Fitness',
    'Cooking',
    'Music',
    'Art',
    'Reading',
    'Movies',
    'Hiking',
    'Dancing',
    'Gaming',
    'Fashion',
    'Sports',
    'Yoga',
    'Craft Beer',
    'Tango',
    'Pets',
  ];

  // API format values for passions (lowercase with underscores)
  final List<String> passionsApiValues = [
    'travel',
    'photography',
    'fitness',
    'cooking',
    'music',
    'art',
    'reading',
    'movies',
    'hiking',
    'dancing',
    'gaming',
    'fashion',
    'sports',
    'yoga',
    'craft_beer',
    'tango',
    'pets',
  ];
  final RxList<String> selectedPassions = <String>[].obs;

  final workplaceController = TextEditingController();
  final RxBool showWorkplaceOnProfile = false.obs;

  final hometownController = TextEditingController();
  final RxBool showHometownOnProfile = false.obs;

  final jobTitleController = TextEditingController();
  final RxBool showJobTitleOnProfile = false.obs;

  // Updated lookingFor options and default value
  final List<String> lookingForOptions = [
    'What are you looking for?',
    'Friendship',
    'Dating',
    'Relationship',
    'Networking',
  ];
  final List<String> lookingForApiValues = [
    'dating',
    'friendship',
    'dating',
    'relationship',
    'networking',
  ];

  final RxString lookingFor = 'What are you looking for?'.obs;
  final minAgeController = TextEditingController();
  final maxAgeController = TextEditingController();
  final RxDouble maxDistance = 25.0.obs;

  final List<String> educationOptions = [
    'High school',
    'Under graduation',
    'Post graduation',
    'Prefer Not to Say',
  ];

  final List<String> educationApiValues = [
    'highSchool',
    'underGraduation',
    'postGraduation',
    'preferNotToSay',
  ];
  final RxString selectedEducation = ''.obs;
  final RxBool showEducationOnProfile = false.obs;

  final List<String> religionOptions = [
    'Buddhist',
    'Catholic',
    'Christian',
    'Hindu',
    'Jewish',
    'Muslim',
    'Spiritual',
    'Agnostic',
    'Atheist',
    'Other',
    'Prefer Not to Say',
  ];

  final List<String> religionApiValues = [
    'buddhist',
    'catholic',
    'christian',
    'hindu',
    'jewish',
    'muslim',
    'spiritual',
    'agnostic',
    'atheist',
    'other',
    'prefer_not_to_say',
  ];
  final RxString selectedReligion = ''.obs;
  final RxBool showReligionOnProfile = false.obs;

  final List<String> drinkOptions = [
    'Yes',
    'Occasionally',
    'No',
    'Prefer Not to Say',
  ];

  // No conversion needed as API values match display values
  final RxString selectedDrink = ''.obs;
  final RxBool showDrinkOnProfile = false.obs;

  final List<String> smokeOptions = [
    'Yes',
    'Occasionally',
    'No',
    'Prefer Not to Say',
  ];

  // No conversion needed as API values match display values
  final RxString selectedSmoke = ''.obs;
  final RxBool showSmokeOnProfile = false.obs;

  final bioController = TextEditingController();

  bool get isEmailButtonEnabled =>
      email.value.isNotEmpty && GetUtils.isEmail(email.value);
  bool get isOtpButtonEnabled => otp.value.length == 6;
  bool get isNameButtonEnabled => firstName.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      email.value = emailController.text;
      update();
    });
    otpController.addListener(() {
      otp.value = otpController.text;
      update();
    });
    firstNameController.addListener(() {
      firstName.value = firstNameController.text;
      update();
    });
    lastNameController.addListener(() {
      lastName.value = lastNameController.text;
      update();
    });
  }

  void toggleMarketing(bool? value) {
    isMarketingChecked.value = value ?? false;
    update();
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
    age.value = DateTime.now().year - selectedDate.value.year;
    update();
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    update();
  }

  void setHeight(String height) {
    selectedHeight.value = height;
    update();
  }

  void setDatingPreference(String preference) {
    datingPreference.value = preference;
    update();
  }

  void setGender(String newGender) {
    gender.value = newGender;
    update();
  }

  void toggleShowGender(bool value) {
    showGenderOnProfile.value = value;
    update();
  }

  void togglePassion(String passion) {
    if (selectedPassions.contains(passion)) {
      selectedPassions.remove(passion);
    } else {
      selectedPassions.add(passion);
    }
    update();
  }

  void toggleShowWorkplace(bool value) {
    showWorkplaceOnProfile.value = value;
    update();
  }

  void toggleShowHometown(bool value) {
    showHometownOnProfile.value = value;
    update();
  }

  void toggleShowJobTitle(bool value) {
    showJobTitleOnProfile.value = value;
    update();
  }

  void setLookingFor(String value) {
    lookingFor.value = value;
    update();
  }

  void setMaxDistance(double value) {
    maxDistance.value = value;
    update();
  }

  void setEducation(String value) {
    selectedEducation.value = value;
    update();
  }

  void toggleShowEducation(bool value) {
    showEducationOnProfile.value = value;
    update();
  }

  void setReligion(String value) {
    selectedReligion.value = value;
    update();
  }

  void toggleShowReligion(bool value) {
    showReligionOnProfile.value = value;
    update();
  }

  void setDrink(String value) {
    selectedDrink.value = value;
    update();
  }

  void toggleShowDrink(bool value) {
    showDrinkOnProfile.value = value;
    update();
  }

  void setSmoke(String value) {
    selectedSmoke.value = value;
    update();
  }

  void toggleShowSmoke(bool value) {
    showSmokeOnProfile.value = value;
    update();
  }

  // Map related methods
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    isMapLoading.value = false;

    // Initialize with selected location marker
    createLocationMarker(
      selectedLocation.value,
      title: 'Your Location',
      snippet: locationController.text.isNotEmpty
          ? locationController.text
          : 'Current location',
    );

    // Initialize current location if not already set
    initializeCurrentLocation();

    update();
  }

  void onCameraMove(CameraPosition position) {
    selectedLocation.value = position.target;
    // Update marker position as camera moves
    updateSelectedLocationMarker(position.target, locationController.text);
  }

  void onCameraIdle() async {
    isSearching.value = true;
    update();

    final address = await LocationServices.getAddressFromCoordinates(
      selectedLocation.value.latitude,
      selectedLocation.value.longitude,
    );

    if (address != null) {
      locationController.text = address;
    }

    isSearching.value = false;
    update();
  }

  // Marker management methods
  void createLocationMarker(
    LatLng location, {
    String title = 'Selected Location',
    String snippet = '',
  }) {
    final marker = Marker(
      markerId: const MarkerId('selected_location'),
      position: location,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: title, snippet: snippet),
    );

    // Remove any existing location marker and add the new one
    mapMarkers.removeWhere(
      (marker) => marker.markerId.value == 'selected_location',
    );
    mapMarkers.add(marker);
    update();
  }

  void createCurrentLocationMarker(LatLng location) {
    final marker = Marker(
      markerId: const MarkerId('current_location'),
      position: location,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: const InfoWindow(
        title: 'Your Current Location',
        snippet: 'This is where you are',
      ),
    );

    // Remove any existing current location marker and add the new one
    mapMarkers.removeWhere(
      (marker) => marker.markerId.value == 'current_location',
    );
    mapMarkers.add(marker);
    update();
  }

  void updateSelectedLocationMarker(LatLng location, String address) {
    createLocationMarker(
      location,
      title: 'Selected Location',
      snippet: address.isNotEmpty ? address : 'Selected location on map',
    );
  }

  // Initialize user's current location
  Future<void> initializeCurrentLocation() async {
    try {
      // Create MapServices instance to get current location
      final mapServices = MapServices();
      final position = await mapServices.getCurrentLocation();
      if (position != null) {
        final currentLatLng = LatLng(position.latitude, position.longitude);

        // Update selected location to current location if it's still default
        if (selectedLocation.value.latitude == 23.7104 &&
            selectedLocation.value.longitude == 90.4074) {
          selectedLocation.value = currentLatLng;

          // Get address for current location
          final address = await LocationServices.getAddressFromCoordinates(
            position.latitude,
            position.longitude,
          );

          if (address != null) {
            locationController.text = address;
          }

          // Create marker for current location
          createLocationMarker(
            currentLatLng,
            title: 'Your Current Location',
            snippet: address ?? 'Current location',
          );

          // Animate map to current location
          mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(currentLatLng, 15),
          );
        }
      }
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  // Location search methods
  void searchPlaces(String query) {
    // Clear the previous timer
    _debounceTimer?.cancel();

    // Clear results if query is empty
    if (query.isEmpty) {
      clearSearchResults();
      return;
    }

    // Debounce the search to avoid too many API calls
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      isSearching.value = true;
      update();

      try {
        final results = await LocationServices.getPlacePredictions(query);
        searchResults.value = results;
      } catch (e) {
        print('Error searching places: $e');
      }

      isSearching.value = false;
      update();
    });
  }

  void clearSearchResults() {
    searchResults.clear();
    update();
  }

  void selectPlace(Map<String, dynamic> place) async {
    isSearching.value = true;
    update();

    try {
      final placeId = place['place_id'];
      final locationData = await LocationServices.getPlaceDetails(placeId);

      if (locationData != null) {
        locationController.text = place['description'];
        selectedLocation.value = LocationServices.locationToLatLng(
          locationData,
        );

        // Move map to selected location
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(selectedLocation.value, 15),
        );
      }
    } catch (e) {
      print('Error selecting place: $e');
    }

    // Clear search results after selection
    clearSearchResults();
    isSearching.value = false;
    update();
  }
}
