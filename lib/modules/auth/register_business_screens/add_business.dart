import 'package:fluffy/modules/auth/provider/auth_provider.dart';
import 'package:fluffy/modules/auth/register_business_screens/add_location.dart';
import 'package:fluffy/modules/auth/register_business_screens/model/business_model.dart';
import 'package:fluffy/modules/auth/register_business_screens/provider/business_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBusinessScreen extends StatefulWidget {
  const AddBusinessScreen({super.key});

  @override
  State<AddBusinessScreen> createState() => _AddBusinessScreenState();
}

class _AddBusinessScreenState extends State<AddBusinessScreen> {
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessDescriptionController =
      TextEditingController();
  final TextEditingController businessPhoneController = TextEditingController();
  final TextEditingController alternatePhoneController =
      TextEditingController();
  final TextEditingController businessEmailController = TextEditingController();
  final TextEditingController businessWebsiteController =
      TextEditingController();

  @override
  void dispose() {
    businessNameController.dispose();
    businessDescriptionController.dispose();
    businessPhoneController.dispose();
    alternatePhoneController.dispose();
    businessEmailController.dispose();
    businessWebsiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final businessProvider = Provider.of<BusinessProvider>(context);
    final authProvider = Provider.of<LoginProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Care'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Your Business (Step 1 of 4)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.25,
              minHeight: 5,
              color: Colors.blue,
              backgroundColor: Colors.grey.shade300,
            ),
            SizedBox(height: 24),
            Text(
              'BUSINESS DETAILS',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            TextField(
              controller: businessNameController,
              decoration: InputDecoration(
                labelText: 'Business Name',
                hintText: 'eg., your shop name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: businessDescriptionController,
              decoration: InputDecoration(
                labelText: 'Business Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            SizedBox(height: 24),
            Text(
              'CONTACT DETAILS',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            TextField(
              controller: businessPhoneController,
              decoration: InputDecoration(
                labelText: 'Business Phone',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextField(
              controller: alternatePhoneController,
              decoration: InputDecoration(
                labelText: 'Alternate Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextField(
              controller: businessEmailController,
              decoration: InputDecoration(
                labelText: 'Business Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: businessWebsiteController,
              decoration: InputDecoration(
                labelText: 'Business Website',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () async {
                  if (businessNameController.text.isEmpty ||
                      businessPhoneController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Required fields missing")),
                    );
                    return;
                  }

                  BusinessModel business = BusinessModel(
                    businessName: businessNameController.text,
                    businessDescription: businessDescriptionController.text,
                    businessPhone: businessPhoneController.text,
                    alternatePhone: alternatePhoneController.text,
                    businessEmail: businessEmailController.text,
                    businessWebsite: businessWebsiteController.text,
                    ownerId: "690cea0ca953fbe2bb4e29d9",
                  );

                  bool success = await businessProvider.addBusiness(business);

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Business Added Successfully ✅")),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to Add Business ❌")),
                    );
                  }
                },
                child: Text('Continue', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
