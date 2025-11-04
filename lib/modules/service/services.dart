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

    return Scaffold(
      appBar: AppBar(title: const Text("Services")),
      body:
          serviceProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: serviceProvider.services.length,
                itemBuilder: (context, index) {
                  final service = serviceProvider.services[index];
                  return ListTile(
                    title: Text(service['name']),
                    subtitle: Text("₹ "),
                  );
                },
              ),
    );
  }
}
