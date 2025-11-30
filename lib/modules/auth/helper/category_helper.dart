import 'dart:io';
import 'dart:convert';
import 'package:fluffy/modules/auth/model/category_file_model.dart';
import 'package:path_provider/path_provider.dart';


class CategoryFileHelper {
  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/categories.json');
  }

  static Future getAllCategories() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return [];

      final content = await file.readAsString();
      if (content.isEmpty) return [];

      final List decoded = jsonDecode(content);
      return decoded
          .map((e) => CategoryModel.fromJson(e))
          .toList();
    } catch (e) {
      print("Error reading categories: $e");
      return [];
    }
  }

  static Future<void> saveCategories(List<CategoryModel> categories) async {
    final file = await _getFile();
    final jsonData = categories.map((e) => e.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonData));
  }
}
