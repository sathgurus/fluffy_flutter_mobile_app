import 'dart:convert';
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

  void addOrUpdateService({
    required String parent, // category name
    required String child, // service name
    required String price, // base price
    String? discount,
    String discountType = "",
    required String finalPrice,
    required String serviceType,
    required String serviceId,
    String? parentId,
  }) {
    /// 🔍 Find service index (EDIT MODE)
    int serviceIndex = selectedServices.indexWhere(
      (item) => item['_id'] == serviceId,
    );

    Map<String, dynamic> serviceData = {
      "_id": serviceId,
      "parentId": parentId,
      "category": parent,
      "service": child,
      "basePrice": price,
      "discount": (discount ?? "").isEmpty ? "0" : discount,
      "discountType": (discount ?? "").isEmpty ? "" : discountType,
      "price": finalPrice,
      "serviceType": serviceType,
    };

    if (serviceIndex != -1) {
      selectedServices[serviceIndex] = serviceData;
    } else {
      selectedServices.add(serviceData);
    }

    int categoryIndex = finalSelectedServices.indexWhere(
      (item) => item['name'] == parent,
    );

    Map<String, dynamic> childService = {
      "serviceId": serviceId,
      "name": child,
      "finalPrice": finalPrice,
      "price": price,
      "discount": discount ?? "0",
      "discountType": discountType,
      "serviceType": serviceType,
    };

    if (categoryIndex != -1) {
      int childIndex = finalSelectedServices[categoryIndex]["services"]
          .indexWhere((s) => s["serviceId"] == serviceId);

      if (childIndex != -1) {
        /// UPDATE CHILD
        finalSelectedServices[categoryIndex]["services"][childIndex] =
            childService;
      } else {
        /// ADD CHILD
        finalSelectedServices[categoryIndex]["services"].add(childService);
      }
    } else {
      /// CREATE NEW CATEGORY
      finalSelectedServices.add({
        "name": parent,
        "services": [childService],
      });
    }

    notifyListeners();
  }

  void deleteService(String serviceId) {
    selectedServices.removeWhere((item) => item['_id'] == serviceId);

    for (int i = finalSelectedServices.length - 1; i >= 0; i--) {
      final category = finalSelectedServices[i];

      category['services'].removeWhere(
        (service) => service['serviceId'] == serviceId,
      );

      if (category['services'].isEmpty) {
        finalSelectedServices.removeAt(i);
      }
    }

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

    try {
      final api = ApiService(dotenv.env['API_URL']!);

      var data = {
        "businessOwnerId": businessOwnerId,
        "services": finalSelectedServices,
      };
      print("finalSelectedServices $finalSelectedServices");
      final response = await api.post('/services/add', data);
      final responseData = response;
      print("response data location $responseData");

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 201 || response.statusCode == 200) {
        resetServices();
        return true;
      } else {
        print("API error: ${response.statusMessage}");
        return false;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print("Error submitting services: $e");
      return false;
    }
  }
}
