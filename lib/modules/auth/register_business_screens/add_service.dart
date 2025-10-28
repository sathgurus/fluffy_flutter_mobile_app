import 'package:fluffy/modules/auth/register_business_screens/add_pesonal_details.dart';
import 'package:flutter/material.dart';


class AddServices extends StatefulWidget {
  const AddServices({super.key});

  @override
  State<AddServices> createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController basePriceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  String discountType = 'Percentage';

  List<Map<String, String>> services = [
    {'name': 'Grooming', 'price': '₹1600.00'},
    {'name': 'Training Classes', 'price': '₹6000.00'},
  ];

  void addService() {
    String name = serviceNameController.text.trim();
    String basePrice = basePriceController.text.trim();
    String discount = discountController.text.trim();
    if (name.isNotEmpty && basePrice.isNotEmpty) {
      double price = double.tryParse(basePrice) ?? 0;
      double discountValue = double.tryParse(discount) ?? 0;

      if (discountType == 'Percentage') {
        price = price - (price * discountValue / 100);
      } else {
        price = price - discountValue;
      }
      if (price < 0) price = 0;

      setState(() {
        services.add({'name': name, 'price': '₹${price.toStringAsFixed(2)}'});
        serviceNameController.clear();
        basePriceController.clear();
        discountController.clear();
      });
    }
  }

  void resetForm() {
    serviceNameController.clear();
    basePriceController.clear();
    discountController.clear();
    setState(() {
      discountType = 'Percentage';
    });
  }

  void deleteService(int index) {
    setState(() {
      services.removeAt(index);
    });
  }

  // Dummy edit function for UI effect
  void editService(int index) {
    var service = services[index];
    serviceNameController.text = service['name']!;
    basePriceController.text = service['price']!.replaceAll('₹', '');
    // No discount restore in this example
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Your Business (Step 3 of 4)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              LinearProgressIndicator(
                minHeight: 5,
                value: 0.75,
                backgroundColor: Colors.grey.shade300,
                color: Colors.blue,
              ),
              SizedBox(height: 24),
              Text(
                'Define Your Services & Pricing',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Tell customers what amazing services you offer!',
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(height: 16),
              TextField(
                controller: serviceNameController,
                decoration: InputDecoration(
                  hintText: 'E.g. Grooming, Training, Pet Sitting',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  // Implement create new service action
                },
                child: Text(
                  "Didn't find your service? Create New Service",
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: basePriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Base Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: discountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter Discount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  DropdownButton<String>(
                    value: discountType,
                    items:
                        <String>['Percentage', 'Amount'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        discountType = newVal!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: addService,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent.shade100,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Add Service'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: resetForm,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.redAccent),
                      ),
                      child: Text(
                        'Reset',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'Your Offered Services',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'You can edit services later in Settings.',
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final item = services[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(item['name']!),
                      subtitle: Text(item['price']!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.black54),
                            onPressed: () => editService(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.black54),
                            onPressed: () => deleteService(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddPersonalDetails(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text('Continue', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
