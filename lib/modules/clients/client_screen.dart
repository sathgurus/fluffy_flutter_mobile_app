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
    return Scaffold(
      appBar: appBarWithBackButton(context, "Clients"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                fillColor: Colors.white,

                isDense: true, // 🔑 reduces height
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10, // adjust this (8–12 is ideal)
                  horizontal: 12,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.grey.shade500,
                    width: 0.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.grey.shade500,
                    width: 0.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.grey.shade500,
                    width: 0.8,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),
            // List of clients
            Expanded(
              child:
                  filteredClients.isEmpty
                      ? _noClientsFound()
                      : ListView.separated(
                        itemCount: filteredClients.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final client = filteredClients[index];

                          return Card(
                            color: AppColors.whiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              leading: CircleAvatar(
                                radius: 24,
                                backgroundColor: _getAvatarColor(client.name),
                                child: Text(
                                  client.name[0].toUpperCase(),
                                  style: TextStyle(
                                    color: _getTextColor(
                                      _getAvatarColor(client.name),
                                    ),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              title: Text(
                                client.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: TextWidget(text: client.petDetails),

                              onTap: () {
                                // TODO: Navigate to booking details page
                              },
                            ),
                          );
                        },
                      ),
              // ListView.separated(
              //   itemCount: filteredClients.length,
              //   separatorBuilder:
              //       (context, index) => SizedBox(height: 8),
              //   itemBuilder: (context, index) {
              //     final client = filteredClients[index];
              //     return Card(
              //       color: Colors.white,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(5),
              //       ),
              //       child: Padding(
              //         padding: EdgeInsets.all(5),
              //         child: ListTile(
              //           leading: CircleAvatar(
              //             radius: 20,
              //             backgroundColor:
              //                 Colors.primaries[Random().nextInt(
              //                   Colors.primaries.length,
              //                 )],
              //             child: Text(
              //               client.name.isNotEmpty
              //                   ? client.name[0].toUpperCase()
              //                   : "?",
              //               style: const TextStyle(
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.bold,
              //                 color: AppColors.whiteColor,
              //               ),
              //             ),
              //           ),
              //           title: TextWidget(text: client.name),
              //           subtitle: TextWidget(text: client.petDetails),
              //           onTap: () {},
              //         ),
              //       ),
              //     );
              //   },
              // ),
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

// Text color for contrast
Color _getTextColor(Color backgroundColor) {
  return backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}
