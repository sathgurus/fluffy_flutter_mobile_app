import 'package:fluffy/modules/orders/model/order_model.dart';
import 'package:fluffy/modules/dashoboard/widget/financial_Card.dart';
import 'package:fluffy/modules/dashoboard/widget/service_tile_card.dart';
import 'package:fluffy/modules/shared/appbar_widget.dart';
import 'package:flutter/material.dart';

class FinancialOverview extends StatefulWidget {
  const FinancialOverview({super.key});

  @override
  State<FinancialOverview> createState() => _FinancialOverviewState();
}

class _FinancialOverviewState extends State<FinancialOverview> {
  final TextEditingController _searchController = TextEditingController();

  late List<Booking> _filteredBookings;

final List<Booking> demoBookings = [
  Booking.withServiceDuration(clientName: "Nithish Kumar", service: "Grooming", petDetails: "Golden Retriever", date: "01 Dec 2025", status: "Completed", price: 500),
  Booking.withServiceDuration(clientName: "Priya Sharma", service: "Boarding", petDetails: "Beagle", date: "02 Dec 2025", status: "Completed", price: 700),
  Booking.withServiceDuration(clientName: "Rahul Verma", service: "Training", petDetails: "German Shepherd", date: "03 Dec 2025", status: "Completed", price: 800),
  Booking.withServiceDuration(clientName: "Sneha Menon", service: "Breeding", petDetails: "Shih Tzu", date: "04 Dec 2025", status: "Completed", price: 600),
  Booking.withServiceDuration(clientName: "Arjun Patel", service: "Grooming", petDetails: "Pug", date: "05 Dec 2025", status: "Completed", price: 500),
  Booking.withServiceDuration(clientName: "Ananya Iyer", service: "Boarding", petDetails: "Persian Cat", date: "06 Dec 2025", status: "Completed", price: 700),
  Booking.withServiceDuration(clientName: "Karthik R", service: "Training", petDetails: "Indie Dog", date: "07 Dec 2025", status: "Completed", price: 800),
  Booking.withServiceDuration(clientName: "Vijay Kumar", service: "Grooming", petDetails: "Rottweiler", date: "08 Dec 2025", status: "Completed", price: 500),
  Booking.withServiceDuration(clientName: "Divya Lakshmi", service: "Boarding", petDetails: "Maine Coon", date: "09 Dec 2025", status: "Completed", price: 700),
  Booking.withServiceDuration(clientName: "Sathguru Nathan", service: "Breeding", petDetails: "Labrador", date: "10 Dec 2025", status: "Completed", price: 600),

  Booking.withServiceDuration(clientName: "Rahul Raj", service: "Grooming", petDetails: "Beagle", date: "11 Dec 2025", status: "Completed", price: 500),
  Booking.withServiceDuration(clientName: "Priyanka Singh", service: "Training", petDetails: "German Shepherd", date: "12 Dec 2025", status: "Completed", price: 800),
  Booking.withServiceDuration(clientName: "Aniket Sharma", service: "Boarding", petDetails: "Persian Cat", date: "13 Dec 2025", status: "Completed", price: 700),
  Booking.withServiceDuration(clientName: "Sneha Reddy", service: "Grooming", petDetails: "Pug", date: "14 Dec 2025", status: "Completed", price: 500),
  Booking.withServiceDuration(clientName: "Aditya Rao", service: "Training", petDetails: "Golden Retriever", date: "15 Dec 2025", status: "Completed", price: 800),
  Booking.withServiceDuration(clientName: "Divya Menon", service: "Boarding", petDetails: "Shih Tzu", date: "16 Dec 2025", status: "Completed", price: 700),
  Booking.withServiceDuration(clientName: "Kavya Nair", service: "Breeding", petDetails: "Maine Coon", date: "17 Dec 2025", status: "Completed", price: 600),
  Booking.withServiceDuration(clientName: "Arjun Reddy", service: "Grooming", petDetails: "Rottweiler", date: "18 Dec 2025", status: "Completed", price: 500),
  Booking.withServiceDuration(clientName: "Vikram Singh", service: "Boarding", petDetails: "Labrador", date: "19 Dec 2025", status: "Completed", price: 700),
  Booking.withServiceDuration(clientName: "Nisha Verma", service: "Training", petDetails: "Beagle", date: "20 Dec 2025", status: "Completed", price: 800),
];


  @override
  void initState() {
    super.initState();
    _filteredBookings = completedServices;
  }

  double get totalRevenue =>
      completedServices.fold(0.0, (sum, b) => sum + b.price);

  List<Booking> get completedServices =>
      demoBookings.where((b) => b.status == "Completed").toList();

  void _filterServices(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredBookings = completedServices;
      } else {
        _filteredBookings =
            completedServices.where((booking) {
              return booking.service.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  booking.clientName.toLowerCase().contains(
                    query.toLowerCase(),
                  );
            }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithBackButton(context, "Financial Overview"),
      backgroundColor: const Color(0xffF5F6FA),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Fixed Summary Card
            FinancialSummaryCard(
              totalRevenue: totalRevenue,
              totalClients: demoBookings.length,
            ),

            const SizedBox(height: 20),

            const Text(
              "Service Performance",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // ✅ Search Field
            TextField(
              controller: _searchController,
              onChanged: _filterServices,
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
            const SizedBox(height: 12),

            // ✅ Scrollable List
            Expanded(
              child:
                  _filteredBookings.isEmpty
                      ? const Center(
                        child: Text(
                          "No services found",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      )
                      : ListView.separated(
                        itemCount: _filteredBookings.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, index) {
                          final booking = _filteredBookings[index];
                          return ServiceTile(
                            title: booking.service,
                            duration: booking.duration!,
                            value: "₹ ${booking.price.toStringAsFixed(2)}",
                            totalOrders: "1",
                            color:
                                Colors.primaries[index %
                                    Colors.primaries.length],
                            clientName: booking.clientName,
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
