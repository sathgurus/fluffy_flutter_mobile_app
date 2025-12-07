import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluffy/modules/repositorey/common_api_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  String _phone = '';
  String _password = '';
  Map<String, dynamic>? _userDetails;
  bool _isLoading = false;
  String? _userId;
  String? _token;
  Map<String, dynamic>? _userVerify;

  String get phone => _phone;
  String get password => _password;
  Map<String, dynamic>? get userDetails => _userDetails;
  bool get isLoading => _isLoading;
  String? get userId => _userId;
  String? get token => _token;
  Map<String, dynamic>? get userVerify => _userVerify;

  Future<void> saveUserData(
    String userId, {
    String? token,
    Map<String, dynamic>? userDetails,
    Map<String, dynamic>? userVerify,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    if (token != null) await prefs.setString('token', token);
    if (userDetails != null) {
      await prefs.setString('userDetails', jsonEncode(userDetails));
    }
    if(userVerify != null){
      await prefs.setString('userVerify', jsonEncode(userVerify));
    }
  }

  // Load user ID and token
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId');
    _token = prefs.getString('token');
   

    final userJson = prefs.getString('userDetails');
    if (userJson != null) {
      _userDetails = jsonDecode(userJson);
    }
     final userVerifyJson = prefs.getString('userVerify');
    if (userVerifyJson != null) {
      _userVerify = jsonDecode(userVerifyJson);
    }

    notifyListeners();
  }

  void setPhone(String value) {
    _phone = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void resetLoading() {
    _isLoading = false;
    notifyListeners();
  }

  // Future<bool> resetPassword(
  //   String phone,
  //   String password,
  //   String confirmPassword,
  // ) async {
  //   try {
  //     _isLoading = true;
  //     notifyListeners();
  //     final dir = await getApplicationDocumentsDirectory();
  //     final file = File('${dir.path}/users.json');

  //     if (!await file.exists()) {
  //       return false;
  //     }

  //     final data = jsonDecode(await file.readAsString());
  //     bool found = false;

  //     for (var user in data) {
  //       if (user['phone'] == phone) {
  //         user['password'] = password;
  //         found = true;
  //         break;
  //       }
  //     }

  //     if (!found) {
  //       return false;
  //     }

  //     await file.writeAsString(jsonEncode(data));
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<dynamic> login(String role) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Create instance of ApiService
      final api = ApiService(dotenv.env['API_URL']!);

      // API call
      final response = await api.post('/auth/login', {
        'businessPhone': _phone,
        'password': _password,
        'role': role,
      });

      _isLoading = false;
      notifyListeners();

      print("response ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        _userDetails =
            response.data['user']; // assuming API returns a `user` object
        _token = response.data['token'];
        await saveUserData(
          _userDetails?['id'],
          token: _token,
          userDetails: _userDetails,
        );
        print('✅ Login Successful: ${response.data}');
        return {"success": true, "isVerified": true, "data": response.data};
      } else {
        print('❌ Login Failed: ${response.data}');
        _userVerify = response.data['user'];
        await saveUserData(_userVerify?['id'], userVerify: _userVerify);
        return response.data;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('🚨 Login Error: $e');

      return {
        "success": false,
        "isVerified": false,
        "message": "Something went wrong",
      };
    }
  }
}
