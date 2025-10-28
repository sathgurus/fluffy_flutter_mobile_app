import 'dart:convert';

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

  String get phone => _phone;
  String get password => _password;
  Map<String, dynamic>? get userDetails => _userDetails;
  bool get isLoading => _isLoading;
  String? get userId => _userId;
  String? get token => _token;

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

  // Load user ID and token
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId');
    _token = prefs.getString('token');

    final userJson = prefs.getString('userDetails');
    if (userJson != null) {
      _userDetails = jsonDecode(userJson);
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

  Future<bool> login() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Create instance of ApiService
      final api = ApiService(dotenv.env['API_URL']!);

      // API call
      final response = await api.post('/login', {
        'phone': _phone,
        'password': _password,
        'role': "business_owner",
      });

      _isLoading = false;
      notifyListeners();

      debugPrint("response $response");

      if (response.statusCode == 200 || response.statusCode == 201) {
        _userDetails =
            response.data['user']; // assuming API returns a `user` object
        _token = response.data['token'];
        await saveUserData(
          _userDetails?['id'],
          token: _token,
          userDetails: _userDetails,
        );
        debugPrint('✅ Login Successful: ${response.data}');
        return true;
      } else {
        debugPrint('❌ Login Failed: ${response.data}');
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('🚨 Login Error: $e');
      return false;
    }
  }
}
