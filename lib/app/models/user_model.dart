/// UserModel represents a user in the dating app
///
/// This model contains all user information including profile details,
/// preferences, photos, and matching data. It's designed to be easily
/// serializable for API communication and local storage.
///
/// Customization points:
/// - Add more profile fields as needed
/// - Extend with premium features data
/// - Include social media integration fields
/// - Add verification status fields
class UserModel {
  /// Unique user identifier
  final String id;

  /// Basic information
  final String name;
  final String email;
  final int age;
  final DateTime dateOfBirth;
  final String gender;

  /// Profile information
  final String bio;
  final String profession;
  final String education;
  final String hometown;
  final String currentCity;

  /// Physical attributes
  final int heightInCm;
  final String bodyType;
  final String ethnicity;

  /// Lifestyle and preferences
  final String religion;
  final String drinkingStatus;
  final String smokingStatus;
  final List<String> interests;
  final List<String> languages;

  /// Photos and media
  final List<String> photoUrls;
  final String? profilePhotoUrl;

  /// Location data
  final double? latitude;
  final double? longitude;
  final String? locationName;

  /// Dating preferences
  final int minAgePreference;
  final int maxAgePreference;
  final int maxDistanceKm;
  final List<String> genderPreferences;

  /// App-specific data
  final bool isOnline;
  final DateTime lastActiveAt;
  final bool isPremium;
  final bool isVerified;
  final int likes;
  final int matches;
  final int profileViews;

