import 'package:fluffy/modules/orders/model/order_model.dart';
import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/shared/appbar_widget.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrdersScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Booking> demoBookings = [
  Booking(clientName: "Nithish Kumar", service: "Grooming", petDetails: "Golden Retriever", date: "12 Dec 2025", status: "Upcoming", price: 500),
  Booking(clientName: "Priya Sharma", service: "Boarding", petDetails: "Beagle", date: "10 Dec 2025", status: "Completed", price: 700),
  Booking(clientName: "Rahul Verma", service: "Training", petDetails: "German Shepherd", date: "15 Dec 2025", status: "Upcoming", price: 800),
  Booking(clientName: "Sneha Menon", service: "Breeding", petDetails: "Shih Tzu", date: "08 Dec 2025", status: "Cancelled", price: 0),
  Booking(clientName: "Arjun Patel", service: "Grooming", petDetails: "Pug", date: "14 Dec 2025", status: "Upcoming", price: 500),
  Booking(clientName: "Ananya Iyer", service: "Boarding", petDetails: "Persian Cat", date: "11 Dec 2025", status: "Completed", price: 700),
  Booking(clientName: "Karthik R", service: "Training", petDetails: "Indie Dog", date: "18 Dec 2025", status: "Upcoming", price: 800),
  Booking(clientName: "Vijay Kumar", service: "Grooming", petDetails: "Rottweiler", date: "20 Dec 2025", status: "Upcoming", price: 500),
  Booking(clientName: "Divya Lakshmi", service: "Boarding", petDetails: "Maine Coon", date: "22 Dec 2025", status: "Completed", price: 700),
  Booking(clientName: "Sathguru Nathan", service: "Breeding", petDetails: "Labrador", date: "13 Dec 2025", status: "Upcoming", price: 0),
  Booking(clientName: "Rahul Raj", service: "Grooming", petDetails: "Beagle", date: "09 Dec 2025", status: "Cancelled", price: 0),
  Booking(clientName: "Priyanka Singh", service: "Training", petDetails: "German Shepherd", date: "16 Dec 2025", status: "Upcoming", price: 800),
  Booking(clientName: "Aniket Sharma", service: "Boarding", petDetails: "Persian Cat", date: "17 Dec 2025", status: "Completed", price: 700),
  Booking(clientName: "Sneha Reddy", service: "Grooming", petDetails: "Pug", date: "19 Dec 2025", status: "Upcoming", price: 500),
  Booking(clientName: "Aditya Rao", service: "Training", petDetails: "Golden Retriever", date: "21 Dec 2025", status: "Upcoming", price: 800),
  Booking(clientName: "Divya Menon", service: "Boarding", petDetails: "Shih Tzu", date: "23 Dec 2025", status: "Completed", price: 700),
  Booking(clientName: "Kavya Nair", service: "Breeding", petDetails: "Maine Coon", date: "24 Dec 2025", status: "Upcoming", price: 0),
  Booking(clientName: "Arjun Reddy", service: "Grooming", petDetails: "Rottweiler", date: "25 Dec 2025", status: "Upcoming", price: 500),
  Booking(clientName: "Vikram Singh", service: "Boarding", petDetails: "Labrador", date: "26 Dec 2025", status: "Completed", price: 700),
  Booking(clientName: "Nisha Verma", service: "Training", petDetails: "Beagle", date: "27 Dec 2025", status: "Upcoming", price: 800),
];


  late List<Booking> filteredBookings;

  @override
  void initState() {
    super.initState();
    filteredBookings = demoBookings;
    _searchController.addListener(() {
      _filterBookings(_searchController.text);
    });
  }

  void _filterBookings(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredBookings = demoBookings;
      });
    } else {
      setState(() {
        filteredBookings =
            demoBookings
                .where(
                  (b) =>
                      b.clientName.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithBackButton(context, "Bookings"),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search Client Name",
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 0.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 0.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 0.8,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Booking List
            Expanded(
              child:
                  filteredBookings.isEmpty
                      ? const Center(child: Text("No bookings found"))
                      : ListView.separated(
                        itemCount: filteredBookings.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final booking = filteredBookings[index];

                          return Card(
                            color: AppColors.whiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              leading: CircleAvatar(
                                radius: 24,
                                backgroundColor: _getAvatarColor(
                                  booking.clientName,
                                ),
                                child: Text(
                                  booking.clientName[0].toUpperCase(),
                                  style: TextStyle(
                                    color: _getTextColor(
                                      _getAvatarColor(booking.clientName),
                                    ),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              title: Text(
                                booking.clientName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${booking.service} • ${booking.petDetails}",
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    booking.date,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              trailing: _statusChip(booking.status),
                              onTap: () {
                                // TODO: Navigate to booking details page
                              },
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _statusChip(String status) {
  Color bgColor;
  switch (status) {
    case "Upcoming":
      bgColor = Colors.blue;
      break;
    case "Completed":
      bgColor = Colors.green;
      break;
    case "Cancelled":
      bgColor = Colors.red;
      break;
    default:
      bgColor = Colors.grey;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: bgColor.withOpacity(0.15),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      status,
      style: TextStyle(
        color: bgColor,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

// Avatar color based on name
Color _getAvatarColor(String name) {
  final List<Color> colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.red,
    Colors.indigo,
    Colors.cyan,
    Colors.brown,
  ];
  return colors[name.hashCode % colors.length];
}

// Text color for contrast
Color _getTextColor(Color backgroundColor) {
  return backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}
