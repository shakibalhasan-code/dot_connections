class Location {
  final String type;
  final List<double> coordinates;
  final String address;

  const Location({
    required this.type,
    required this.coordinates,
    required this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? 'Point',
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
