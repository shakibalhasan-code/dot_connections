import 'user_model.dart';

/// Model for the potential matches API response
class PotentialMatchesResponse {
  final bool success;
  final String message;
  final PotentialMatchesMeta meta;
  final List<PotentialMatch> data;

  PotentialMatchesResponse({
    required this.success,
    required this.message,
    required this.meta,
    required this.data,
  });

  factory PotentialMatchesResponse.fromJson(Map<String, dynamic> json) {
    return PotentialMatchesResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      meta: PotentialMatchesMeta.fromJson(json['meta'] ?? {}),
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => PotentialMatch.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'meta': meta.toJson(),
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

/// Meta information for pagination
class PotentialMatchesMeta {
  final int page;
  final int limit;
  final int total;
  final int totalPage;

  PotentialMatchesMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPage,
  });

  factory PotentialMatchesMeta.fromJson(Map<String, dynamic> json) {
    return PotentialMatchesMeta(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPage: json['totalPage'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPage': totalPage,
    };
  }
}

/// Individual potential match user data
class PotentialMatch {
  final String id;
  final String? email;
  final String? image;
  final String? phoneNumber;
  final DateTime? lastLoginAt;
  final DateTime? dateOfBirth;
  final String firstName;
  final String lastName;
  final PotentialMatchProfile profile;
  final int age;
  final double distance;

  PotentialMatch({
    required this.id,
    this.email,
    this.image,
    this.phoneNumber,
    this.lastLoginAt,
    this.dateOfBirth,
    required this.firstName,
    required this.lastName,
    required this.profile,
    required this.age,
    required this.distance,
  });

  /// Get full name
  String get fullName => '$firstName $lastName'.trim();

  factory PotentialMatch.fromJson(Map<String, dynamic> json) {
    return PotentialMatch(
      id: json['_id'] ?? '',
      email: json['email'],
      image: json['image'],
      phoneNumber: json['phoneNumber'],
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.tryParse(json['lastLoginAt'])
          : null,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      profile: PotentialMatchProfile.fromJson(json['profile'] ?? {}),
      age: json['age'] ?? 0,
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'image': image,
      'phoneNumber': phoneNumber,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'firstName': firstName,
      'lastName': lastName,
      'profile': profile.toJson(),
      'age': age,
      'distance': distance,
    };
  }
}

/// Profile data for potential match
class PotentialMatchProfile {
  final String id;
  final String userId;
  final String? bio;
  final String? drinkingStatus;
  final String? gender;
  final int? height;
  final Map<String, bool>? hiddenFields;
  final String? hometown;
  final List<String> interests;
  final String? jobTitle;
  final PotentialMatchLocation? location;
  final String? lookingFor;
  final List<String> photos;
  final String? religious;
  final String? school;
  final String? smokingStatus;
  final String? studyLevel;
  final String? workplace;

  PotentialMatchProfile({
    required this.id,
    required this.userId,
    this.bio,
    this.drinkingStatus,
    this.gender,
    this.height,
    this.hiddenFields,
    this.hometown,
    required this.interests,
    this.jobTitle,
    this.location,
    this.lookingFor,
    required this.photos,
    this.religious,
    this.school,
    this.smokingStatus,
    this.studyLevel,
    this.workplace,
  });

  factory PotentialMatchProfile.fromJson(Map<String, dynamic> json) {
    return PotentialMatchProfile(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      bio: json['bio'],
      drinkingStatus: json['drinkingStatus'],
      gender: json['gender'],
      height: json['height'],
      hiddenFields: json['hiddenFields'] != null
          ? Map<String, bool>.from(json['hiddenFields'])
          : null,
      hometown: json['hometown'],
      interests: List<String>.from(json['interests'] ?? []),
      jobTitle: json['jobTitle'],
      location: json['location'] != null
          ? PotentialMatchLocation.fromJson(json['location'])
          : null,
      lookingFor: json['lookingFor'],
      photos: List<String>.from(json['photos'] ?? []),
      religious: json['religious'],
      school: json['school'],
      smokingStatus: json['smokingStatus'],
      studyLevel: json['studyLevel'],
      workplace: json['workplace'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'bio': bio,
      'drinkingStatus': drinkingStatus,
      'gender': gender,
      'height': height,
      'hiddenFields': hiddenFields,
      'hometown': hometown,
      'interests': interests,
      'jobTitle': jobTitle,
      'location': location?.toJson(),
      'lookingFor': lookingFor,
      'photos': photos,
      'religious': religious,
      'school': school,
      'smokingStatus': smokingStatus,
      'studyLevel': studyLevel,
      'workplace': workplace,
    };
  }
}

/// Location data for potential match
class PotentialMatchLocation {
  final String type;
  final List<double> coordinates;
  final String address;

  PotentialMatchLocation({
    required this.type,
    required this.coordinates,
    required this.address,
  });

  factory PotentialMatchLocation.fromJson(Map<String, dynamic> json) {
    return PotentialMatchLocation(
      type: json['type'] ?? 'Point',
      coordinates: json['coordinates'] != null
          ? List<double>.from(
              (json['coordinates'] as List).map((e) => e.toDouble()),
            )
          : [0.0, 0.0],
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates, 'address': address};
  }

  /// Get latitude (second coordinate)
  double? get latitude => coordinates.length >= 2 ? coordinates[1] : null;

  /// Get longitude (first coordinate)
  double? get longitude => coordinates.length >= 1 ? coordinates[0] : null;
}

/// Extension to convert PotentialMatch to UserModel
extension PotentialMatchExtension on PotentialMatch {
  /// Convert PotentialMatch to UserModel for compatibility with existing UI
  UserModel toUserModel() {
    // Combine main image and photos
    final List<String> allPhotos = [];
    if (image != null && image!.isNotEmpty) {
      allPhotos.add(image!);
    }
    allPhotos.addAll(profile.photos);

    return UserModel(
      id: id,
      name: fullName,
      email: email ?? '',
      age: age,
      dateOfBirth: dateOfBirth,
      gender: profile.gender ?? 'Unknown',
      phoneNumber: phoneNumber,
      bio: profile.bio,
      photoUrls: allPhotos,
      profilePhotoUrl: image,
      interests: profile.interests,
      latitude: profile.location?.latitude,
      longitude: profile.location?.longitude,
      locationName: profile.location?.address,
      distance: distance,
      hiddenFields: profile.hiddenFields ?? {},
      lastActiveAt: lastLoginAt,
      profession: profile.jobTitle,
      education: profile.school,
      hometown: profile.hometown,
      religion: profile.religious,
      drinkingStatus: profile.drinkingStatus,
      smokingStatus: profile.smokingStatus,
      minAgePreference: 18,
      maxAgePreference: 55,
      maxDistanceKm: 50,
      interestedIn: profile.lookingFor ?? 'Any',
      isVerified: false,
      profileViews: 0,
      isActive: true,
    );
  }
}
