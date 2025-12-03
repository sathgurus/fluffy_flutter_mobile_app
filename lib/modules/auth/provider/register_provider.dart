import 'dart:convert';
import 'dart:io';

import 'package:fluffy/modules/auth/helper/file_helper.dart';
import 'package:fluffy/modules/auth/model/business_user_file_model.dart';
import 'package:fluffy/modules/auth/model/business_user_model.dart';
import 'package:fluffy/modules/repositorey/common_api_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterProvider with ChangeNotifier {
  bool isLoading = false;

  String _otp = '';

  Map<String, dynamic>? _userDetails;

  String get otp => _otp;

  void setOtp(String value) {
    _otp = value;
    notifyListeners();
  }

  void clearOtp() {
    _otp = "";
    notifyListeners();
  }

  void appendOtp(String value) {
    if (_otp.length < 5) {
      // Assuming 5-digit OTP
      _otp += value;
      notifyListeners();
    }
  }

  void removeLastOtp() {
    if (_otp.isNotEmpty) {
      _otp = _otp.substring(0, _otp.length - 1);
      notifyListeners();
    }
  }

  Future<void> saveUserData(
    String userId, {
    String? token,
    Map<String, dynamic>? userDetails,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    if (token != null) await prefs.setString('token', token);
    if (userDetails != null) {
      await prefs.setString('userDetails', jsonEncode(userDetails));
    }
  }

  static Future<List<BusinessUserFileModel>> getAllUsers() async {
    final file = await FileHelper.getFile("users.json");

    if (!await file.exists()) {
      return [];
    }

    final content = await file.readAsString();
    if (content.isEmpty) return [];

    final List decoded = jsonDecode(content);
    return decoded.map((e) => BusinessUserFileModel.fromJson(e)).toList();
  }

  String generateBusinessId(List<BusinessUserFileModel> users) {
    int id = users.length + 1;
    return "BUS${id.toString().padLeft(4, '0')}";
  }

  Future<bool> register(BusinessUserFileModel data) async {
    try {
      isLoading = true;
      notifyListeners();

      List<Map<String, dynamic>> rawData = await FileHelper.readJson(
        "users.json",
      );
      List<BusinessUserFileModel> users =
          rawData.map((e) => BusinessUserFileModel.fromJson(e)).toList();

      bool exists = users.any((u) => u.businessPhone == data.businessPhone);
      if (exists) {
        isLoading = false;
        notifyListeners();
        return false;
      }
      data.businessId = generateBusinessId(users);
      users.add(data);
      final jsonData = users.map((e) => e.toJson()).toList();
      await FileHelper.writeJson("users.json", jsonData);

      // final api = ApiService(dotenv.env['API_URL']!);

      // final res = await api.post('/auth/register', data.toJson());

      isLoading = false;
      notifyListeners();
      print("✅ User registered in file");
      print("response : $users");
      // if (res.statusCode == 201) {
      // await saveUserData(res.data['userId']);
      //await saveUserData(data.businessId!);
      return true;
      // } else {
      //   return false;
      // }
    } catch (e) {
      print("error $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOtp(String? userId) async {
    if (userId == null || _otp.isEmpty) {
      debugPrint("⚠️ Missing userId or OTP");
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      List<BusinessUserFileModel> users = await getAllUsers();

      final index = users.indexWhere((u) => u.businessId == userId);

      if (index == -1) {
        debugPrint("❌ User not found in file");
        return false;
      }

      // ✅ Update values
      users[index].otpVerified = true;
      users[index].isUserRegister = true;

      // ✅ Save back to file

      final jsonData = users.map((e) => e.toJson()).toList();
      await FileHelper.writeJson("users.json", jsonData);

      debugPrint("✅ User updated successfully in local file");
      // final api = ApiService(dotenv.env['API_URL']!);
      // final response = await api.post('/auth/verify-otp', {
      //   'userId': userId,
      //   'otp': _otp,
      // });

      isLoading = false;
      notifyListeners();

      return true;

      // debugPrint("📨 Verify OTP Response: ${response.data}");

      // if (response.statusCode == 200) {
      //   _userDetails =
      //       response.data['user']; // assuming API returns a `user` object
      //   final userId = response.data['user']['id'];
      //   var token = response.data['token'];
      //   await saveUserData(userId!, token: token, userDetails: _userDetails);

      //   notifyListeners();
      //   debugPrint('✅ OTP verified successfully');
      //   return true;
      // } else {
      //   debugPrint('❌ OTP verification failed: ${response.data}');
      //   return false;
      // }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('🚨 OTP Verify Error: $e');
      return false;
    }
  }


}
