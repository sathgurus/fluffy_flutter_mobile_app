import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluffy/modules/repositorey/common_api_repo.dart';
import '../model/business_model.dart';

class BusinessProvider with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  String? _businessId;
  String? get businessId => _businessId;

  Future<bool> addBusiness(BusinessModel data) async {
    _loading = true;
    notifyListeners();

    try {
      final api = ApiService(dotenv.env['API_URL']!);

      print("📤 Sending Business Data: ${data.toJson()}");

      final response =
          await api.post('/business/add', data.toJson());

      print("✅ API Response: $response");

       if (response.data['businessId'] != null) {
      _businessId = response.data['businessId'];
      _loading = false;
      notifyListeners();  // UI refresh
      
      return true;
    }
    } catch (e) {
      print("❌ Error adding business: $e");
    }

    _loading = false;
    notifyListeners();
    return false;
  }
}
