class DayHour {
  String day;
  bool isOpen;
  String? openTime;
  String? closeTime;

  DayHour({
    required this.day,
    required this.isOpen,
    this.openTime,
    this.closeTime,
  });

  factory DayHour.fromJson(Map<String, dynamic> json) => DayHour(
        day: json['day'],
        isOpen: json['isOpen'] ?? false,
        openTime: json['openTime'],
        closeTime: json['closeTime'],
      );

  Map<String, dynamic> toJson() => {
        'day': day,
        'isOpen': isOpen,
        'openTime': openTime,
        'closeTime': closeTime,
      };
}


class BusinessHoursModel {
  final String businessId;
  final List<DayHour> hours;

  BusinessHoursModel({required this.businessId, required this.hours});

  factory BusinessHoursModel.fromJson(Map<String, dynamic> json) {
    return BusinessHoursModel(
      businessId: json['businessId'],
      hours: (json['hours'] as List).map((e) => DayHour.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "businessId": businessId,
      "hours": hours.map((e) => e.toJson()).toList(),
    };
  }
}
