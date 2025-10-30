class MatchProfile {
  final String name;
  final int age;
  final double distance;
  final String imageUrl;
  bool isBlurred;

  MatchProfile({
    required this.name,
    required this.age,
    required this.distance,
    required this.imageUrl,
    this.isBlurred = true, // Initially, all profiles are blurred.
  });
}
