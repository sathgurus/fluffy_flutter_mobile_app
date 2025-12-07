import 'package:fluffy/modules/service/provider/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  void initState() {
    super.initState();

    // API Call only once when screen is opened
    Future.microtask(() {
      Provider.of<ServiceProvider>(context, listen: false).fetchAllServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);
    print("services data ${serviceProvider.services}");

    return Scaffold(
      appBar: AppBar(title: const Text("Services")),
      body:
          serviceProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: serviceProvider.services.length,
                itemBuilder: (context, index) {
                  final category = serviceProvider.services[index];
                  final subServices = category['services'] as List<dynamic>;

                  return ExpansionTile(
                    title: Text(category['name']),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: subServices.length,
                        itemBuilder: (context, subIndex) {
                          final sub = subServices[subIndex];
                          return ListTile(
                            title: Text(sub['name']),
                            subtitle: Text("₹ ${sub['price']}"),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
    );
  }
}
