import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class LocalUserHelper {

  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/users.json");
  }

  /// Read all stored users
  static Future<List<Map<String, dynamic>>> readUsers() async {
    try {
      final file = await _getFile();

      if (!(await file.exists())) {
        await file.writeAsString(jsonEncode([]));
        return [];
      }

      final content = await file.readAsString();
      final List data = jsonDecode(content);

      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      print("❌ Read error: $e");
      return [];
    }
  }

  /// Save users back into file
  static Future<void> saveUsers(List<Map<String, dynamic>> users) async {
    final file = await _getFile();
    await file.writeAsString(jsonEncode(users));
  }

}
