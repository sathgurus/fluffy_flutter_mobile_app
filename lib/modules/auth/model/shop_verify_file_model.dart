class ShopVerificationModel {
  String? id;                 // MongoDB _id
  String ownerId;             // BusinessUsers reference

  // GST
  String? gstNumber;
  String? gstDocument;

  // PAN
  String? panNumber;
  String? panDocument;

  // Aadhar
  String? aadharNumber;
  String? aadharDocument;

  // TIN
  String? tinNumber;

  // Address
  String address;
  String? addressDocument;

  // Shop media
  String? shopLogo;
  List<String?> shopPhotos;

  DateTime? createdAt;
  DateTime? updatedAt;

  ShopVerificationModel({
    this.id,
    required this.ownerId,
    this.gstNumber,
    this.gstDocument,
    this.panNumber,
    this.panDocument,
    this.aadharNumber,
    this.aadharDocument,
    this.tinNumber,
    this.address = "",
    this.addressDocument,
    this.shopLogo,
    this.shopPhotos = const [null, null, null],
    this.createdAt,
    this.updatedAt,
  });

  // ✅ FROM API / FILE
  factory ShopVerificationModel.fromJson(Map<String, dynamic> json) {
    return ShopVerificationModel(
      id: json['_id'],
      ownerId: json['ownerId'],
      gstNumber: json['gstNumber'],
      gstDocument: json['gstDocument'],
      panNumber: json['panNumber'],
      panDocument: json['panDocument'],
      aadharNumber: json['aadharNumber'],
      aadharDocument: json['aadharDocument'],
      tinNumber: json['tinNumber'],
      address: json['address'] ?? "",
      addressDocument: json['addressDocument'],
      shopLogo: json['shopLogo'],
       shopPhotos: (json['shopPhotos'] as List<dynamic>?)
              ?.map((e) => e as String?)
              .toList() ??
          [null, null, null],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  // ✅ TO API / FILE
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "ownerId": ownerId,
      "gstNumber": gstNumber,
      "gstDocument": gstDocument,
      "panNumber": panNumber,
      "panDocument": panDocument,
      "aadharNumber": aadharNumber,
      "aadharDocument": aadharDocument,
      "tinNumber": tinNumber,
      "address": address,
      "addressDocument": addressDocument,
      "shopLogo": shopLogo,
      "shopPhotos": shopPhotos,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}
