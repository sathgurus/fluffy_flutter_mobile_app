import 'package:fluffy/modules/auth/register_business_screens/provider/Add_service_provider.dart';
import 'package:fluffy/modules/service/provider/service_provider.dart';
import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/shared/constant.dart';
import 'package:fluffy/modules/shared/text_widget.dart';
import 'package:fluffy/modules/shared/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void openAddServiceBottomSheet(
  BuildContext context, {
  bool isEdit = false,
  Map<String, dynamic>? item,
}) {
  final sp = Provider.of<ServiceProvider>(context, listen: false);
  final addServiceProvider = Provider.of<AddServiceProvider>(
    context,
    listen: false,
  );

  String? parentId;
  String? childId;

  final TextEditingController priceCtrl = TextEditingController();
  final TextEditingController discountCtrl = TextEditingController();

  String discountType = "Percentage";
  List<String> taxOptions = ['Percentage', 'Amount'];
  String selectedServiceType = "weekday";

  if (isEdit) {
    print("item show $item");
    parentId = item!['parentId'];
    childId = item['_id'];
    discountType = item['discountType'];
    priceCtrl.text = item['basePrice'];
    discountCtrl.text = item['discount'];
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
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
              child: Padding(
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
                          child: Text(
                            isEdit ? "Add Service" : "Edit Service",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close),
                        ),
                      ],
                    ),

                    const Divider(),

                    /// CATEGORY
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: parentId,
                      decoration: _decoration("Select Category"),
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
                    ),

                    const SizedBox(height: 16),

                    /// SERVICE
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: childId,
                      decoration: _decoration("Select Service"),
                      items:
                          (childList as List).map<DropdownMenuItem<String>>((
                            srv,
                          ) {
                            return DropdownMenuItem(
                              value: srv["_id"],
                              child: Text(srv["name"]),
                            );
                          }).toList(),
                      onChanged: (val) => setState(() => childId = val),
                    ),

                    const SizedBox(height: 16),

                    /// SERVICE TYPE
                    const Text("Service Type"),
                    Row(
                      children: [
                        Radio(
                          value: "weekday",
                          groupValue: selectedServiceType,
                          activeColor: AppColors.primary,
                          onChanged:
                              (v) => setState(
                                () => selectedServiceType = v.toString(),
                              ),
                        ),
                        const Text("Weekday"),
                        Radio(
                          value: "weekend",
                          groupValue: selectedServiceType,
                          activeColor: AppColors.primary,
                          onChanged:
                              (v) => setState(
                                () => selectedServiceType = v.toString(),
                              ),
                        ),
                        const Text("Weekend"),
                      ],
                    ),

                    /// PRICE
                    TextField(
                      controller: priceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: _decoration("Base Price"),
                    ),

                    const SizedBox(height: 16),

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
                          // height: 10,
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

                    /// ADD BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          /// VALIDATIONS
                          if (parentId == null || childId == null) {
                            ToastificationShowError.showToast(
                              context: context,
                              description: "Select category and service",
                            );
                            return;
                          }

                          if (priceCtrl.text.isEmpty) {
                            ToastificationShowError.showToast(
                              context: context,
                              description: "Enter base price",
                            );
                            return;
                          }

                          final basePrice =
                              double.tryParse(priceCtrl.text) ?? 0;

                          if (basePrice <= 0) {
                            ToastificationShowError.showToast(
                              context: context,
                              description: "Price must be greater than 0",
                            );
                            return;
                          }

                          double finalPrice = basePrice;

                          if (discountCtrl.text.isNotEmpty) {
                            final discount =
                                double.tryParse(discountCtrl.text) ?? 0;

                            if (discountType == "Percentage") {
                              if (discount > 99) {
                                ToastificationShowError.showToast(
                                  context: context,
                                  description:
                                      "Percentage discount must be 99 or less",
                                );
                                return;
                              }
                              finalPrice =
                                  basePrice - (basePrice * discount / 100);
                            } else {
                              if (discount >= basePrice) {
                                ToastificationShowError.showToast(
                                  context: context,
                                  description:
                                      "Discount amount must be less than price",
                                );
                                return;
                              }
                              finalPrice = basePrice - discount;
                            }
                          }

                          final parent = parentList.firstWhere(
                            (p) => p['_id'] == parentId,
                          );
                          final child = childList.firstWhere(
                            (c) => c['_id'] == childId,
                          );

                          addServiceProvider.addOrUpdateService(
                            parent: parent['name'],
                            child: child['name'],
                            price: basePrice.toString(),
                            discount: discountCtrl.text,
                            discountType: discountType,
                            finalPrice: finalPrice.toStringAsFixed(2),
                            serviceType: selectedServiceType,
                            serviceId: child['_id'],
                            parentId: parentId,
                          );

                          Navigator.pop(context);
                        },
                        child: const Text(
                          "+ Add",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
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

/// INPUT DECORATION
InputDecoration _decoration(String label) {
  return InputDecoration(
    labelText: label,
    border: const OutlineInputBorder(),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  );
}
