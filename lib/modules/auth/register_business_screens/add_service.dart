import 'package:fluffy/modules/auth/register_business_screens/business_hours.dart';
import 'package:fluffy/modules/auth/register_business_screens/widget/add_service_bs.dart';
import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/auth/register_business_screens/provider/Add_service_provider.dart';
import 'package:fluffy/modules/service/provider/service_provider.dart';
import 'package:fluffy/modules/shared/appbar_widget.dart';
import 'package:fluffy/modules/shared/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddServices extends StatefulWidget {
  const AddServices({super.key});

  @override
  State<AddServices> createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
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
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddServiceProvider>(context);
    final selectedServices = provider.selectedServices;

    return Scaffold(
      appBar: appBarWithBackButton(context, "Add Services"),
      body: Padding(
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
              const SizedBox(height: 20),

              /// ➕ ADD SERVICE BUTTON
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
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
                  FocusScope.of(context).unfocus();
                },
              ),

              const SizedBox(height: 24),
              const Text(
                'Your Offered Services',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              /// 📋 SERVICE LIST
              selectedServices.isEmpty
                  ? const Center(child: Text("No services added yet"))
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: selectedServices.length,
                    itemBuilder: (context, index) {
                      final item = selectedServices[index];

                      final String name = item["service"] ?? "";
                      final String category = item["category"] ?? "";

                      final double weekdayPrice =
                          double.tryParse(
                            item['weekdayPrice']?.toString() ?? '',
                          ) ??
                          0;
                      final double weekendPrice =
                          double.tryParse(
                            item['weekendPrice']?.toString() ?? '',
                          ) ??
                          0;

                      final double weekdayDiscount =
                          double.tryParse(
                            item['weekdayDiscount']?.toString() ?? '',
                          ) ??
                          0;
                      final double weekendDiscount =
                          double.tryParse(
                            item['weekendDiscount']?.toString() ?? '',
                          ) ??
                          0;

                      final String discountType = item['discountType'] ?? "";

                      final double finalWeekdayPrice =
                          double.tryParse(
                            item['finalWeekdayPrice']?.toString() ?? '',
                          ) ??
                          weekdayPrice;

                      final double finalWeekendPrice =
                          double.tryParse(
                            item['finalWeekendPrice']?.toString() ?? '',
                          ) ??
                          weekendPrice;

                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// ICON
                              CircleAvatar(
                                radius: 20,
                                child: Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : "",
                                ),
                              ),
                              const SizedBox(width: 14),

                              /// DETAILS
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      category,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    priceRow(
                                      label: "Weekdays",
                                      originalPrice: weekdayPrice,
                                      discount: weekdayDiscount,
                                      finalPrice: finalWeekdayPrice,
                                      discountType: discountType,
                                    ),

                                    const SizedBox(height: 4),

                                    priceRow(
                                      label: "Weekend",
                                      originalPrice: weekendPrice,
                                      discount: weekendDiscount,
                                      finalPrice: finalWeekendPrice,
                                      discountType: discountType,
                                    ),

                                    if (discountType.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          "Discount Type: $discountType",
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              /// ACTIONS
                              Column(
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
                                  const SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
                                      provider.deleteService(item['_id']);
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

              /// ➡️ CONTINUE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    bool result = await provider.submitServices(userId ?? "");

                    if (result) {
                      ToastificationShow.showToast(
                        context: context,
                        title: "Add Services",
                        description: "Services Added Successfully",
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BusinessHoursScreen(),
                        ),
                      );
                    } else {
                      ToastificationShow.showToast(
                        context: context,
                        title: "Add Services",
                        description: "Failed to add services",
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
      ),
    );
  }
}

Widget priceRow({
  required String label,
  required double originalPrice,
  required double discount,
  required double finalPrice,
  required String discountType,
}) {
  String discountText =
      discountType == "Percentage"
          ? "${discount.toStringAsFixed(0)}% OFF"
          : "₹${discount.toStringAsFixed(0)} OFF";

  return Row(
    children: [
      Text(
        "$label:",
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      const SizedBox(width: 6),
      Text(
        "₹${originalPrice.toStringAsFixed(0)}",
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black45,
          decoration: TextDecoration.lineThrough,
        ),
      ),
      const SizedBox(width: 6),
      if (discount > 0)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(4),
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
      Text(
        "₹${finalPrice.toStringAsFixed(0)}",
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
    ],
  );
}
