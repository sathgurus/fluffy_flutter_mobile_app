class LocationModel {
  final String businessOwnerId;
  final double latitude;
  final double longitude;
  final String? address;

  LocationModel({
    required this.businessOwnerId,
    required this.latitude,
    required this.longitude,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      "businessId": businessOwnerId,
      "latitude": latitude,
      "longitude": longitude,
      "address": address,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      LocationModel(
        businessOwnerId: json["businessOwnerId"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        address: json["address"],
      );
}
