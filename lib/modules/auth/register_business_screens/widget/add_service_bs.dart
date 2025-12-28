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

  bool isWeekdayEnabled = true;
  bool isWeekendEnabled = false;

  final weekdayPriceCtrl = TextEditingController();
  final weekendPriceCtrl = TextEditingController();

  final weekdayDiscountCtrl = TextEditingController();
  final weekendDiscountCtrl = TextEditingController();

  String weekdayDiscountType = "Percentage";
  String weekendDiscountType = "Percentage";

  List<String> discountTypes = ['Percentage', 'Amount'];

  /// ---------------- EDIT MODE PREFILL ----------------
  if (isEdit && item != null) {
    parentId = item['parentId'];
    childId = item['_id'];

    isWeekdayEnabled =
        double.tryParse(item['weekdayPrice']?.toString() ?? '0')! > 0;
    isWeekendEnabled =
        double.tryParse(item['weekendPrice']?.toString() ?? '0')! > 0;

    weekdayPriceCtrl.text = item['weekdayPrice']?.toString() ?? '';
    weekendPriceCtrl.text = item['weekendPrice']?.toString() ?? '';

    weekdayDiscountCtrl.text = item['weekdayDiscount']?.toString() ?? '0';
    weekendDiscountCtrl.text = item['weekendDiscount']?.toString() ?? '0';

    weekdayDiscountType = item['weekdayDiscountType'] ?? "Percentage";
    weekendDiscountType = item['weekendDiscountType'] ?? "Percentage";
  }

  /// ---------------------------------------------------

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

          double applyDiscount({
            required double price,
            required double discount,
            required String type,
          }) {
            if (discount <= 0) return price;

            if (type == "Percentage") {
              if (discount > 99) throw "Percentage must be ≤ 99";
              return price - (price * discount / 100);
            } else {
              if (discount >= price) throw "Discount must be less than price";
              return price - discount;
            }
          }

          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isEdit ? "Edit Service" : "Add Service",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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
                      value: parentId,
                      decoration: _decoration("Select Category"),
                      items:
                          parentList
                              .map<DropdownMenuItem<String>>(
                                (cat) => DropdownMenuItem(
                                  value: cat['_id'],
                                  child: Text(cat['name']),
                                ),
                              )
                              .toList(),
                      onChanged: (v) {
                        setState(() {
                          parentId = v;
                          childId = null;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    /// SERVICE
                    DropdownButtonFormField<String>(
                      value: childId,
                      decoration: _decoration("Select Service"),
                      items:
                          (childList as List)
                              .map<DropdownMenuItem<String>>(
                                (srv) => DropdownMenuItem(
                                  value: srv['_id'],
                                  child: Text(srv['name']),
                                ),
                              )
                              .toList(),
                      onChanged: (v) => setState(() => childId = v),
                    ),

                    const SizedBox(height: 16),

                    /// WEEKDAY
                    CheckboxListTile(
                      value: isWeekdayEnabled,
                      onChanged: (v) => setState(() => isWeekdayEnabled = v!),
                      title: const Text("Weekday"),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),

                    if (isWeekdayEnabled) ...[
                      TextField(
                        controller: weekdayPriceCtrl,
                        keyboardType: TextInputType.number,
                        decoration: _decoration("Weekday Price"),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: weekdayDiscountCtrl,
                              keyboardType: TextInputType.number,
                              decoration: _decoration("Weekday Discount"),
                            ),
                          ),
                          const SizedBox(width: 8),
                          DropdownButton<String>(
                            value: weekdayDiscountType,
                            onChanged:
                                (v) => setState(() => weekdayDiscountType = v!),
                            items:
                                discountTypes
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 16),

                    /// WEEKEND
                    CheckboxListTile(
                      value: isWeekendEnabled,
                      onChanged: (v) => setState(() => isWeekendEnabled = v!),
                      title: const Text("Weekend"),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),

                    if (isWeekendEnabled) ...[
                      TextField(
                        controller: weekendPriceCtrl,
                        keyboardType: TextInputType.number,
                        decoration: _decoration("Weekend Price"),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: weekendDiscountCtrl,
                              keyboardType: TextInputType.number,
                              decoration: _decoration("Weekend Discount"),
                            ),
                          ),
                          const SizedBox(width: 8),
                          DropdownButton<String>(
                            value: weekendDiscountType,
                            onChanged:
                                (v) => setState(() => weekendDiscountType = v!),
                            items:
                                discountTypes
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 24),

                    /// SAVE
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (parentId == null || childId == null) {
                            ToastificationShowError.showToast(
                              context: context,
                              description: "Select category and service",
                            );
                            return;
                          }

                          if (!isWeekdayEnabled && !isWeekendEnabled) {
                            ToastificationShowError.showToast(
                              context: context,
                              description: "Select at least one service type",
                            );
                            return;
                          }

                          try {
                            final parent = parentList.firstWhere(
                              (p) => p['_id'] == parentId,
                            );
                            final child = childList.firstWhere(
                              (c) => c['_id'] == childId,
                            );

                            addServiceProvider.addOrUpdateService(
                              parent: parent['name'],
                              child: child['name'],
                              serviceId: child['_id'],
                              parentId: parentId,
                              weekdayPrice: weekdayPriceCtrl.text,
                              weekendPrice: weekendPriceCtrl.text,
                              finalWeekdayPrice:
                                  isWeekdayEnabled
                                      ? applyDiscount(
                                        price: double.parse(
                                          weekdayPriceCtrl.text,
                                        ),
                                        discount:
                                            double.tryParse(
                                              weekdayDiscountCtrl.text,
                                            ) ??
                                            0,
                                        type: weekdayDiscountType,
                                      ).toStringAsFixed(2)
                                      : "0",
                              finalWeekendPrice:
                                  isWeekendEnabled
                                      ? applyDiscount(
                                        price: double.parse(
                                          weekendPriceCtrl.text,
                                        ),
                                        discount:
                                            double.tryParse(
                                              weekendDiscountCtrl.text,
                                            ) ??
                                            0,
                                        type: weekendDiscountType,
                                      ).toStringAsFixed(2)
                                      : "0",
                              weekdayDiscount: weekdayDiscountCtrl.text,
                              weekendDiscount: weekendDiscountCtrl.text,
                              weekdayDiscountType: weekdayDiscountType,
                              weekendDiscountType: weekendDiscountType,
                            );

                            Navigator.pop(context);
                          } catch (e) {
                            ToastificationShowError.showToast(
                              context: context,
                              description: e.toString(),
                            );
                          }
                        },
                      ),
                    ),
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
