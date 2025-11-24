import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:flutter/material.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Details"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dog Info Card
            Card(
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.pets, size: 28),
                  radius: 24,
                ),
                title: Text('Dog Name'),
                subtitle: Text('Golden Retriever, 3 years old'),
              ),
            ),
            SizedBox(height: 16),
            // Requested Services
            Card(
               color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Requested Services",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "PENDING",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    CheckboxListTile(
                      value: true,
                      onChanged: (_) {},
                      title: Text('Full Grooming'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      value: false,
                      onChanged: (_) {},
                      title: Text('Nail Clipping'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Schedule
            Card(
               color: Colors.white,
              child: ListTile(
                leading: Icon(Icons.schedule, color: Colors.deepPurple),
                title: Text('Thursday, October 5'),
                subtitle: Text('10:00 AM - 12:00 PM'),
              ),
            ),
            SizedBox(height: 16),
            // Customer Notes
            Card(
               color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Notes',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Buddy can be a little nervous around new people. Please be patient with him.',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            // Accept and Decline buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text("Accept"),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                    child: Text("Decline"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      
    );
    
  }
}
