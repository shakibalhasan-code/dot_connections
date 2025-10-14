class UserPersonalData {
  Location location;
  String gender;
  String interestedIn;
  int height;
  List<String> interests;
  String lookingFor;
  int ageRangeMin;
  int ageRangeMax;
  int maxDistance;
  String hometown;
  String workplace;
  String jobTitle;
  String school;
  String studyLevel;
  String religious;
  String smokingStatus;
  String drinkingStatus;
  String bio;
  HiddenFields hiddenFields;

  UserPersonalData({
    required this.location,
    required this.gender,
    required this.interestedIn,
    required this.height,
    required this.interests,
    required this.lookingFor,
    required this.ageRangeMin,
    required this.ageRangeMax,
    required this.maxDistance,
    required this.hometown,
    required this.workplace,
    required this.jobTitle,
    required this.school,
    required this.studyLevel,
    required this.religious,
    required this.smokingStatus,
    required this.drinkingStatus,
    required this.bio,
    required this.hiddenFields,
  });

  factory UserPersonalData.fromJson(Map<String, dynamic> json) {
    return UserPersonalData(
      location: Location.fromJson(json['location']),
      gender: json['gender'] ?? '',
      interestedIn: json['interestedIn'] ?? '',
      height: json['height'] ?? 0,
      interests: List<String>.from(json['interests'] ?? []),
      lookingFor: json['lookingFor'] ?? '',
      ageRangeMin: json['ageRangeMin'] ?? 0,
      ageRangeMax: json['ageRangeMax'] ?? 0,
      maxDistance: json['maxDistance'] ?? 0,
      hometown: json['hometown'] ?? '',
      workplace: json['workplace'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      school: json['school'] ?? '',
      studyLevel: json['studyLevel'] ?? '',
      religious: json['religious'] ?? '',
      smokingStatus: json['smokingStatus'] ?? '',
      drinkingStatus: json['drinkingStatus'] ?? '',
      bio: json['bio'] ?? '',
      hiddenFields: HiddenFields.fromJson(json['hiddenFields'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location.toJson(),
      'gender': gender,
      'interestedIn': interestedIn,
      'height': height,
      'interests': interests,
      'lookingFor': lookingFor,
      'ageRangeMin': ageRangeMin,
      'ageRangeMax': ageRangeMax,
      'maxDistance': maxDistance,
      'hometown': hometown,
      'workplace': workplace,
      'jobTitle': jobTitle,
      'school': school,
      'studyLevel': studyLevel,
      'religious': religious,
      'smokingStatus': smokingStatus,
      'drinkingStatus': drinkingStatus,
      'bio': bio,
      'hiddenFields': hiddenFields.toJson(),
    };
  }

  UserPersonalData copyWith({
    Location? location,
    String? gender,
    String? interestedIn,
    int? height,
    List<String>? interests,
    String? lookingFor,
    int? ageRangeMin,
    int? ageRangeMax,
    int? maxDistance,
    String? hometown,
    String? workplace,
    String? jobTitle,
    String? school,
    String? studyLevel,
    String? religious,
    String? smokingStatus,
    String? drinkingStatus,
    String? bio,
    HiddenFields? hiddenFields,
  }) {
    return UserPersonalData(
      location: location ?? this.location,
      gender: gender ?? this.gender,
      interestedIn: interestedIn ?? this.interestedIn,
      height: height ?? this.height,
      interests: interests ?? this.interests,
      lookingFor: lookingFor ?? this.lookingFor,
      ageRangeMin: ageRangeMin ?? this.ageRangeMin,
      ageRangeMax: ageRangeMax ?? this.ageRangeMax,
      maxDistance: maxDistance ?? this.maxDistance,
      hometown: hometown ?? this.hometown,
      workplace: workplace ?? this.workplace,
      jobTitle: jobTitle ?? this.jobTitle,
      school: school ?? this.school,
      studyLevel: studyLevel ?? this.studyLevel,
      religious: religious ?? this.religious,
      smokingStatus: smokingStatus ?? this.smokingStatus,
      drinkingStatus: drinkingStatus ?? this.drinkingStatus,
      bio: bio ?? this.bio,
      hiddenFields: hiddenFields ?? this.hiddenFields,
    );
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
      type: json['type'] ?? '',
      coordinates: List<double>.from(
        (json['coordinates'] ?? []).map((e) => e.toDouble()),
      ),
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates, 'address': address};
  }
}

class HiddenFields {
  bool gender;
  bool hometown;
  bool workplace;
  bool jobTitle;
  bool school;
  bool studyLevel;
  bool religious;
  bool drinkingStatus;
  bool smokingStatus;

  HiddenFields({
    required this.gender,
    required this.hometown,
    required this.workplace,
    required this.jobTitle,
    required this.school,
    required this.studyLevel,
    required this.religious,
    required this.drinkingStatus,
    required this.smokingStatus,
  });

  factory HiddenFields.fromJson(Map<String, dynamic> json) {
    return HiddenFields(
      gender: json['gender'] ?? false,
      hometown: json['hometown'] ?? false,
      workplace: json['workplace'] ?? false,
      jobTitle: json['jobTitle'] ?? false,
      school: json['school'] ?? false,
      studyLevel: json['studyLevel'] ?? false,
      religious: json['religious'] ?? false,
      drinkingStatus: json['drinkingStatus'] ?? false,
      smokingStatus: json['smokingStatus'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'hometown': hometown,
      'workplace': workplace,
      'jobTitle': jobTitle,
      'school': school,
      'studyLevel': studyLevel,
      'religious': religious,
      'drinkingStatus': drinkingStatus,
      'smokingStatus': smokingStatus,
    };
  }
}
