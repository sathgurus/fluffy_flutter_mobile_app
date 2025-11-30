import 'package:fluffy/modules/auth/helper/category_helper.dart';
import 'package:fluffy/modules/auth/model/category_file_model.dart';
import 'package:fluffy/modules/repositorey/common_api_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ServiceProvider with ChangeNotifier {
  bool _isLoading = false;

  List<CategoryModel> services = [];

  bool get isLoading => _isLoading;

  Future<bool> fetchAllServices() async {
    notifyListeners();

    try {
      // final api = ApiService(dotenv.env['API_URL']!);

      // final response = await api.getAll('/services/all');

      List<CategoryModel> response =
          await CategoryFileHelper.getAllCategories();
      _isLoading = false;
      notifyListeners();
      for (var category in response) {
        print('Category: ${category.name}');
        print('Category: ${category.id}');
        for (var service in category.services) {
          print(' - Service: ${service.name}');
          print(' - Service: ${service.id}');
        }
      }
      services = response;
      debugPrint("response $response");
      return true;
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   // debugPrint('✅ service data: ${response.data}');
      //   services = response.data['services'];
      //   return true;
      // } else {
      //   debugPrint('❌ data fetch Failed: ${response.data}');
      //   return false;
      // }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('🚨 Login Error: $e');
      return false;
    }
  }
}
