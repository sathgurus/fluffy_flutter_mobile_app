import 'dart:convert';
import 'package:fluffy/modules/auth/helper/category_helper.dart';
import 'package:fluffy/modules/auth/model/category_file_model.dart';
import 'package:fluffy/modules/auth/model/default_service_file_model.dart';
import 'package:flutter/services.dart';

class CategoryInitializer {
  /// Load default categories from assets and store locally if empty

  static Future<void> initDefaultCategories() async {
    final existingCategories = await CategoryFileHelper.getAllCategories();

    if (existingCategories.isNotEmpty) {
      print("✅ Categories already initialized");
      return;
    }

    // Load JSON from assets
    final jsonString = await rootBundle.loadString(
      'assets/servicesSampleData.json',
    );
    final List decoded = jsonDecode(jsonString);

    // Assign IDs
    List<CategoryModel> categories = [];

    for (int i = 0; i < decoded.length; i++) {
      final categoryJson = decoded[i];
      final categoryId = generateCategoryId(i);

      final List<DefaultServiceModel> services = [];

      for (int j = 0; j < categoryJson['services'].length; j++) {
        final service = categoryJson['services'][j];
        services.add(
          DefaultServiceModel(id: generateServiceId(j), name: service['name']),
        );
      }

      categories.add(
        CategoryModel(
          id: categoryId,
          name: categoryJson['name'],
          services: services,
        ),
      );
    }

    // Save locally
    await CategoryFileHelper.saveCategories(categories);

    print("✅ Categories and Services with IDs saved locally");
  }
}

String generateCategoryId(int index) {
  return "CAT${(index + 1).toString().padLeft(4, '0')}";
}

String generateServiceId(int serviceIndex) {
  return "SRV${(serviceIndex + 1).toString().padLeft(3, '0')}";
}
