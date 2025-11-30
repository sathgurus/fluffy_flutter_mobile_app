class DayModel {
  String day;
  bool isOpen;
  String? openTime;
  String? closeTime;

  DayModel({
    required this.day,
    this.isOpen = false,
    this.openTime,
    this.closeTime,
  });

  factory DayModel.fromJson(Map<String, dynamic> json) {
    return DayModel(
      day: json['day'],
      isOpen: json['isOpen'] ?? false,
      openTime: json['openTime'],
      closeTime: json['closeTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "day": day,
      "isOpen": isOpen,
      "openTime": openTime,
      "closeTime": closeTime,
    };
  }
}
