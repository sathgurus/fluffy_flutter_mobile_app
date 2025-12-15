import 'package:fluffy/modules/auth/register_business_screens/business_hours.dart';
import 'package:fluffy/modules/auth/register_business_screens/widget/add_service_bs.dart';
import 'package:fluffy/modules/settings/settings_service.dart';
import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/auth/register_business_screens/business_verification.dart';
import 'package:fluffy/modules/auth/register_business_screens/model/service_model.dart';
import 'package:fluffy/modules/auth/register_business_screens/provider/Add_service_provider.dart';
import 'package:fluffy/modules/service/provider/service_provider.dart';
import 'package:fluffy/modules/shared/appbar_widget.dart';
import 'package:fluffy/modules/shared/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddServicesScreen extends StatefulWidget {
  const AddServicesScreen({super.key});

  @override
  State<AddServicesScreen> createState() => _AddServicesScreenState();
}

class _AddServicesScreenState extends State<AddServicesScreen> {
  final TextEditingController basePriceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  String discountType = 'Percentage';
  String? selectedParentId;
  String? selectedChildId;
  String? userId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ServiceProvider>(context, listen: false).fetchAllServices();
    });
    loadUserData();
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
    final sp = Provider.of<ServiceProvider>(context);
    final provider = Provider.of<AddServiceProvider>(context, listen: false);
    final selectedServices = provider.selectedServices;

    final parentList = sp.services; // API response
    final childList =
        selectedParentId != null
            ? parentList.firstWhere(
                  (p) => p['_id'] == selectedParentId,
                  orElse: () => {},
                )['services'] ??
                []
            : [];

    return Scaffold(
      appBar: appBarWithBackButton(context, "Add Services"),
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

                          print("item data $item");

                          final String name = item["service"] ?? "";
                          final String category = item["category"] ?? "";
                          final double basePrice =
                              double.tryParse(item['basePrice'].toString()) ??
                              0;
                          final double discount =
                              double.tryParse(item['discount'].toString()) ?? 0;
                          final String discountType =
                              item['discountType'] ?? "";

                          // -------- PRICE CALCULATION --------
                          double finalPrice =
                              double.tryParse(item['price'].toString()) ?? 0;

                          final String discountText =
                              discountType == "Percentage"
                                  ? "${discount.toStringAsFixed(0)}% OFF"
                                  : "₹${discount.toStringAsFixed(0)} OFF";

                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Avatar
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

                                  const SizedBox(width: 14),

                                  // Content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          category,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        // -------- PRICE ROW --------
                                        Row(
                                          children: [
                                            // Base price (strike)
                                            Text(
                                              "₹${basePrice.toStringAsFixed(0)}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black45,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),

                                            const SizedBox(width: 6),

                                            // Discount badge
                                            if (discount > 0)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.green.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  discountText,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),

                                            const SizedBox(width: 6),

                                            // Final price
                                            Text(
                                              "₹${finalPrice.toStringAsFixed(0)}",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Actions
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          openAddServiceBottomSheet(
                                            context,
                                            isEdit: true,
                                            item: item,
                                          );
                                        },
                                        child: const Icon(
                                          Icons.edit,
                                          size: 20,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (ctx) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                title: const Text(
                                                  "Delete Service",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                content: Text(
                                                  "Are you sure you want to delete \"$name\"?",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () =>
                                                            Navigator.pop(ctx),
                                                    child: const Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      /// 🔥 CALL PROVIDER DELETE
                                                      provider.deleteService(
                                                        item['_id'],
                                                      );

                                                      Navigator.pop(
                                                        ctx,
                                                      ); // close dialog
                                                    },
                                                    child: const Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
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
                            ToastificationShow.showToast(
                              context: context,
                              title: "Add Services",
                              description: "Services Added Successfully",
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SettingsService(),
                              ),
                            );
                          } else {
                           ToastificationShow.showToast(
                              context: context,
                              title: "Add Services",
                              description: "Failed to add services",
                            );
                          }
                        } catch (e) {
                         ToastificationShow.showToast(
                            context: context,
                            title: "Add Services",
                            description:
                                "Add service failed. Please try again.",
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
