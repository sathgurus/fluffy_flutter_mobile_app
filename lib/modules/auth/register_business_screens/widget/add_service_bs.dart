import 'package:fluffy/modules/auth/register_business_screens/provider/Add_service_provider.dart';
import 'package:fluffy/modules/service/provider/service_provider.dart';
import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/shared/constant.dart';
import 'package:fluffy/modules/shared/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void openAddServiceBottomSheet(BuildContext context) {
  final sp = Provider.of<ServiceProvider>(context, listen: false);
  final addServiceProvider = Provider.of<AddServiceProvider>(
    context,
    listen: false,
  );

  String? parentId;
  String? childId;
  TextEditingController priceCtrl = TextEditingController();
  TextEditingController discountCtrl = TextEditingController();
  String discountType = "Percentage";
  List<String> taxOptions = ['Percentage', 'Amount'];
  String selectedServiceType = "weekday";

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final parentList = sp.services;

          final childList =
              parentId != null
                  ? parentList.firstWhere(
                        (p) => p['_id'] == parentId,
                        orElse: () => {},
                      )['services'] ??
                      []
                  : [];

          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: TextWidget(
                            text: "Add Services",
                            fontSize: textSizeNormal,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Icon(Icons.close, color: Colors.grey),
                      ],
                    ),

                    const SizedBox(height: 10),

                    const Divider(thickness: 0.5, color: Colors.grey),
                    const SizedBox(height: 10),

                    DropdownButtonFormField(
                      isExpanded: true,
                      value: parentId,
                      items:
                          parentList.map<DropdownMenuItem<String>>((cat) {
                            return DropdownMenuItem(
                              value: cat["_id"],
                              child: Text(cat["name"]),
                            );
                          }).toList(),
                      onChanged: (val) {
                        setState(() {
                          parentId = val;
                          childId = null;
                        });
                      },

                      decoration: dropdownDecoration("Select Category"),
                    ),

                    const SizedBox(height: 20),

                    DropdownButtonFormField(
                      isExpanded: true,
                      value: childId,
                      items:
                          (childList as List).map<DropdownMenuItem<String>>((
                            srv,
                          ) {
                            return DropdownMenuItem(
                              value: srv["_id"],
                              child: Text(srv["name"]),
                            );
                          }).toList(),
                      onChanged: (val) {
                        setState(() => childId = val);
                      },
                      decoration: dropdownDecoration("Select Service"),
                    ),

                    const SizedBox(height: 20),

                    TextWidget(
                      text: "Service Type",
                      fontWeight: FontWeight.w400,
                      fontSize: textSizeSMedium,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Radio(
                          value: "weekday",
                          groupValue: selectedServiceType,
                          onChanged: (value) {
                            setState(
                              () => selectedServiceType = value.toString(),
                            );
                          },
                          activeColor: AppColors.primary,
                        ),
                        const Text("Weekday"),

                        const SizedBox(width: 20),

                        Radio(
                          value: "weekend",
                          groupValue: selectedServiceType,
                          onChanged: (value) {
                            setState(
                              () => selectedServiceType = value.toString(),
                            );
                          },
                          activeColor: AppColors.primary,
                        ),
                        const Text("Weekend"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: priceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: TextWidget(text: "Price"),
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: discountCtrl,
                      decoration: InputDecoration(
                        label: TextWidget(text: "Discount"),
                        border: const OutlineInputBorder(),
                        suffixIconConstraints: const BoxConstraints(
                          maxHeight: 18,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        suffixIcon: Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(color: Colors.grey, width: 1.0),
                            ),
                          ),

                          //height: 10,
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          margin: const EdgeInsets.only(right: 5),
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: DropdownButton<String>(
                            isExpanded: true,
                            underline: Container(),
                            value: discountType,
                            onChanged: (newValue) {
                              setState(() {
                                discountType = newValue!;
                              });
                            },
                            items:
                                taxOptions.map<DropdownMenuItem<String>>((
                                  String value,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: TextWidget(
                                      text: value,
                                      fontWeight: FontWeight.w400,
                                      fontSize: textSizeSmall2,
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {},
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (parentId == null || childId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Select category & service"),
                              ),
                            );
                            return;
                          }
                          final parent = parentList.firstWhere(
                            (p) => p['_id'] == parentId,
                          );
                          final child = childList.firstWhere(
                            (c) => c['_id'] == childId,
                          );

                          String price = priceCtrl.text.trim();
                          String discount = discountCtrl.text.trim();
                          String parentName = parent['name'];
                          String childName = child['name'];

                          print("discount $discount");

                          if (price.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Enter base price")),
                            );
                            return;
                          }

                          double finalPrice = double.parse(price);
                          if (discount.isNotEmpty) {
                            double discountVal = double.parse(discount);
                            if (discountType == 'Percentage') {
                              finalPrice =
                                  finalPrice - (finalPrice * discountVal / 100);
                            } else {
                              finalPrice -= discountVal;
                            }
                            if (finalPrice < 0) finalPrice = 0;
                          }
                          addServiceProvider.addService(
                            parent: parentName,
                            child: childName,
                            price: price,
                            discount: discount,
                            discountType: discountType,
                            finalPrice: finalPrice.toStringAsFixed(2),
                            serviceType: selectedServiceType,
                            serviceId: child['_id'],
                          );
                          Navigator.pop(context); // close bottom sheet
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          "+ Add",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

InputDecoration dropdownDecoration(String lable) {
  return InputDecoration(
    label: TextWidget(text: lable),
    border: OutlineInputBorder(),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  );
}
