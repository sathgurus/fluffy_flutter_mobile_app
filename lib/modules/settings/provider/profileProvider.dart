import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluffy/modules/repositorey/common_api_repo.dart';

class Profileprovider with ChangeNotifier {
  bool isLoading = false;

  /// Only required shop verification fields
  Map<String, dynamic> shopVerification = {};
  Map<String, dynamic> locationData = {};

  String? errorMessage;

  Future<void> fetchBusinessDetails(String businessId) async {
    try {
      isLoading = true;
      notifyListeners();

      final api = ApiService(dotenv.env['API_URL']!);
      final response = await api.getAll('/auth/get-shop-details/$businessId');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        //print("data $data");
        final shopData = data['shopVerification'];

        shopVerification = {
          "aadharNumber": shopData['aadharNumber'],
          "panNumber": shopData['panNumber'],
          "gstNumber": shopData['gstNumber'],
          "tinNumber": shopData['tinNumber'],
        };
        locationData = data['businessLocation'];

        errorMessage = null;
      } else {
        errorMessage = response.statusMessage;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
