class Booking {
  final String clientName;
  final String service;
  final String petDetails;
  final String date;
  final String status;
  final double price;
  final String? duration;

  Booking({
    required this.clientName,
    required this.service,
    required this.petDetails,
    required this.date,
    required this.status,
    required this.price,
    this.duration,
  });

  // ✅ Factory to auto-assign duration
  factory Booking.withServiceDuration({
    required String clientName,
    required String service,
    required String petDetails,
    required String date,
    required String status,
    required double price,
  }) {
    return Booking(
      clientName: clientName,
      service: service,
      petDetails: petDetails,
      date: date,
      status: status,
      price: price,
      duration: serviceDurationMap[service] ?? "15 Minutes",
    );
  }
}

final Map<String, String> serviceDurationMap = {
  "Grooming": "30 Minutes",
  "Boarding": "1 Day",
  "Training": "45 Minutes",
  "Breeding": "60 Minutes",
};
