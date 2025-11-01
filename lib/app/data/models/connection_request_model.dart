class ConnectionRequest {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserProfile profile;
  final int age;
  final double distance;

  ConnectionRequest({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.profile,
    required this.age,
    required this.distance,
  });

  factory ConnectionRequest.fromJson(Map<String, dynamic> json) {
    return ConnectionRequest(
      id: json['_id'],
      fromUserId: json['fromUserId'],
      toUserId: json['toUserId'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      profile: UserProfile.fromJson(json['profile']),
      age: json['age'],
      distance: json['distance'].toDouble(),
    );
  }
}

class UserProfile {
  final String id;
  final String userId;
  final String bio;
  final String gender;
  final String religious;
  final String drinkingStatus;
  final String smokingStatus;
  final List<String> interests;
  final String jobTitle;
  final LocationData location;
  final List<String> photos;
  final int height;
  final String workplace;
  final String hometown;
  final String school;
  final String studyLevel;
  final String lookingFor;

  UserProfile({
    required this.id,
    required this.userId,
    required this.bio,
    required this.gender,
    required this.religious,
    required this.drinkingStatus,
    required this.smokingStatus,
    required this.interests,
    required this.jobTitle,
    required this.location,
    required this.photos,
    required this.height,
    required this.workplace,
    required this.hometown,
    required this.school,
    required this.studyLevel,
    required this.lookingFor,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'],
      userId: json['userId'],
      bio: json['bio'] ?? '',
      gender: json['gender'] ?? '',
      religious: json['religious'] ?? '',
      drinkingStatus: json['drinkingStatus'] ?? '',
      smokingStatus: json['smokingStatus'] ?? '',
      interests: List<String>.from(json['interests'] ?? []),
      jobTitle: json['jobTitle'] ?? '',
      location: LocationData.fromJson(json['location']),
      photos: List<String>.from(json['photos'] ?? []),
      height: json['height'] ?? 0,
      workplace: json['workplace'] ?? '',
      hometown: json['hometown'] ?? '',
      school: json['school'] ?? '',
      studyLevel: json['studyLevel'] ?? '',
      lookingFor: json['lookingFor'] ?? '',
    );
  }
}

class LocationData {
  final String type;
  final List<double> coordinates;
  final String address;

  LocationData({
    required this.type,
    required this.coordinates,
    required this.address,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      type: json['type'],
      coordinates: List<double>.from(json['coordinates']),
      address: json['address'],
    );
  }
}

class Connection {
  final String id;
  final List<ConnectedUser> userIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  Connection({
    required this.id,
    required this.userIds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(
      id: json['_id'],
      userIds: List<ConnectedUser>.from(
        json['userIds'].map((x) => ConnectedUser.fromJson(x)),
      ),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class ConnectedUser {
  final String id;
  final String? image;
  final bool verified;
  final String firstName;
  final String lastName;
  final String fullName;

  ConnectedUser({
    required this.id,
    this.image,
    required this.verified,
    required this.firstName,
    required this.lastName,
    required this.fullName,
  });

  factory ConnectedUser.fromJson(Map<String, dynamic> json) {
    return ConnectedUser(
      id: json['_id'],
      image: json['image'],
      verified: json['verified'] ?? false,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      fullName: json['fullName'] ?? '',
    );
  }
}

class SentRequest {
  final String id;
  final String fromUserId;
  final ConnectedUser toUserId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  SentRequest({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SentRequest.fromJson(Map<String, dynamic> json) {
    return SentRequest(
      id: json['_id'],
      fromUserId: json['fromUserId'],
      toUserId: ConnectedUser.fromJson(json['toUserId']),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
