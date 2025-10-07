class UserInterests {
  final List<String> hobbies;
  final List<String> music;
  final List<String> movies;
  final List<String> sports;
  final List<String> food;
  final List<String> travel;

  UserInterests({
    required this.hobbies,
    required this.music,
    required this.movies,
    required this.sports,
    required this.food,
    required this.travel,
  });

  Map<String, dynamic> toJson() => {
    'hobbies': hobbies,
    'music': music,
    'movies': movies,
    'sports': sports,
    'food': food,
    'travel': travel,
  };

  factory UserInterests.fromJson(Map<String, dynamic> json) => UserInterests(
    hobbies: List<String>.from(json['hobbies'] ?? []),
    music: List<String>.from(json['music'] ?? []),
    movies: List<String>.from(json['movies'] ?? []),
    sports: List<String>.from(json['sports'] ?? []),
    food: List<String>.from(json['food'] ?? []),
    travel: List<String>.from(json['travel'] ?? []),
  );
}

class UserPreferences {
  final int ageMin;
  final int ageMax;
  final double maxDistance;
  final List<String> lookingFor;
  final bool showOnline;
  final List<String> dealBreakers;

  UserPreferences({
    required this.ageMin,
    required this.ageMax,
    required this.maxDistance,
    required this.lookingFor,
    required this.showOnline,
    required this.dealBreakers,
  });

  Map<String, dynamic> toJson() => {
    'ageMin': ageMin,
    'ageMax': ageMax,
    'maxDistance': maxDistance,
    'lookingFor': lookingFor,
    'showOnline': showOnline,
    'dealBreakers': dealBreakers,
  };

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      UserPreferences(
        ageMin: json['ageMin'] ?? 18,
        ageMax: json['ageMax'] ?? 99,
        maxDistance: json['maxDistance']?.toDouble() ?? 50.0,
        lookingFor: List<String>.from(json['lookingFor'] ?? []),
        showOnline: json['showOnline'] ?? true,
        dealBreakers: List<String>.from(json['dealBreakers'] ?? []),
      );
}

class UserStory {
  final String id;
  final String userId;
  final String mediaUrl;
  final String? caption;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String mediaType; // 'image', 'video', 'poll'
  final Map<String, dynamic>? pollData;
  final List<String> viewedBy;
  final List<String> reactions;

  UserStory({
    required this.id,
    required this.userId,
    required this.mediaUrl,
    this.caption,
    required this.createdAt,
    required this.expiresAt,
    required this.mediaType,
    this.pollData,
    required this.viewedBy,
    required this.reactions,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'mediaUrl': mediaUrl,
    'caption': caption,
    'createdAt': createdAt.toIso8601String(),
    'expiresAt': expiresAt.toIso8601String(),
    'mediaType': mediaType,
    'pollData': pollData,
    'viewedBy': viewedBy,
    'reactions': reactions,
  };

  factory UserStory.fromJson(Map<String, dynamic> json) => UserStory(
    id: json['id'],
    userId: json['userId'],
    mediaUrl: json['mediaUrl'],
    caption: json['caption'],
    createdAt: DateTime.parse(json['createdAt']),
    expiresAt: DateTime.parse(json['expiresAt']),
    mediaType: json['mediaType'],
    pollData: json['pollData'],
    viewedBy: List<String>.from(json['viewedBy'] ?? []),
    reactions: List<String>.from(json['reactions'] ?? []),
  );
}

class MatchScore {
  final double overall;
  final double interests;
  final double values;
  final double location;
  final double activity;
  final Map<String, double> categoryScores;

  MatchScore({
    required this.overall,
    required this.interests,
    required this.values,
    required this.location,
    required this.activity,
    required this.categoryScores,
  });

  Map<String, dynamic> toJson() => {
    'overall': overall,
    'interests': interests,
    'values': values,
    'location': location,
    'activity': activity,
    'categoryScores': categoryScores,
  };

  factory MatchScore.fromJson(Map<String, dynamic> json) => MatchScore(
    overall: json['overall']?.toDouble() ?? 0.0,
    interests: json['interests']?.toDouble() ?? 0.0,
    values: json['values']?.toDouble() ?? 0.0,
    location: json['location']?.toDouble() ?? 0.0,
    activity: json['activity']?.toDouble() ?? 0.0,
    categoryScores: Map<String, double>.from(json['categoryScores'] ?? {}),
  );
}

class IceBreaker {
  final String id;
  final String question;
  final List<String> categories;
  final bool isPersonalized;

  IceBreaker({
    required this.id,
    required this.question,
    required this.categories,
    required this.isPersonalized,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'question': question,
    'categories': categories,
    'isPersonalized': isPersonalized,
  };

  factory IceBreaker.fromJson(Map<String, dynamic> json) => IceBreaker(
    id: json['id'],
    question: json['question'],
    categories: List<String>.from(json['categories'] ?? []),
    isPersonalized: json['isPersonalized'] ?? false,
  );
}
