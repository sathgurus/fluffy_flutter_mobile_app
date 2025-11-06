class BusinessModel {
  final String businessName;
  final String? businessDescription;
  final String businessPhone;
  final String? alternatePhone;
  final String? businessEmail;
  final String? businessWebsite;
  final String ownerId;

  BusinessModel({
    required this.businessName,
    this.businessDescription,
    required this.businessPhone,
    this.alternatePhone,
    this.businessEmail,
    this.businessWebsite,
    required this.ownerId,
  });

  Map<String, dynamic> toJson() {
    return {
      "businessName": businessName,
      "businessDescription": businessDescription,
      "businessPhone": businessPhone,
      "alternatePhone": alternatePhone,
      "businessEmail": businessEmail,
      "businessWebsite": businessWebsite,
      "ownerId": ownerId,
    };
  }

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      businessName: json["businessName"],
      businessDescription: json["businessDescription"],
      businessPhone: json["businessPhone"],
      alternatePhone: json["alternatePhone"],
      businessEmail: json["businessEmail"],
      businessWebsite: json["businessWebsite"],
      ownerId: json["ownerId"],
    );
  }
}
