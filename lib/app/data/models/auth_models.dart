import 'package:dot_connections/app/data/models/user_personal_data.dart';

class AuthResponse {
  final bool success;
  final String message;
  final dynamic data;

  AuthResponse({required this.success, required this.message, this.data});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}

class UserAuthData {
  final String email;

  UserAuthData({required this.email});

  factory UserAuthData.fromJson(Map<String, dynamic> json) {
    return UserAuthData(email: json['email'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}

class OtpVerificationRequest {
  final String email;
  final String otp;

  OtpVerificationRequest({required this.email, required this.otp});

  Map<String, dynamic> toJson() {
    return {'email': email, 'otp': otp};
  }
}

class AuthResult {
  final UserDto? user;
  final String? accessToken;

  AuthResult({this.user, this.accessToken});

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
      user: json['user'] != null ? UserDto.fromJson(json['user']) : null,
      accessToken: json['accessToken'],
    );
  }
}

class UserDto {
  final String id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? image;
  final String role;
  final String? phoneNumber;
  final String? fcmToken;
  final String status;
  final bool verified;
  final bool allProfileFieldsFilled;
  final bool allUserFieldsFilled;
  final AuthenticationInfo authentication;
  final DateTime? lastLoginAt;
  final DateTime? dateOfBirth;
  final bool pushNotification;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProfileDto? profile;

