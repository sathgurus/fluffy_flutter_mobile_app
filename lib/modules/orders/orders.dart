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
    Booking(
      clientName: "Nithish Kumar",
      service: "Grooming",
      petDetails: "Golden Retriever",
      date: "12 Dec 2025",
      status: "Upcoming",
      price: 500,
    ),
    Booking(
      clientName: "Priya Sharma",
      service: "Boarding",
      petDetails: "Beagle",
      date: "10 Dec 2025",
      status: "Completed",
      price: 700,
    ),
    Booking(
      clientName: "Rahul Verma",
      service: "Training",
      petDetails: "German Shepherd",
      date: "15 Dec 2025",
      status: "Upcoming",
      price: 800,
    ),
    Booking(
      clientName: "Sneha Menon",
      service: "Breeding",
      petDetails: "Shih Tzu",
      date: "08 Dec 2025",
      status: "Cancelled",
      price: 0,
    ),
    Booking(
      clientName: "Arjun Patel",
      service: "Grooming",
      petDetails: "Pug",
      date: "14 Dec 2025",
      status: "Upcoming",
      price: 500,
    ),
    Booking(
      clientName: "Ananya Iyer",
      service: "Boarding",
      petDetails: "Persian Cat",
      date: "11 Dec 2025",
      status: "Completed",
      price: 700,
    ),
    Booking(
      clientName: "Karthik R",
      service: "Training",
      petDetails: "Indie Dog",
      date: "18 Dec 2025",
      status: "Upcoming",
      price: 800,
    ),
    Booking(
      clientName: "Vijay Kumar",
      service: "Grooming",
      petDetails: "Rottweiler",
      date: "20 Dec 2025",
      status: "Upcoming",
      price: 500,
    ),
    Booking(
      clientName: "Divya Lakshmi",
      service: "Boarding",
      petDetails: "Maine Coon",
      date: "22 Dec 2025",
      status: "Completed",
      price: 700,
    ),
    Booking(
      clientName: "Sathguru Nathan",
      service: "Breeding",
      petDetails: "Labrador",
      date: "13 Dec 2025",
      status: "Upcoming",
      price: 0,
    ),
    Booking(
      clientName: "Rahul Raj",
      service: "Grooming",
      petDetails: "Beagle",
      date: "09 Dec 2025",
      status: "Cancelled",
      price: 0,
    ),
    Booking(
      clientName: "Priyanka Singh",
      service: "Training",
      petDetails: "German Shepherd",
      date: "16 Dec 2025",
      status: "Upcoming",
      price: 800,
    ),
    Booking(
      clientName: "Aniket Sharma",
      service: "Boarding",
      petDetails: "Persian Cat",
      date: "17 Dec 2025",
      status: "Completed",
      price: 700,
    ),
    Booking(
      clientName: "Sneha Reddy",
      service: "Grooming",
      petDetails: "Pug",
      date: "19 Dec 2025",
      status: "Upcoming",
      price: 500,
    ),
    Booking(
      clientName: "Aditya Rao",
      service: "Training",
      petDetails: "Golden Retriever",
      date: "21 Dec 2025",
      status: "Upcoming",
      price: 800,
    ),
    Booking(
      clientName: "Divya Menon",
      service: "Boarding",
      petDetails: "Shih Tzu",
      date: "23 Dec 2025",
      status: "Completed",
      price: 700,
    ),
    Booking(
      clientName: "Kavya Nair",
      service: "Breeding",
      petDetails: "Maine Coon",
      date: "24 Dec 2025",
      status: "Upcoming",
      price: 0,
    ),
    Booking(
      clientName: "Arjun Reddy",
      service: "Grooming",
      petDetails: "Rottweiler",
      date: "25 Dec 2025",
      status: "Upcoming",
      price: 500,
    ),
    Booking(
      clientName: "Vikram Singh",
      service: "Boarding",
      petDetails: "Labrador",
      date: "26 Dec 2025",
      status: "Completed",
      price: 700,
    ),
    Booking(
      clientName: "Nisha Verma",
      service: "Training",
      petDetails: "Beagle",
      date: "27 Dec 2025",
      status: "Upcoming",
      price: 800,
    ),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case "Upcoming":
        return Colors.blue;
      case "Completed":
        return Colors.green;
      case "Cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getServiceIcon(String service) {
    switch (service.toLowerCase()) {
      case "grooming":
        return Icons.content_cut;
      case "boarding":
        return Icons.hotel;
      case "training":
        return Icons.school;
      case "breeding":
        return Icons.pets;
      default:
        return Icons.pets;
    }
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
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Booking List
            Expanded(
              child:
                  filteredBookings.isEmpty
                      ? const Center(child: Text("No bookings found"))
                      : ListView.separated(
                        itemCount: filteredBookings.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final booking = filteredBookings[index];

                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withOpacity(0.1),
                                  Colors.white,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: CircleAvatar(
                                radius: 28,
                                backgroundColor: AppColors.primary.withOpacity(
                                  0.2,
                                ),
                                child: Icon(
                                  _getServiceIcon(booking.service),
                                  color: AppColors.primary,
                                  size: 28,
                                ),
                              ),
                              title: Text(
                                booking.clientName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    "${booking.service} • ${booking.petDetails}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    booking.date,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "₹${booking.price}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(
                                    booking.status,
                                  ).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  booking.status,
                                  style: TextStyle(
                                    color: _getStatusColor(booking.status),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              onTap: () {
                                // Navigate to booking details
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
