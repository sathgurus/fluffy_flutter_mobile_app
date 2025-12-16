import 'dart:math';

import 'package:fluffy/modules/clients/model/client_model.dart';
import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/shared/appbar_widget.dart';
import 'package:fluffy/modules/shared/text_widget.dart';
import 'package:flutter/material.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  final TextEditingController _searchController = TextEditingController();

  late List<Client> filteredClients;

  final List<Client> demoClients = [
    Client(name: "Nithish Kumar", petDetails: "Golden Retriever, 3 years"),
    Client(name: "Sathguru Nathan", petDetails: "Labrador, 2 years"),
    Client(name: "Arjun Patel", petDetails: "Pug, 1 year"),
    Client(name: "Rahul Verma", petDetails: "German Shepherd, 4 years"),
    Client(name: "Priya Sharma", petDetails: "Beagle, 2 years"),
    Client(name: "Ananya Iyer", petDetails: "Persian Cat, 3 years"),
    Client(name: "Karthik R", petDetails: "Indie Dog, 5 years"),
    Client(name: "Sneha Menon", petDetails: "Shih Tzu, 1 year"),
    Client(name: "Vijay Kumar", petDetails: "Rottweiler, 6 years"),
    Client(name: "Divya Lakshmi", petDetails: "Maine Coon, 2 years"),
  ];

  @override
  void initState() {
    super.initState();
    filteredClients = demoClients;
  }

  void _filterClients(String query) {
    if (query.isEmpty) {
      filteredClients = demoClients;
    } else {
      filteredClients =
          demoClients
              .where(
                (client) =>
                    client.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: appBarWithBackButton(context, "Clients"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: _searchController,
              onChanged: _filterClients,
              decoration: InputDecoration(
                hintText: "Search Client Name",
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // List of clients
            Expanded(
              child: filteredClients.isEmpty
                  ? _noClientsFound()
                  : ListView.separated(
                      itemCount: filteredClients.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final client = filteredClients[index];

                        return InkWell(
                          onTap: () {
                            // Navigate to client details
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withOpacity(0.05),
                                  Colors.white,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: CircleAvatar(
                                radius: 28,
                                backgroundColor:
                                    _getAvatarColor(client.name).withOpacity(0.2),
                                child: Text(
                                  client.name[0].toUpperCase(),
                                  style: TextStyle(
                                    color: _getTextColor(
                                      _getAvatarColor(client.name),
                                    ),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              title: Text(
                                client.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle: Container(
                                margin: const EdgeInsets.only(top: 6),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  client.petDetails,
                                  style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                                ),
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
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

Widget _noClientsFound() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.search_off, size: 48, color: Colors.grey),
        SizedBox(height: 12),
        Text(
          "No clients found",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}

Color _getAvatarColor(String name) {
  final List<Color> colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.red,
    Colors.indigo,
    Colors.cyan,
    Colors.brown,
  ];
  return colors[name.hashCode % colors.length];
}

Color _getTextColor(Color backgroundColor) {
  return backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}