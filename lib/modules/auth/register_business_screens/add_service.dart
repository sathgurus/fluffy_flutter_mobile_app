import 'package:fluffy/modules/auth/register_business_screens/business_hours.dart';
import 'package:fluffy/modules/auth/register_business_screens/widget/add_service_bs.dart';
import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/auth/register_business_screens/business_verification.dart';
import 'package:fluffy/modules/auth/register_business_screens/model/service_model.dart';
import 'package:fluffy/modules/auth/register_business_screens/provider/Add_service_provider.dart';
import 'package:fluffy/modules/service/provider/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddServices extends StatefulWidget {
  const AddServices({super.key});

  @override
  State<AddServices> createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  final TextEditingController basePriceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  String discountType = 'Percentage';
  String? selectedParentId;
  String? selectedChildId;
  String? userId;

  @override
  void initState() {
    super.initState();
    loadUserData();
    Future.microtask(() {
      Provider.of<ServiceProvider>(context, listen: false).fetchAllServices();
      Provider.of<AddServiceProvider>(
        context,
        listen: false,
      ).getServicesByOwner(userId.toString());
    });
  }

  void loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getString("userId");
    });

    print("User ID: $userId");
  }

  void resetForm() {
    basePriceController.clear();
    discountController.clear();
    selectedParentId = null;
    selectedChildId = null;
    setState(() {
      discountType = 'Percentage';
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddServiceProvider>(context, listen: false);
    final selectedServices = provider.selectedServices;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Care'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Consumer<AddServiceProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Define Your Services & Pricing',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tell customers what amazing services you offer!',
                    style: TextStyle(color: Colors.grey[700]),
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      "Add Service",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      openAddServiceBottomSheet(context);

                      // resetForm();
                      FocusScope.of(context).unfocus();
                    },
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Your Offered Services',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  selectedServices == null || selectedServices.isEmpty
                      ? const Center(child: Text("No services added yet"))
                      : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: selectedServices.length,
                        itemBuilder: (context, index) {
                          final item = selectedServices[index];
                          print("item $item");

                          final name = item["service"];
                          final category = item["category"];
                          final basePrice = (item['basePrice'] ?? 0).toString();
                          final discount =
                              item['discountType'] == "Percentage"
                                  ? "${item['discount']} %"
                                  : " ₹ ${item['discount']}";

                          return Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    child: Text(
                                      name.isNotEmpty
                                          ? name[0].toUpperCase()
                                          : "",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "$name - $category",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Price: ₹$basePrice",
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "Discount: $discount",
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          bool result = await provider.submitServices(userId!);

                          if (result) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("✅ Services Added Successfully"),
                                backgroundColor: Colors.green,
                              ),
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BusinessHoursScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Failed to add services"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Add service failed. Please try again.',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration dropdownDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}
