class NearbyUser {
  final String id;
  final String bio;
  final String gender;
  final int height;
  final String interestedIn;
  final List<String> interests;
  final LocationModel location;
  final String lookingFor;
  final String religious;
  final String school;
  final String studyLevel;
  final String workplace;
  final String userId;
  final int distance;
  final double distanceKm;
  final String name;
  final int age;
  final bool isConnected;

  NearbyUser({
    required this.id,
    required this.bio,
    required this.gender,
    required this.height,
    required this.interestedIn,
    required this.interests,
    required this.location,
    required this.lookingFor,
    required this.religious,
    required this.school,
    required this.studyLevel,
    required this.workplace,
    required this.userId,
    required this.distance,
    required this.distanceKm,
    required this.name,
    required this.age,
    required this.isConnected,
  });

  factory NearbyUser.fromJson(Map<String, dynamic> json) {
    return NearbyUser(
      id: json['_id'] ?? '',
      bio: json['bio'] ?? '',
      gender: json['gender'] ?? '',
      height: json['height'] ?? 0,
      interestedIn: json['interestedIn'] ?? '',
      interests: List<String>.from(json['interests'] ?? []),
      location: LocationModel.fromJson(json['location'] ?? {}),
      lookingFor: json['lookingFor'] ?? '',
      religious: json['religious'] ?? '',
      school: json['school'] ?? '',
      studyLevel: json['studyLevel'] ?? '',
      workplace: json['workplace'] ?? '',
      userId: json['userId'] ?? '',
      distance: json['distance'] ?? 0,
      distanceKm: (json['distanceKm'] ?? 0).toDouble(),
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      isConnected: json['isConnected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'bio': bio,
      'gender': gender,
      'height': height,
      'interestedIn': interestedIn,
      'interests': interests,
      'location': location.toJson(),
      'lookingFor': lookingFor,
      'religious': religious,
      'school': school,
      'studyLevel': studyLevel,
      'workplace': workplace,
      'userId': userId,
      'distance': distance,
      'distanceKm': distanceKm,
      'name': name,
      'age': age,
      'isConnected': isConnected,
    };
  }

  @override
  String toString() {
    return 'NearbyUser{name: $name, age: $age, distance: ${distanceKm}km, isConnected: $isConnected}';
  }
}

class LocationModel {
  final double latitude;
  final double longitude;

  LocationModel({required this.latitude, required this.longitude});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude};
  }

  @override
  String toString() {
    return 'LocationModel{latitude: $latitude, longitude: $longitude}';
  }
}

class NearbyUsersResponse {
  final bool success;
  final String message;
  final List<NearbyUser> data;

  NearbyUsersResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory NearbyUsersResponse.fromJson(Map<String, dynamic> json) {
    return NearbyUsersResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => NearbyUser.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((user) => user.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'NearbyUsersResponse{success: $success, message: $message, data: ${data.length} users}';
  }
}
