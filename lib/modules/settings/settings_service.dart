import 'package:fluffy/modules/service/provider/service_provider.dart';
import 'package:fluffy/modules/shared/appbar_widget.dart';
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            serviceCategory['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

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
                              title: Text(s['name'] ?? ''),
                              subtitle: Text(
                                "Price: ₹${s['price'] ?? '-'} | Discount: ${s['discount'] ?? 0}%",
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
    );
  }
}
