class BusinessUserFileModel {
  String? id;                // MongoDB _id
  String? businessId;        // Local offline ID (BUS0001)
  String name;
  String businessName;
  String businessType;
  String businessPhone;
  String altPhone;
  String businessEmail;
  String password;
  bool termsAccepted;
  String role;

  String? otp;
  bool otpVerified;
  String? resetOTP;
  DateTime? otpExpires;

  bool isUserRegister;
  bool isAddLocation;
  bool isAddPersonal;
  bool isAddService;
  bool isFormSubmit;
  bool isBusinessHours;

  String verificationStatus;
  String? verifiedBy;
  String? verificationNotes;
  DateTime? verifiedAt;
  bool isVerified;

  String businessWebsite;

  String? businessLocation;
  String? businessHours;
  String? shopVerification;

  DateTime? createdAt;
  DateTime? updatedAt;

  BusinessUserFileModel({
    this.id,
    this.businessId,
    required this.name,
    required this.businessName,
    required this.businessType,
    required this.businessPhone,
    this.altPhone = "",
    this.businessEmail = "",
    required this.password,
    required this.termsAccepted,
    this.role = "customer",
    this.otp,
    this.otpVerified = false,
    this.resetOTP,
    this.otpExpires,
    this.isUserRegister = false,
    this.isAddLocation = false,
    this.isAddPersonal = false,
    this.isAddService = false,
    this.isFormSubmit = false,
    this.isBusinessHours = false,
    this.verificationStatus = "pending",
    this.verifiedBy,
    this.verificationNotes,
    this.verifiedAt,
    this.isVerified = false,
    this.businessWebsite = "",
    this.businessLocation,
    this.businessHours,
    this.shopVerification,
    this.createdAt,
    this.updatedAt,
  });

  // ✅ FROM API / JSON
  factory BusinessUserFileModel.fromJson(Map<String, dynamic> json) {
    return BusinessUserFileModel(
      id: json['_id'],
      businessId: json['businessId'],   // offline or API later
      name: json['name'] ?? '',
      businessName: json['businessName'] ?? '',
      businessType: json['businessType'] ?? '',
      businessPhone: json['businessPhone'] ?? '',
      altPhone: json['altPhone'] ?? '',
      businessEmail: json['businessEmail'] ?? '',
      password: json['password'] ?? '',
      termsAccepted: json['termsAccepted'] ?? false,
      role: json['role'] ?? 'customer',
      otp: json['otp'],
      otpVerified: json['otpVerified'] ?? false,
      resetOTP: json['resetOTP'],
      otpExpires: json['otpExpires'] != null
          ? DateTime.parse(json['otpExpires'])
          : null,
      isUserRegister: json['isUserRegister'] ?? false,
      isAddLocation: json['isAddLocation'] ?? false,
      isAddPersonal: json['isAddPersonal'] ?? false,
      isAddService: json['isAddService'] ?? false,
      isFormSubmit: json['isFormSubmit'] ?? false,
      isBusinessHours: json['isBusinessHours'] ?? false,
      verificationStatus: json['verificationStatus'] ?? 'pending',
      verifiedBy: json['verifiedBy'],
      verificationNotes: json['verificationNotes'],
      verifiedAt: json['verifiedAt'] != null
          ? DateTime.parse(json['verifiedAt'])
          : null,
      isVerified: json['isVerified'] ?? false,
      businessWebsite: json['businessWebsite'] ?? '',
      businessLocation: json['businessLocation'],
      businessHours: json['businessHours'],
      shopVerification: json['shopVerification'],
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
      "businessId": businessId,
      "name": name,
      "businessName": businessName,
      "businessType": businessType,
      "businessPhone": businessPhone,
      "altPhone": altPhone,
      "businessEmail": businessEmail,
      "password": password,
      "termsAccepted": termsAccepted,
      "role": role,
      "otp": otp,
      "otpVerified": otpVerified,
      "resetOTP": resetOTP,
      "otpExpires": otpExpires?.toIso8601String(),
      "isUserRegister": isUserRegister,
      "isAddLocation": isAddLocation,
      "isAddPersonal": isAddPersonal,
      "isAddService": isAddService,
      "isFormSubmit": isFormSubmit,
      "isBusinessHours": isBusinessHours,
      "verificationStatus": verificationStatus,
      "verifiedBy": verifiedBy,
      "verificationNotes": verificationNotes,
      "verifiedAt": verifiedAt?.toIso8601String(),
      "isVerified": isVerified,
      "businessWebsite": businessWebsite,
      "businessLocation": businessLocation,
      "businessHours": businessHours,
      "shopVerification": shopVerification,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}
