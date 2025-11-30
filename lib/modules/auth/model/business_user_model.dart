class BusinessUserModel {
  final String name;
  final String businessName;
  final String businessType;
  final String businessPhone;
  final String altPhone;
  final String businessEmail;
  final String businessWebsite;
  final String password;
  final String confirmPassword;
  final String role;
  final bool termsAccepted;
  String? businessId;

  BusinessUserModel({
    required this.name,
    required this.businessName,
    required this.businessType,
    required this.businessPhone,
    required this.altPhone,
    required this.businessEmail,
    required this.businessWebsite,
    required this.password,
    required this.confirmPassword,
    this.role = "owner",
    required this.termsAccepted,
    this.businessId,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "businessName": businessName,
    "businessType": businessType,
    "businessPhone": businessPhone,
    "altPhone": altPhone,
    "businessEmail": businessEmail,
    "businessWebsite": businessWebsite,
    "password": password,
    "confirmPassword": confirmPassword,
    "role": role,
    "termsAccepted": termsAccepted,
    "businessId": businessId,
  };

  factory BusinessUserModel.fromJson(Map<String, dynamic> json) {
    return BusinessUserModel(
      name: json['name'],
      businessName: json['businessName'],
      businessType: json['businessType'],
      businessPhone: json['businessPhone'],
      altPhone: json['altPhone'],
      businessEmail: json['businessEmail'],
      businessWebsite: json['businessWebsite'],
      password: json['password'],
      confirmPassword: json['confirmPassword'],
      role: json['role'],
      termsAccepted: json['termsAccepted'],
      businessId: json['businessId'],
    );
  }
}
