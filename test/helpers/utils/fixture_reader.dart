import 'dart:convert';
import 'dart:io';

class FixtureReader {
  static Future<Map<String, dynamic>> readAsMap(String fixtureName) async {
    final data = await _readFile(fixtureName);
    return jsonDecode(data) as Map<String, dynamic>;
  }

  static Future<List<dynamic>> readAsList(String fixtureName) async {
    final data = await _readFile(fixtureName);
    return jsonDecode(data) as List<dynamic>;
  }

  static Future<String> readAsString(String fixtureName) async {
    return _readFile(fixtureName);
  }

  static Future<String> _readFile(String fixtureName) async {
    final file = File('test/helpers/fixtures/$fixtureName');
    if (!await file.exists()) {
      throw FileSystemException('Fixture file not found', file.path);
    }
    return file.readAsString();
  }
}
