import 'package:fluffy/modules/repositorey/common_api_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ServiceProvider with ChangeNotifier {
  bool _isLoading = false;

  List services = [];

  List ownerByServices = [];

  bool get isLoading => _isLoading;

  Future<bool> fetchAllServices() async {
    notifyListeners();

    try {
      final api = ApiService(dotenv.env['API_URL']!);

      final response = await api.getAll('/services/all');

      _isLoading = false;
      notifyListeners();

      //debugPrint("response $response");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // debugPrint('✅ service data: ${response.data}');
        services = response.data['services'];
        return true;
      } else {
        debugPrint('❌ data fetch Failed: ${response.data}');
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('🚨 Login Error: $e');
      return false;
    }
  }

  Future<bool> fetchAllServicesByOwner(String businessId) async {
    try {
      final api = ApiService(dotenv.env['API_URL']!);
      final response = await api.getAll('/services/owner-services/$businessId');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map && data.containsKey('services')) {
          ownerByServices = List<Map<String, dynamic>>.from(data['services']);
          notifyListeners();
          debugPrint('✅ ownerByServices: $ownerByServices');
          return true;
        } else {
          debugPrint('❌ Unexpected response format: $data');
          return false;
        }
      } else {
        debugPrint('❌ fetchAllServicesByOwner failed: ${response.data}');
        return false;
      }
    } catch (e) {
      notifyListeners();
      debugPrint('🚨 fetchAllServicesByOwner error: $e');
      return false;
    }
  }
}
