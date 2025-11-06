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

  Future<void> updateLocation(LocationModel data) async {
    _loading = true;
    notifyListeners();

    try {
       final api = ApiService(dotenv.env['API_URL']!);

     final body = {
      "businessOwnerId": data.businessOwnerId,
      "latitude": data.latitude,
      "longitude": data.longitude,
      "address": data.address,
    };
      final response = await api.post('/location/ping', body);

      final responseData = response;
      print("response data location $responseData");

      // if (response.statusCode == 200) {
      //   _location = LocationModel.fromJson(responseData['location']);
      // } else {
      //   throw responseData.statusMessage ?? "Something went wrong";
      // }
    } catch (e) {
      print("Location update error: $e");
    }

    _loading = false;
    notifyListeners();
  }
}