  /// Account status
  final bool isActive;
  final bool isBlocked;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.dateOfBirth,
    required this.gender,
    required this.bio,
    required this.profession,
    required this.education,
    required this.hometown,
    required this.currentCity,
    required this.heightInCm,
    required this.bodyType,
    required this.ethnicity,
    required this.religion,
    required this.drinkingStatus,
    required this.smokingStatus,
    required this.interests,
    required this.languages,
    required this.photoUrls,
    this.profilePhotoUrl,
    this.latitude,
    this.longitude,
    this.locationName,
    required this.minAgePreference,
    required this.maxAgePreference,
    required this.maxDistanceKm,
    required this.genderPreferences,
    required this.isOnline,
    required this.lastActiveAt,
    required this.isPremium,
    required this.isVerified,
    required this.likes,
    required this.matches,
    required this.profileViews,
    required this.isActive,
    required this.isBlocked,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a copy with updated values
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    int? age,
    DateTime? dateOfBirth,
    String? gender,
    String? bio,
    String? profession,
    String? education,
    String? hometown,
    String? currentCity,
    int? heightInCm,
    String? bodyType,
    String? ethnicity,
    String? religion,
    String? drinkingStatus,
    String? smokingStatus,
    List<String>? interests,
    List<String>? languages,
    List<String>? photoUrls,
    String? profilePhotoUrl,
    double? latitude,
    double? longitude,
    String? locationName,
    int? minAgePreference,
    int? maxAgePreference,
    int? maxDistanceKm,
    List<String>? genderPreferences,
    bool? isOnline,
    DateTime? lastActiveAt,
    bool? isPremium,
    bool? isVerified,
    int? likes,
    int? matches,
    int? profileViews,
    bool? isActive,
    bool? isBlocked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bio: bio ?? this.bio,
      profession: profession ?? this.profession,
      education: education ?? this.education,
      hometown: hometown ?? this.hometown,
      currentCity: currentCity ?? this.currentCity,
      heightInCm: heightInCm ?? this.heightInCm,
      bodyType: bodyType ?? this.bodyType,
      ethnicity: ethnicity ?? this.ethnicity,
      religion: religion ?? this.religion,
      drinkingStatus: drinkingStatus ?? this.drinkingStatus,
      smokingStatus: smokingStatus ?? this.smokingStatus,
      interests: interests ?? this.interests,
      languages: languages ?? this.languages,
      photoUrls: photoUrls ?? this.photoUrls,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      minAgePreference: minAgePreference ?? this.minAgePreference,
      maxAgePreference: maxAgePreference ?? this.maxAgePreference,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
      genderPreferences: genderPreferences ?? this.genderPreferences,
      isOnline: isOnline ?? this.isOnline,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      isPremium: isPremium ?? this.isPremium,
      isVerified: isVerified ?? this.isVerified,
      likes: likes ?? this.likes,
      matches: matches ?? this.matches,
      profileViews: profileViews ?? this.profileViews,
      isActive: isActive ?? this.isActive,
      isBlocked: isBlocked ?? this.isBlocked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Converts to JSON for API communication
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'bio': bio,
      'profession': profession,
      'education': education,
      'hometown': hometown,
      'currentCity': currentCity,
      'heightInCm': heightInCm,
      'bodyType': bodyType,
      'ethnicity': ethnicity,
      'religion': religion,
      'drinkingStatus': drinkingStatus,
      'smokingStatus': smokingStatus,
      'interests': interests,
      'languages': languages,
      'photoUrls': photoUrls,
      'profilePhotoUrl': profilePhotoUrl,
      'latitude': latitude,
      'longitude': longitude,
      'locationName': locationName,
      'minAgePreference': minAgePreference,
      'maxAgePreference': maxAgePreference,
      'maxDistanceKm': maxDistanceKm,
      'genderPreferences': genderPreferences,
      'isOnline': isOnline,
      'lastActiveAt': lastActiveAt.toIso8601String(),
      'isPremium': isPremium,
      'isVerified': isVerified,
      'likes': likes,
      'matches': matches,
      'profileViews': profileViews,
      'isActive': isActive,
      'isBlocked': isBlocked,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Creates from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      age: json['age'] ?? 0,
      dateOfBirth: DateTime.parse(
        json['dateOfBirth'] ?? DateTime.now().toIso8601String(),
      ),
      gender: json['gender'] ?? '',
      bio: json['bio'] ?? '',
      profession: json['profession'] ?? '',
      education: json['education'] ?? '',
      hometown: json['hometown'] ?? '',
      currentCity: json['currentCity'] ?? '',
      heightInCm: json['heightInCm'] ?? 0,
      bodyType: json['bodyType'] ?? '',
      ethnicity: json['ethnicity'] ?? '',
      religion: json['religion'] ?? '',
      drinkingStatus: json['drinkingStatus'] ?? '',
      smokingStatus: json['smokingStatus'] ?? '',
      interests: List<String>.from(json['interests'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
      profilePhotoUrl: json['profilePhotoUrl'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      locationName: json['locationName'],
      minAgePreference: json['minAgePreference'] ?? 18,
      maxAgePreference: json['maxAgePreference'] ?? 50,
      maxDistanceKm: json['maxDistanceKm'] ?? 50,
      genderPreferences: List<String>.from(json['genderPreferences'] ?? []),
      isOnline: json['isOnline'] ?? false,
      lastActiveAt: DateTime.parse(
        json['lastActiveAt'] ?? DateTime.now().toIso8601String(),
      ),
      isPremium: json['isPremium'] ?? false,
      isVerified: json['isVerified'] ?? false,
      likes: json['likes'] ?? 0,
      matches: json['matches'] ?? 0,
      profileViews: json['profileViews'] ?? 0,
      isActive: json['isActive'] ?? true,
      isBlocked: json['isBlocked'] ?? false,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  /// Gets full name with age
  String get nameWithAge => '$name, $age';

  /// Gets display location
  String get displayLocation => locationName ?? currentCity;

  /// Gets online status text
  String get onlineStatusText {
    if (isOnline) return 'Online';

    final now = DateTime.now();
    final difference = now.difference(lastActiveAt);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  /// Gets height in feet and inches
  String get heightDisplay {
    final feet = (heightInCm * 0.0328084).floor();
    final inches = ((heightInCm * 0.0328084 - feet) * 12).round();
    return '$feet\'$inches"';
  }

  /// Gets distance from another user in km
  double? distanceFrom(UserModel otherUser) {
    if (latitude == null ||
        longitude == null ||
        otherUser.latitude == null ||
        otherUser.longitude == null) {
      return null;
    }

    // Simplified distance calculation (for demo purposes)
    // In real implementation, use proper geolocation formulas
    final latDiff = latitude! - otherUser.latitude!;
    final lonDiff = longitude! - otherUser.longitude!;
    return (latDiff * latDiff + lonDiff * lonDiff) * 111; // Rough km conversion
  }

  /// Checks if this user matches the preferences of another user
  bool matchesPreferences(UserModel otherUser) {
    // Age check
    if (age < otherUser.minAgePreference || age > otherUser.maxAgePreference) {
      return false;
    }

    // Gender check
    if (!otherUser.genderPreferences.contains(gender)) {
      return false;
    }

    // Distance check
    final distance = distanceFrom(otherUser);
    if (distance != null && distance > otherUser.maxDistanceKm) {
      return false;
    }

    return true;
  }

  /// Gets compatibility score with another user (0-100)
  int getCompatibilityScore(UserModel otherUser) {
    int score = 50; // Base score

    // Interest matching
    final commonInterests = interests
        .where((interest) => otherUser.interests.contains(interest))
        .length;
    score += (commonInterests * 5).clamp(0, 20);

    // Education level
    if (education == otherUser.education) score += 10;

    // Lifestyle compatibility
    if (drinkingStatus == otherUser.drinkingStatus) score += 5;
    if (smokingStatus == otherUser.smokingStatus) score += 5;
    if (religion == otherUser.religion) score += 10;

    return score.clamp(0, 100);
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, age: $age, city: $currentCity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
