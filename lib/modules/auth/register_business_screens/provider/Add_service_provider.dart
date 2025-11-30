import 'dart:convert';
import 'package:fluffy/modules/auth/helper/service_helper.dart';
import 'package:fluffy/modules/auth/register_business_screens/model/service_model.dart';
import 'package:fluffy/modules/repositorey/common_api_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddServiceProvider with ChangeNotifier {
  List<Map<String, dynamic>> selectedServices = [];
  bool isLoading = false;
  List<Map<String, dynamic>> finalSelectedServices = [];
  String? userId;

  void addService({
    required String parentId,
    required String parent, // category name
    required String child, // service name
    required String price, // base price
    String? discount, // optional
    String discountType = "", // % or ₹
    required String finalPrice, // final calculated price
    required String serviceType, // weekday/weekend
    required String serviceId,
  }) {
    int categoryIndex = finalSelectedServices.indexWhere(
      (item) => item['name'].toString() == parent,
    );

    // Build service object
    Map<String, dynamic> serviceObject = {
      "id": serviceId,
      "name": child,
      "price": price,
      "serviceType": serviceType,
    };

    print("service object $serviceObject");

    // Add discount ONLY if user entered a value
    if (discount != null && discount.trim().isNotEmpty) {
      serviceObject["discount"] = discount;
    }

    if (categoryIndex != -1) {
      // Add to existing category
      finalSelectedServices[categoryIndex]["services"].add(serviceObject);
    } else {
      // Create new category
      finalSelectedServices.add({
        "id": parentId,
        "name": parent,
        "services": [serviceObject],
      });
    }
    selectedServices.add({
      "_id": serviceId,
      "category": parent,
      "service": child,
      "basePrice": price,
      "discount": (discount ?? "").isEmpty ? "0" : discount,
      "discountType": (discount ?? "").isEmpty ? "" : discountType,
      //"price": finalPrice,
    });

    print("finalSelectedServices $finalSelectedServices");

    notifyListeners();
  }

  void removeService(int index) {
    notifyListeners();
  }

  void resetServices() {
    finalSelectedServices.clear();
    notifyListeners();
  }

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId") ?? "6922fdcd0c379ff8f03c05e7";
    notifyListeners();
  }

  Future<bool> submitServices(String businessOwnerId) async {
    isLoading = true;
    notifyListeners();
    print("businessOwnerId $businessOwnerId");
    print("finalSelectedServices $finalSelectedServices");

    try {
      final List<Map<String, dynamic>> list = await ServiceFileHelper.readAll();

      final index = list.indexWhere(
        (e) => e["businessOwnerId"] == businessOwnerId,
      );

      final ownerData = {
      "businessOwnerId": businessOwnerId,
      "services": finalSelectedServices
    };

      if (index == -1) {
      list.add(ownerData);
    } 
     await ServiceFileHelper.writeAll(list);

    resetServices();

    isLoading = false;
    notifyListeners();

    print("✅ Services stored locally");
    return true;
      // final api = ApiService(dotenv.env['API_URL']!);

      // var data = {
      //   "businessOwnerId": businessOwnerId,
      //   "services": finalSelectedServices,
      // };

      // final response = await api.post('/services/add', data);
      // final responseData = response;
      // print("response data location $responseData");

      // isLoading = false;
      // notifyListeners();
      

      // if (response.statusCode == 201 || response.statusCode == 200) {
      //   resetServices();
      //   return true;
      // } else {
      //   print("API error: ${response.statusMessage}");
      //   return false;
      // }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print("Error submitting services: $e");
      return false;
    }
  }

  Future<List> getServicesByOwner(String ownerId) async {
  final list = await ServiceFileHelper.readAll();

  final data = list.firstWhere(
    (e) => e['businessOwnerId'] == ownerId,
    orElse: () => {},
  );

  print("data $data");

  return data['services'] ?? [];
}
}
