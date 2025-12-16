import 'dart:convert';
import 'package:fluffy/modules/auth/register_business_screens/model/location_model.dart';
import 'package:fluffy/modules/repositorey/common_api_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationProvider with ChangeNotifier {
  LocationModel? _location;
  bool _loading = false;

  bool get loading => _loading;
  LocationModel? get location => _location;

  Future<bool> updateLocation(LocationModel data) async {
    _loading = true;
    notifyListeners();

    try {
      final api = ApiService(dotenv.env['API_URL']!);

      final response = await api.post('/auth/ping-location', data.toJson());

      final responseData = response;
      print("response data location $responseData");

      if (response.statusCode == 200) {
        _loading = false;
        notifyListeners();
        return true;
      } else {
        _loading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("Location update error: $e");
      _loading = false;
      notifyListeners();
      return false;
    }
  }
}
