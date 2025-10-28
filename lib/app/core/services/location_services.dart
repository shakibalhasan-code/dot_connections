import 'dart:convert';
import 'package:dot_connections/app/core/utils/app_utils.dart';
import 'package:dot_connections/app/data/models/user_personal_data.dart'
    as user_models;
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class LocationServices {
  static final String _apiKey = AppUtils.googleMapApiKey;

  /// Get place predictions for an address query
  static Future<List<Map<String, dynamic>>> getPlacePredictions(
    String query,
  ) async {
    if (query.isEmpty) return [];

    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$_apiKey',
      );

      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        return List<Map<String, dynamic>>.from(data['predictions']);
      }

      return [];
    } catch (e) {
      print('Error getting place predictions: $e');
      return [];
    }
  }

  /// Get coordinates for a place ID
  static Future<user_models.Location?> getPlaceDetails(String placeId) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_apiKey',
      );

      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK' && data['result'] != null) {
        final result = data['result'];
        final location = result['geometry']['location'];

        return user_models.Location(
          type: 'Point',
          coordinates: [location['lng'], location['lat']],
          address: result['formatted_address'] ?? '',
        );
      }
      return null;
    } catch (e) {
      print('Error getting place details: $e');
      return null;
    }
  }

  /// Get coordinates for an address string using geocoding
  static Future<user_models.Location?> getCoordinatesFromAddress(
    String address,
  ) async {
    try {
      final locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return user_models.Location(
          type: 'Point',
          coordinates: [locations.first.longitude, locations.first.latitude],
          address: address,
        );
      }
      return null;
    } catch (e) {
      print('Error geocoding address: $e');
      return null;
    }
  }

  /// Get address from coordinates
  static Future<String?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.locality}, ${place.administrativeArea}, ${place.country}';
      }
      return null;
    } catch (e) {
      print('Error reverse geocoding: $e');
      return null;
    }
  }

  /// Convert Location model to LatLng for Google Maps
  static LatLng locationToLatLng(user_models.Location location) {
    return LatLng(location.coordinates[1], location.coordinates[0]);
  }

  /// Convert LatLng to Location model
  static user_models.Location latLngToLocation(LatLng latLng, String address) {
    return user_models.Location(
      type: 'Point',
      coordinates: [latLng.longitude, latLng.latitude],
      address: address,
    );
  }
}
