import 'dart:convert';
import 'dart:io';

import 'package:fluffy/modules/auth/helper/file_helper.dart';
import 'package:fluffy/modules/auth/model/business_user_file_model.dart';
import 'package:fluffy/modules/auth/model/shop_verify_file_model.dart';
import 'package:fluffy/modules/auth/register_business_screens/model/business_verification_model.dart';
import 'package:fluffy/modules/repositorey/common_api_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessVerificationProvider with ChangeNotifier {
  bool isLoading = false;
  // BusinessVerificationModel verificationData = BusinessVerificationModel(
  //   shopPhotos: [null, null, null],
  // );
  ShopVerificationModel verificationData = ShopVerificationModel(
    ownerId: "",
    shopPhotos: [null, null, null],
  );

  // Future<void> loadUserId() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   verificationData.userId =
  //       prefs.getString("userId") ?? "6922fdcd0c379ff8f03c05e7";
  //   notifyListeners();
  // }

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
    verificationData.aadharNumber = value;
    notifyListeners();
  }

  void updateLogo(String url) {
    verificationData.shopLogo = url;
    notifyListeners();
  }

  void updateShopPhoto(int index, String url) {
    verificationData.shopPhotos![index] = url;
    notifyListeners();
  }

  
  String generateBusinessId(List<ShopVerificationModel> data) {
    int id = data.length + 1;
    return id.toString();
  }


  Future<void> saveVerificationToFile() async {
    final file = await FileHelper.getFile("shop_verifications.json");

    List<ShopVerificationModel> list = [];

    if (await file.exists()) {
      final data = await file.readAsString();
      if (data.isNotEmpty) {
        final decoded = jsonDecode(data);
        list =
            (decoded as List)
                .map((e) => ShopVerificationModel.fromJson(e))
                .toList();
      }
    }

    // ✅ assign ownerId
    verificationData.id = generateBusinessId(list);
    verificationData.ownerId = verificationData.ownerId;

    // ✅ Update if exists
    final index = list.indexWhere((v) => v.ownerId == verificationData.ownerId);

    if (index == -1) {
      list.add(verificationData); // New
    } else {
      list[index] = verificationData; // Update
    }
    List<Map<String, dynamic>> rawData = await FileHelper.readJson(
      "users.json",
    );
    List<BusinessUserFileModel> users =
        rawData.map((e) => BusinessUserFileModel.fromJson(e)).toList();

    final userIndex = users.indexWhere(
      (u) => u.businessId == verificationData.ownerId,
    );

    // ✅ Update values

    users[userIndex].isAddPersonal = true;
    users[userIndex].shopVerification = verificationData.id;

    // ✅ Write back to file
    await file.writeAsString(jsonEncode(list.map((e) => e.toJson()).toList()));

    debugPrint("✅ Business verification stored locally");
  }

  Future<bool> businessVerify(String? userId) async {
    try {
      isLoading = true;
      notifyListeners();

      verificationData.ownerId = userId!;

      await saveVerificationToFile();

      isLoading = false;
      notifyListeners();
      return true;

      // final api = ApiService(dotenv.env['API_URL']!);

      // verificationData.userId = userId;

      // print("verificationData ${verificationData.toJson()}");

      // final res = await api.post(
      //   '/auth/business-verification',
      //   verificationData.toJson(),
      // );

      // isLoading = false;
      // notifyListeners();
      // print("response : $res");
      // if (res.statusCode == 201) {
      //   return true;
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
}
