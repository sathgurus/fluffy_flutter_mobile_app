class BusinessVerificationModel {
  String? userId;
  String? tinNumber;
  String? gstNumber;
  String? panNumber;
  String? aadhaarNumber;
  String? logoUrl;
  List<String?> shopPhotos;

  BusinessVerificationModel({
    this.userId,
    this.tinNumber,
    this.gstNumber,
    this.panNumber,
    this.aadhaarNumber,
    this.logoUrl,
    required this.shopPhotos,
  });

  Map<String, dynamic> toJson() {
    return {
      "ownerId": userId,
      "gstNumber": gstNumber,
      "tinNumber": tinNumber,
      "panNumber": panNumber,
      "aadharNumber": aadhaarNumber,
      "shopLogo": logoUrl,
      "shopPhotos": shopPhotos,
    };
  }
}
