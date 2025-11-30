import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  /// Get file in app documents
  static Future getFile(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/$filename");
  }

  /// Read all users from a JSON file
  static Future<List<Map<String, dynamic>>> readJson(String filename) async {
    final file = await getFile(filename);

    if (!await file.exists()) return [];

    final content = await file.readAsString();
    if (content.isEmpty) return [];

    final List decoded = jsonDecode(content);
    return decoded.cast<Map<String, dynamic>>();
  }

  /// Write list of maps to JSON file
  static Future<void> writeJson(
    String filename,
    List<Map<String, dynamic>> data,
  ) async {
    final file = await getFile(filename);
    await file.writeAsString(jsonEncode(data));
  }
}
