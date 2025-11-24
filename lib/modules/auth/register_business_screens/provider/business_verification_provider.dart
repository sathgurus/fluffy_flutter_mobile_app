import 'package:fluffy/modules/auth/register_business_screens/model/business_verification_model.dart';
import 'package:fluffy/modules/repositorey/common_api_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessVerificationProvider with ChangeNotifier {
  bool isLoading = false;
  BusinessVerificationModel verificationData = BusinessVerificationModel(
    shopPhotos: [null, null, null],
  );

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    verificationData.userId =
        prefs.getString("userId") ?? "6922fdcd0c379ff8f03c05e7";
    notifyListeners();
  }

  void updateTIN(String value) {
    verificationData.tinNumber = value;
    notifyListeners();
  }

  void updateGST(String value) {
    verificationData.gstNumber = value;
    notifyListeners();
  }

  void updatePAN(String value) {
    verificationData.panNumber = value;
    notifyListeners();
  }

  void updateAadhaar(String value) {
    verificationData.aadhaarNumber = value;
    notifyListeners();
  }

  void updateLogo(String url) {
    verificationData.logoUrl = url;
    notifyListeners();
  }

  void updateShopPhoto(int index, String url) {
    verificationData.shopPhotos[index] = url;
    notifyListeners();
  }

  Future<bool> businessVerify() async {
    try {
      isLoading = true;
      notifyListeners();
      final api = ApiService(dotenv.env['API_URL']!);

     // verificationData.userId = "6922fdcd0c379ff8f03c05e7";

      print("verificationData ${verificationData.toJson()}");

      final res = await api.post(
        '/auth/business-verification',
        verificationData.toJson(),
      );

      isLoading = false;
      notifyListeners();
      print("response : $res");
      if (res.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("error $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
