class UserProfile {
  final List<String> images;
  final String name;
  final int age;
  final List<String> interested;
  final String distance;

  UserProfile({
    required this.images,
    required this.name,
    required this.age,
    required this.interested,
    required this.distance,
  });

  // Factory constructor for creating a new UserProfile instance from a map
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      images: List<String>.from(json['images'] ?? []),
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      interested: List<String>.from(json['interested'] ?? []),
      distance: json['distance'] ?? '',
    );
  }

  // Method for converting UserProfile instance to map
  Map<String, dynamic> toJson() {
    return {
      'images': images,
      'name': name,
      'age': age,
      'interested': interested,
      'distance': distance,
    };
  }
}
