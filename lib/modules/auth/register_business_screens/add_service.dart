import 'package:fluffy/modules/auth/register_business_screens/widget/add_service_bs.dart';
import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/auth/register_business_screens/business_verification.dart';
import 'package:fluffy/modules/auth/register_business_screens/model/service_model.dart';
import 'package:fluffy/modules/auth/register_business_screens/provider/Add_service_provider.dart';
import 'package:fluffy/modules/service/provider/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  List<Map<String, dynamic>> selectedServices = [];
  List<Map<String, dynamic>> finalSelectedServices = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ServiceProvider>(context, listen: false).fetchAllServices();
    });
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
                  // const Text(
                  //   'Add Your Business (Step 3 of 4)',
                  //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  // ),
                  // const SizedBox(height: 16),
                  // LinearProgressIndicator(
                  //   minHeight: 5,
                  //   value: 0.75,
                  //   backgroundColor: Colors.grey.shade300,
                  //   color: Colors.blue,
                  // ),
                  // const SizedBox(height: 24),
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

                  // DropdownButtonFormField<String>(
                  //   isExpanded: true,
                  //   value: selectedParentId,
                  //   decoration: dropdownDecoration(),
                  //   hint: const Text("Choose Category"),
                  //   items:
                  //       parentList.map<DropdownMenuItem<String>>((category) {
                  //         return DropdownMenuItem<String>(
                  //           value: category['_id'].toString(),
                  //           child: Text(category['name']),
                  //         );
                  //       }).toList(),
                  //   onChanged: (value) {
                  //     setState(() {
                  //       selectedParentId = value;
                  //       selectedChildId = null;
                  //     });
                  //   },
                  // ),

                  // const SizedBox(height: 20),

                  // DropdownButtonFormField<String>(
                  //   isExpanded: true,
                  //   value: selectedChildId,
                  //   decoration: dropdownDecoration(),
                  //   hint: const Text("Choose Service"),
                  //   items:
                  //       (childList as List<dynamic>)
                  //           .map<DropdownMenuItem<String>>((item) {
                  //             return DropdownMenuItem<String>(
                  //               value: item['_id'].toString(),
                  //               child: Text(item['name']),
                  //             );
                  //           })
                  //           .toList(),
                  //   onChanged: (value) {
                  //     setState(() {
                  //       selectedChildId = value;
                  //     });
                  //   },
                  // ),

                  // const SizedBox(height: 12),

                  // TextField(
                  //   controller: basePriceController,
                  //   keyboardType: TextInputType.number,
                  //   decoration: InputDecoration(
                  //     hintText: 'Enter Base Price',
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //   ),
                  // ),

                  // const SizedBox(height: 12),

                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: TextField(
                  //         controller: discountController,
                  //         keyboardType: TextInputType.number,
                  //         decoration: InputDecoration(
                  //           hintText: 'Enter Discount',
                  //           border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(12),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 8),

                  //     DropdownButton<String>(
                  //       value: discountType,
                  //       items:
                  //           ['Percentage', 'Amount']
                  //               .map(
                  //                 (e) => DropdownMenuItem(
                  //                   value: e,
                  //                   child: Text(e),
                  //                 ),
                  //               )
                  //               .toList(),
                  //       onChanged:
                  //           (value) => setState(() => discountType = value!),
                  //     ),
                  //   ],
                  // ),
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
                      // if (selectedParentId == null || selectedChildId == null) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(
                      //       content: Text(
                      //         "Please select both category and service",
                      //       ),
                      //     ),
                      //   );
                      //   return;
                      // }

                      // final parent = parentList.firstWhere(
                      //   (p) => p['_id'] == selectedParentId,
                      // );
                      // final child = childList.firstWhere(
                      //   (c) => c['_id'] == selectedChildId,
                      // );

                      // String price = basePriceController.text.trim();
                      // String discount = discountController.text.trim();

                      // if (price.isEmpty) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(content: Text("Enter base price")),
                      //   );
                      //   return;
                      // }

                      // double finalPrice = double.parse(price);
                      // if (discount.isNotEmpty) {
                      //   double discountVal = double.parse(discount);
                      //   if (discountType == 'Percentage') {
                      //     finalPrice =
                      //         finalPrice - (finalPrice * discountVal / 100);
                      //   } else {
                      //     finalPrice -= discountVal;
                      //   }
                      //   if (finalPrice < 0) finalPrice = 0;
                      // }

                      // setState(() {
                      //   String parentName = parent['name'];
                      //   String childName = child['name'];

                      //   int categoryIndex = finalSelectedServices.indexWhere(
                      //     (item) => item['name'] == parentName,
                      //   );

                      //   if (categoryIndex != -1) {
                      //     // ✅ Add inside existing category
                      //     finalSelectedServices[categoryIndex]['services'].add({
                      //       "name": childName,
                      //       "price": finalPrice,
                      //     });
                      //   } else {
                      //     // ✅ Create new category
                      //     finalSelectedServices.add({
                      //       "name": parentName,
                      //       "services": [
                      //         {
                      //           "name": childName,
                      //           "price": price,
                      //           discount: discount,
                      //         },
                      //       ],
                      //     });
                      //   }

                      //   print("final selected service $finalSelectedServices");

                      //   selectedServices.add({
                      //     '_id': child['_id'],
                      //     'category': parent['name'],
                      //     'service': child['name'],
                      //     'basePrice': price,
                      //     'discount': discount.isEmpty ? "0" : discount,
                      //     'discountType': discount.isEmpty ? "" : discountType,
                      //     'price': finalPrice.toStringAsFixed(2),
                      //   });
                      // });

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

                  selectedServices.isEmpty
                      ? const Center(child: Text("No services added yet"))
                      : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: selectedServices.length,
                        itemBuilder: (context, index) {
                          final item = selectedServices[index];
                          return Card(
                            color: Colors.white,
                            child: ListTile(
                              title: Text(
                                "${item['service']} (${item['category']})",
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Base Price: ₹${item['basePrice']}"),
                                  Text(
                                    "Discount: ${item['discount']} ${item['discountType']}",
                                  ),
                                  Text("Final Price: ₹${item['price']}"),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(
                                    () => selectedServices.removeAt(index),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        try {
                          // var businessOwnerId = "690cea0ca953fbe2bb4e29d9";

                          // provider.submitServices(
                          //   businessOwnerId,
                          //   finalSelectedServices,
                          // );
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) => const AddPersonalDetails(),
                          //   ),
                          // );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("✅ Services Added Successfully"),
                              backgroundColor: Colors.green,
                            ),
                          );
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
