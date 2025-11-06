import 'package:fluffy/modules/repositorey/common_api_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Profileprovider with ChangeNotifier {


   Future<bool> fetchProfile() async {
    //_loading = true;
    notifyListeners();

    try {
      final api = ApiService(dotenv.env['API_URL']!);

      

      // final response =
      //     await api.getById('/business/add');

     // print("✅ API Response: $response");

      // if (response["businessId"] != null) {
      //   _businessId = response["businessId"];
      //   _loading = false;
      //   notifyListeners();
      //   return true;
      // }
    } catch (e) {
      print("❌ Error adding business: $e");
    }

    //_loading = false;
    notifyListeners();
    return false;
  }
}