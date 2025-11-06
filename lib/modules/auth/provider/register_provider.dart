import 'dart:convert';

import 'package:fluffy/modules/repositorey/common_api_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterProvider with ChangeNotifier {
  String _name = '';
  String _phone = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _role = '';
  String _otp = '';
  String? _userId;
  String? _token;
  bool _isLoading = false;
  bool _isRegistered = false;
  bool _isOtpVerified = false;
  Map<String, dynamic>? _userDetails;

  // Getters
  String get name => _name;
  String get phone => _phone;
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  String get role => _role;
  String get otp => _otp;
  String? get userId => _userId;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isRegistered => _isRegistered;
  bool get isOtpVerified => _isOtpVerified;
  Map<String, dynamic>? get userDetails => _userDetails;

  // Setters

  void setRole(String value) {
    _role = value;
    notifyListeners();
  }

  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setPhone(String value) {
    _phone = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

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

  Future<bool> register(String registerType) async {
    if (_password != _confirmPassword) {
      debugPrint("Passwords do not match");
      return false;
    }

    print("called $registerType");

    _isLoading = true;
    notifyListeners();

    try {
      // Create instance of ApiService
      final api = ApiService(dotenv.env['API_URL']!);

      // API call
      final response = await api.post('/register', {
        'name': _name,
        'phone': _phone,
        'email': _email,
        'password': _password,
        'confirmPassword': _confirmPassword,
        'role': registerType,
        'termsAccepted': true,
      });

      _isLoading = false;
      notifyListeners();

      debugPrint("response $response");

      if (response.statusCode == 200 || response.statusCode == 201) {
        _userDetails =
            response.data['user']; // assuming API returns a `user` object
        _token = response.data['token'];
        _isRegistered = true;
        await saveUserData(
          _userDetails?['id'],
          token: _token,
          userDetails: _userDetails,
        );
        debugPrint('✅ Registration Successful: ${response.data}');
        return true;
      } else {
        debugPrint('❌ Registration Failed: ${response.data}');
        return false;
      }
    } catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
      debugPrint('🚨 Register Error: $e');
      return false;
    }
  }

  Future<bool> verifyOtp() async {
    if (_userId == null || _otp.isEmpty) {
      debugPrint("⚠️ Missing userId or OTP");
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final api = ApiService(dotenv.env['API_URL']!);
      final response = await api.post('/verify-otp', {
        'userId': _userId,
        'otp': _otp,
      });

      _isLoading = false;
      notifyListeners();

      debugPrint("📨 Verify OTP Response: ${response.data}");

      if (response.statusCode == 200) {
        _isOtpVerified = true;
        _userDetails =
            response.data['user']; // assuming API returns a `user` object
        _token = response.data['token'];
        // await saveUserData(_userId!, token: _token, userDetails: _userDetails);

        notifyListeners();
        debugPrint('✅ OTP verified successfully');
        return true;
      } else {
        debugPrint('❌ OTP verification failed: ${response.data}');
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('🚨 OTP Verify Error: $e');
      return false;
    }
  }

  // 🧹 Reset all state (optional)
  void reset() {
    _name = '';
    _phone = '';
    _email = '';
    _password = '';
    _confirmPassword = '';
    _role = '';
    _otp = '';
    _userId = null;
    _isRegistered = false;
    _isOtpVerified = false;
    notifyListeners();
  }
}
