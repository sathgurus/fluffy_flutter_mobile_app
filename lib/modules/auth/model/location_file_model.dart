class LocationModel {
  final String businessId;
  final String? address;
  final double latitude;
  final double longitude;
  final double radius;

  LocationModel({
    required this.businessId,
    this.address,
    required this.latitude,
    required this.longitude,
    this.radius = 300,
  });

  // ✅ Convert MongoDB-style JSON to Model
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      businessId: json["businessId"],
      address: json["address"],
      latitude: json["location"]["coordinates"][1],
      longitude: json["location"]["coordinates"][0],
      radius: (json["radius"] ?? 300).toDouble(),
    );
  }

  // ✅ Convert Model to MongoDB format
  Map<String, dynamic> toJson() {
    return {
      "businessId": businessId,
      "address": address,
      "location": {
        "type": "Point",
        "coordinates": [longitude, latitude],
      },
      "radius": radius,
    };
  }
}
