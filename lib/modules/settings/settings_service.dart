import 'package:fluffy/modules/service/add_service_screen.dart';
import 'package:fluffy/modules/service/provider/service_provider.dart';
import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/shared/appbar_widget.dart';
import 'package:fluffy/modules/shared/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends StatefulWidget {
  const SettingsService({super.key});

  @override
  State<SettingsService> createState() => _SettingsServiceState();
}

class _SettingsServiceState extends State<SettingsService> {
  String? userId;

  @override
  void initState() {
    super.initState();
    loadUserAndFetch();
  }

  Future<void> loadUserAndFetch() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("userId");

    if (id != null) {
      userId = id;
      // Fetch services for this owner
      context.read<ServiceProvider>().fetchAllServicesByOwner(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServiceProvider>();

    return Scaffold(
      appBar: appBarWithBackButton(context, "Business Services"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.ownerByServices.isEmpty
                ? const Center(child: Text("No services available"))
                : ListView.builder(
                  itemCount: provider.ownerByServices.length,
                  itemBuilder: (_, index) {
                    final serviceCategory = provider.ownerByServices[index];
                    final serviceList = serviceCategory['services'] ?? [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Name
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                        //   child: Text(
                        //     serviceCategory['name'] ?? '',
                        //     style: const TextStyle(
                        //       fontSize: 18,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),

                        // Services in this category
                        ...List.generate(serviceList.length, (i) {
                          final s = serviceList[i];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            elevation: 3,
                            color: Colors.white,
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    serviceCategory['name'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    s['name'] ?? '',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Price: ₹${s['price'] ?? '-'}",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  Text(
                                    "Discount: ${s['discount'] ?? 0}%",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                s['serviceType'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: AppColors.whiteColor),
        label: const TextWidget(
          text: "Add Service",
          color: AppColors.whiteColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddServicesScreen()),
          );
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
