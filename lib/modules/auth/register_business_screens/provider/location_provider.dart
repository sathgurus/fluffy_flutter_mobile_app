import 'dart:convert';
import 'package:fluffy/modules/auth/helper/location_helper.dart';
import 'package:fluffy/modules/auth/model/location_file_model.dart';
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
      final list = await LocationFileHelper.readAll();

      final index = list.indexWhere(
        (e) => e["businessId"] == data.businessId,
      );

      final localData = data.toJson();

      if (index == -1) {
        list.add(localData);
      } else {
        list[index] = localData; // overwrite
      }

      await LocationFileHelper.writeAll(list);

      _location = data;
      _loading = false;
      notifyListeners();

      print("✅ Location saved locally");
      return true;
      //  final api = ApiService(dotenv.env['API_URL']!);

      // final response = await api.post('/auth/ping-location', data.toJson());

      // final responseData = response;
      // print("response data location $responseData");

      // if (response.statusCode == 200) {
      //   return true;
      // } else {
      //   return false;
      // }
    } catch (e) {
      print("Location update error: $e");
      return false;
    }

    _loading = false;
    notifyListeners();
  }
}
