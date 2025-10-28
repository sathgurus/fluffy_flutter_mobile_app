import 'package:fluffy/modules/booking/widget/appionment_card.dart';
import 'package:flutter/material.dart';

class BookingRequestScreen extends StatefulWidget {
  const BookingRequestScreen({super.key});

  @override
  State<BookingRequestScreen> createState() => _BookingRequestScreenState();
}

class _BookingRequestScreenState extends State<BookingRequestScreen> {
   final List<Map<String, dynamic>> scheduleData = [
    {
      'time': '09:00 AM',
      'client': 'Client Name',
      'service': 'Service names',
      'status': 'COMPLETED',
      'color': const Color(0xFFA8E6CF),
    },
    {
      'time': '12:00 PM',
      'client': 'Client Name',
      'service': 'Service names',
      'status': 'PENDING',
      'color': const Color(0xFFD1C4E9),
    },
    {
      'time': '02:30 PM',
      'client': 'Client Name',
      'service': 'Service names',
      'status': 'PENDING',
      'color': const Color(0xFFE1BEE7),
    },
  ];

  final List<String> times = [
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "01:00 PM",
    "02:00 PM",
    "03:00 PM",
    "04:00 PM",
    "05:00 PM",
    "06:00 PM",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Thursday, October 5",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: const [
          Icon(Icons.more_vert, color: Colors.black54),
          SizedBox(width: 10),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: times.length,
        itemBuilder: (context, index) {
          final appointment = scheduleData.firstWhere(
            (item) => item['time'] == times[index],
            orElse: () => {},
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                times[index],
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 6),
              appointment.isNotEmpty
                  ? AppionmentCard(
                      client: appointment['client'],
                      service: appointment['service'],
                      status: appointment['status'],
                      color: appointment['color'],
                    )
                  : const SizedBox(height: 50),
              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );;
  }
}