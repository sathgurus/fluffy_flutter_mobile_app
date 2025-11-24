import 'dart:convert';
import 'package:fluffy/modules/auth/register_business_screens/model/service_model.dart';
import 'package:fluffy/modules/repositorey/common_api_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddServiceProvider with ChangeNotifier {
  List<ServiceModel> selectedServices = [];
  bool isLoading = false;
  List<Map<String, dynamic>> finalSelectedServices = [];

  void addService(String parent, String child, String price, String discount) {
    int categoryIndex = finalSelectedServices.indexWhere(
      (item) => item['name'].toString() == parent,
    );
    if (categoryIndex != -1) {
      // ✅ Add inside existing category
      finalSelectedServices[categoryIndex]['services'].add({
        "name": child,
        "price": price,
      });
    } else {
      // ✅ Create new category
      finalSelectedServices.add({
        "name": parent,
        "services": [
          {"name": child, "price": price, discount: discount},
        ],
      });
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

  Future<bool> submitServices(
    String businessOwnerId,
    List<Map<String, dynamic>> finalSelectedServices,
  ) async {
    

    isLoading = true;
    notifyListeners();

    try {
      final api = ApiService(dotenv.env['API_URL']!);
      var data = {
        "businessOwnerId": businessOwnerId,
        "services": finalSelectedServices,
      };
      final response = await api.post('/service/add', data);
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
