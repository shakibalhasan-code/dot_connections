import 'dart:convert';
import 'package:flutter/foundation.dart';

class UserModel {
  /// Unique user identifier
  final String id;

  /// Basic information
  final String name;
  final String email;
  final int age;
  final DateTime? dateOfBirth;
  final String gender;
  final String? phoneNumber;

  /// Profile information
  final String? bio;

  /// Photos and media
  final List<String> photoUrls;
  final String? profilePhotoUrl;

  /// Lifestyle and preferences
  final List<String> interests;

  /// Location data
  final double? latitude;
  final double? longitude;
  final String? locationName;
  final double? distance; // Distance from current user in km

  /// Hidden fields preferences
  final Map<String, bool> hiddenFields;

  /// App-specific data
  final DateTime? lastActiveAt;

  // Fields not in this specific JSON response, but kept for model completeness with defaults
  final String? profession;
  final String? education;
  final String? hometown;
  final String? religion;
  final String? drinkingStatus;
  final String? smokingStatus;
  final int minAgePreference;
  final int maxAgePreference;
  final int maxDistanceKm;
  final String interestedIn;
  final bool isVerified;
  final int profileViews;
  final bool isActive;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    this.dateOfBirth,
    required this.gender,
    this.phoneNumber,
    this.bio,
    required this.photoUrls,
    this.profilePhotoUrl,
    required this.interests,
    this.latitude,
    this.longitude,
    this.locationName,
    this.distance,
    required this.hiddenFields,
    this.lastActiveAt,
    // Defaulted fields
    this.profession,
    this.education,
    this.hometown,
    this.religion,
    this.drinkingStatus,
    this.smokingStatus,
    required this.minAgePreference,
    required this.maxAgePreference,
    required this.maxDistanceKm,
    required this.interestedIn,
    required this.isVerified,
    required this.profileViews,
    required this.isActive,
  });

  /// Creates from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Safely access nested profile and location objects
    final profile = json['profile'] is Map<String, dynamic>
        ? json['profile']
        : <String, dynamic>{};
    final location = profile['location'] is Map<String, dynamic>
        ? profile['location']
        : <String, dynamic>{};

    // --- Name ---
    final firstName = json['firstName'] ?? '';
    final lastName = json['lastName'] ?? '';
    final name = '$firstName $lastName'.trim();

    // --- Photos ---
    final profilePhoto = json['image'] as String?;
    final photoList = <String>[];
    if (profilePhoto != null && profilePhoto.isNotEmpty) {
      photoList.add(profilePhoto);
    }
    if (profile['photos'] is List) {
      photoList.addAll(List<String>.from(profile['photos']));
    }

    // --- Location & Coordinates ---
    double? latitude;
    double? longitude;
    if (location['coordinates'] is List &&
        (location['coordinates'] as List).length >= 2) {
      final coords = location['coordinates'] as List;
      // API format seems to be [longitude, latitude]
      longitude = (coords[0] as num?)?.toDouble();
      latitude = (coords[1] as num?)?.toDouble();
    }

    // --- Dates ---
    DateTime? dob;
    if (json['dateOfBirth'] != null) {
      dob = DateTime.tryParse(json['dateOfBirth']);
    }

    DateTime? lastActive;
    if (json['lastLoginAt'] != null) {
      lastActive = DateTime.tryParse(json['lastLoginAt']);
    }

    return UserModel(
      id: json['_id'] ?? '',
      name: name,
      email: json['email'] ?? '',
      // Use the pre-calculated age from the API, with a fallback
      age: json['age'] as int? ?? (dob != null ? _calculateAge(dob) : 0),
      dateOfBirth: dob,
      phoneNumber: json['phoneNumber'],
      // Fields from the nested 'profile' object
      bio: profile['bio'],
      gender: profile['gender'] ?? 'Unknown',
      interests: List<String>.from(profile['interests'] ?? []),
      hiddenFields: Map<String, bool>.from(profile['hiddenFields'] ?? {}),
      // Photo and location data
      profilePhotoUrl: profilePhoto,
      photoUrls: photoList,
      latitude: latitude,
      longitude: longitude,
      locationName: location['address'],
      // Top-level pre-calculated distance
      distance: (json['distance'] as num?)?.toDouble(),
      lastActiveAt: lastActive,

      // --- Provide sensible defaults for fields NOT in this API response ---
      isVerified: false,
      profileViews: 0,
      isActive: true,
      minAgePreference: 18,
      maxAgePreference: 55,
      maxDistanceKm: 50,
      interestedIn: 'Any', // Or determine a better default
    );
  }

  /// Converts to JSON for API communication
  /// Note: This creates a structure similar to what is being parsed.
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': name.split(' ').first,
      'lastName': name.split(' ').length > 1
          ? name.split(' ').sublist(1).join(' ')
          : '',
      'email': email,
      'phoneNumber': phoneNumber,
      'image': profilePhotoUrl,
      'age': age,
      'distance': distance,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'lastLoginAt': lastActiveAt?.toIso8601String(),
      'profile': {
        'bio': bio,
        'gender': gender,
        'interests': interests,
        'photos': photoUrls
            .where((p) => p != profilePhotoUrl)
            .toList(), // Exclude main image
        'hiddenFields': hiddenFields,
        'location': {
          'type': 'Point',
          'coordinates': [longitude, latitude],
          'address': locationName,
        },
      },
    };
  }

  static int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  String get nameWithAge => '$name, $age';

  String get displayLocation => locationName ?? 'Unknown location';

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, age: $age, distance: ${distance?.toStringAsFixed(2)}km)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
