import 'package:fluffy/modules/auth/helper/business_hours_helper.dart';
import 'package:fluffy/modules/auth/register_business_screens/model/business_hours_model.dart';
import 'package:fluffy/modules/repositorey/common_api_repo.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class BusinessHoursProvider extends ChangeNotifier {
  final List<String> weekDays = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday",
  ];

  List<DayHour> hours = [];

  BusinessHoursProvider() {
    // Initialize default values
    hours =
        weekDays
            .map(
              (d) => DayHour(
                day: d,
                isOpen: false,
                openTime: null,
                closeTime: null,
              ),
            )
            .toList();
  }

  // ---- Update actions ----
  void toggleOpen(int index, bool value) {
    hours[index].isOpen = value;
    notifyListeners();
  }

  void updateOpenTime(int index, String time) {
    hours[index].openTime = time;
    print("hours ${hours[index].openTime}");
    notifyListeners();
  }

  void updateCloseTime(int index, String time) {
    hours[index].closeTime = time;
    notifyListeners();
  }

  void applyStartTimeToAll(String time) {
    for (var d in hours) {
      if (d.isOpen) {
        d.openTime = time;
      }
    }
    notifyListeners();
  }

  void applyEndTimeToAll(String time) {
    for (var d in hours) {
      if (d.isOpen) {
        d.closeTime = time;
      }
    }
    notifyListeners();
  }

  // ---- API: Save Business Hours ----
  Future<bool> submitHours(
    String businessId,
     List<DayHour> hours,
  ) async {
    final body = {"businessId": businessId, "hours": hours};

    try {
      final list = await BusinessHoursFileHelper.readAll();

      final index = list.indexWhere((e) => e["businessId"] == businessId);

      final data = {
        "businessId": businessId,
        "hours": hours.map((e) => e.toJson()).toList(),
      };

       if (index == -1) {
      list.add(data);
    } else {
      list[index] = data;
    }

     await BusinessHoursFileHelper.writeAll(list);

    
    notifyListeners();

    print("✅ Business Hours saved locally");
    return true;

      // final api = ApiService(dotenv.env['API_URL']!);

      // final response = await api.post('/auth/business-hours', body);
      // print("response $response");
      // if (response.statusCode == 201 || response.statusCode == 200) {
      //   return true;
      // } else {
      //   print("API error: ${response.statusMessage}");
      //   return false;
      // }
    } catch (e) {
      print("Error saving hours: $e");
      return false;
    }
  }
}
