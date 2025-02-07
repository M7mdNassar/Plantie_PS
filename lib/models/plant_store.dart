class PlantStore {
  final String name;
  final double latitude;
  final double longitude;
  final String contact;
  final String openingHours;

  PlantStore({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.contact,
    required this.openingHours,
  });

  factory PlantStore.fromJson(Map<String, dynamic> json) {
    return PlantStore(
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      contact: json['contact'],
      openingHours: json['openingHours'],
    );
  }
}