  UserDto({
    required this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.image,
    required this.role,
    this.phoneNumber,
    this.fcmToken,
    required this.status,
    required this.verified,
    required this.allProfileFieldsFilled,
    required this.allUserFieldsFilled,
    required this.authentication,
    this.lastLoginAt,
    this.dateOfBirth,
    required this.pushNotification,
    required this.createdAt,
    required this.updatedAt,
    this.profile,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['_id'] ?? '',
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      image: json['image'],
      role: json['role'] ?? 'USER',
      phoneNumber: json['phoneNumber'],
      fcmToken: json['fcmToken'],
      status: json['status'] ?? 'active',
      verified: json['verified'] ?? false,
      allProfileFieldsFilled: json['allProfileFieldsFilled'] ?? false,
      allUserFieldsFilled: json['allUserFieldsFilled'] ?? false,
      authentication: json['authentication'] != null
          ? AuthenticationInfo.fromJson(json['authentication'])
          : AuthenticationInfo(loginAttempts: 0, lastLoginAttempt: null),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'])
          : null,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      pushNotification: json['pushNotification'] ?? true,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      profile: json['profile'] != null
          ? ProfileDto.fromJson(json['profile'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'image': image,
      'role': role,
      'phoneNumber': phoneNumber,
      'fcmToken': fcmToken,
      'status': status,
      'verified': verified,
      'allProfileFieldsFilled': allProfileFieldsFilled,
      'allUserFieldsFilled': allUserFieldsFilled,
      'authentication': authentication.toJson(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'pushNotification': pushNotification,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'profile': profile?.toJson(),
    };
  }
}

class AuthenticationInfo {
  final int loginAttempts;
  final DateTime? lastLoginAttempt;

  AuthenticationInfo({required this.loginAttempts, this.lastLoginAttempt});

  factory AuthenticationInfo.fromJson(Map<String, dynamic> json) {
    return AuthenticationInfo(
      loginAttempts: json['loginAttempts'] ?? 0,
      lastLoginAttempt: json['lastLoginAttempt'] != null
          ? DateTime.parse(json['lastLoginAttempt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loginAttempts': loginAttempts,
      'lastLoginAttempt': lastLoginAttempt?.toIso8601String(),
    };
  }
}

class ProfileDto {
  final String id;
  final String userId;
  final int? ageRangeMax;
  final int? ageRangeMin;
  final String? bio;
  final DateTime createdAt;
  final String? drinkingStatus;
  final String? gender;
  final int? height;
  final Map<String, bool>? hiddenFields;
  final String? hometown;
  final String? interestedIn;
  final List<String>? interests;
  final String? jobTitle;
  final DateTime lastActive;
  final Location? location;
  final String? lookingFor;
  final int? maxDistance;
  final List<String>? photos;
  final int profileViews;
  final String? religious;
  final String? school;
  final String? smokingStatus;
  final String? studyLevel;
  final DateTime updatedAt;
  final String? workplace;

  ProfileDto({
    required this.id,
    required this.userId,
    this.ageRangeMax,
    this.ageRangeMin,
    this.bio,
    required this.createdAt,
    this.drinkingStatus,
    this.gender,
    this.height,
    this.hiddenFields,
    this.hometown,
    this.interestedIn,
    this.interests,
    this.jobTitle,
    required this.lastActive,
    this.location,
    this.lookingFor,
    this.maxDistance,
    this.photos,
    required this.profileViews,
    this.religious,
    this.school,
    this.smokingStatus,
    this.studyLevel,
    required this.updatedAt,
    this.workplace,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) {
    return ProfileDto(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      ageRangeMax: json['ageRangeMax'],
      ageRangeMin: json['ageRangeMin'],
      bio: json['bio'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      drinkingStatus: json['drinkingStatus'],
      gender: json['gender'],
      height: json['height'],
      hiddenFields: json['hiddenFields'] != null
          ? Map<String, bool>.from(json['hiddenFields'])
          : null,
      hometown: json['hometown'],
      interestedIn: json['interestedIn'],
      interests: json['interests'] != null
          ? List<String>.from(json['interests'])
          : null,
      jobTitle: json['jobTitle'],
      lastActive: DateTime.parse(
        json['lastActive'] ?? DateTime.now().toIso8601String(),
      ),
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
      lookingFor: json['lookingFor'],
      maxDistance: json['maxDistance'],
      photos: json['photos'] != null ? List<String>.from(json['photos']) : null,
      profileViews: json['profileViews'] ?? 0,
      religious: json['religious'],
      school: json['school'],
      smokingStatus: json['smokingStatus'],
      studyLevel: json['studyLevel'],
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      workplace: json['workplace'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'ageRangeMax': ageRangeMax,
      'ageRangeMin': ageRangeMin,
      'bio': bio,
      'createdAt': createdAt.toIso8601String(),
      'drinkingStatus': drinkingStatus,
      'gender': gender,
      'height': height,
      'hiddenFields': hiddenFields,
      'hometown': hometown,
      'interestedIn': interestedIn,
      'interests': interests,
      'jobTitle': jobTitle,
      'lastActive': lastActive.toIso8601String(),
      'location': location?.toJson(),
      'lookingFor': lookingFor,
      'maxDistance': maxDistance,
      'photos': photos,
      'profileViews': profileViews,
      'religious': religious,
      'school': school,
      'smokingStatus': smokingStatus,
      'studyLevel': studyLevel,
      'updatedAt': updatedAt.toIso8601String(),
      'workplace': workplace,
    };
  }
}

class Location {
  final String type;
  final List<double> coordinates;
  final String address;

  Location({
    required this.type,
    required this.coordinates,
    required this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? 'Point',
      coordinates: json['coordinates'] != null
          ? List<double>.from(json['coordinates'])
          : [0.0, 0.0],
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates, 'address': address};
  }
}

class UserFields {
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final bool pushNotification;

  UserFields({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.pushNotification,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'pushNotification': pushNotification,
    };
  }
}

class ProfileFields {
  final Location location;
  final String gender;
  final String interestedIn;
  final int height;
  final List<String> interests;
  final String lookingFor;
  final int ageRangeMin;
  final int ageRangeMax;
  final int maxDistance;
  final String hometown;
  final String workplace;
  final String jobTitle;
  final String school;
  final String studyLevel;
  final String religious;
  final String smokingStatus;
  final String drinkingStatus;
  final String bio;
  final Map<String, bool> hiddenFields;
  final UserPersonalData profileData;

  ProfileFields({required this.profileData})
    : location = Location(
        type: profileData.location.type,
        coordinates: profileData.location.coordinates,
        address: profileData.location.address,
      ),
      gender = profileData.gender,
      interestedIn = profileData.interestedIn,
      height = profileData.height,
      interests = profileData.interests,
      lookingFor = profileData.lookingFor,
      ageRangeMin = profileData.ageRangeMin,
      ageRangeMax = profileData.ageRangeMax,
      maxDistance = profileData.maxDistance,
      hometown = profileData.hometown,
      workplace = profileData.workplace,
      jobTitle = profileData.jobTitle,
      school = profileData.school,
      studyLevel = profileData.studyLevel,
      religious = profileData.religious,
      smokingStatus = profileData.smokingStatus,
      drinkingStatus = profileData.drinkingStatus,
      bio = profileData.bio,
      hiddenFields = Map<String, bool>.from(profileData.hiddenFields.toJson());

  Map<String, dynamic> toJson() {
    return {
      'location': profileData.location.toJson(),
      'gender': profileData.gender,
      'interestedIn': profileData.interestedIn,
      'height': profileData.height,
      'interests': profileData.interests,
      'lookingFor': profileData.lookingFor,
      'ageRangeMin': profileData.ageRangeMin,
      'ageRangeMax': profileData.ageRangeMax,
      'maxDistance': profileData.maxDistance,
      'hometown': profileData.hometown,
      'workplace': profileData.workplace,
      'jobTitle': profileData.jobTitle,
      'school': profileData.school,
      'studyLevel': profileData.studyLevel,
      'religious': profileData.religious,
      'smokingStatus': profileData.smokingStatus,
      'drinkingStatus': profileData.drinkingStatus,
      'bio': profileData.bio,
      'hiddenFields': profileData.hiddenFields,
    };
  }
}

class ErrorResponse {
  final bool success;
  final String message;
  final List<ErrorSource> errorSources;

  ErrorResponse({
    required this.success,
    required this.message,
    required this.errorSources,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Unknown error',
      errorSources: json['errorSources'] != null
          ? List<ErrorSource>.from(
              json['errorSources'].map((x) => ErrorSource.fromJson(x)),
            )
          : [],
    );
  }
}

class ErrorSource {
  final String path;
  final String message;

  ErrorSource({required this.path, required this.message});

  factory ErrorSource.fromJson(Map<String, dynamic> json) {
    return ErrorSource(
      path: json['path'] ?? '',
      message: json['message'] ?? '',
    );
  }
}

class NearbyUserParams {
  final int? radius;
  final double? latitude;
  final double? longitude;
  final String? gender;
  final String? interests;
  final String? interestedIn;
  final String? lookingFor;
  final String? religious;
  final String? studyLevel;

  NearbyUserParams({
    this.radius,
    this.latitude,
    this.longitude,
    this.gender,
    this.interests,
    this.interestedIn,
    this.lookingFor,
    this.religious,
    this.studyLevel,
  });

  Map<String, String> toQueryParams() {
    final Map<String, String> params = {};

    if (radius != null) params['radius'] = radius.toString();
    if (latitude != null) params['latitude'] = latitude.toString();
    if (longitude != null) params['longitude'] = longitude.toString();
    if (gender != null) params['gender'] = gender!;
    if (interests != null) params['interests'] = interests!;
    if (interestedIn != null) params['interestedIn'] = interestedIn!;
    if (lookingFor != null) params['lookingFor'] = lookingFor!;
    if (religious != null) params['religious'] = religious!;
    if (studyLevel != null) params['studyLevel'] = studyLevel!;

    return params;
  }
}
