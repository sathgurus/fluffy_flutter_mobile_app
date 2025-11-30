import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class BusinessHoursFileHelper {

  static const String _fileName = "business_hours.json";

  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/$_fileName");
  }

  static Future<List<Map<String, dynamic>>> readAll() async {
    final file = await _getFile();
    if (!await file.exists()) return [];

    final content = await file.readAsString();
    if (content.isEmpty) return [];

    return List<Map<String, dynamic>>.from(jsonDecode(content));
  }

  static Future<void> writeAll(List<Map<String, dynamic>> data) async {
    final file = await _getFile();
    await file.writeAsString(jsonEncode(data), flush: true);
  }
}
