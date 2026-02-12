import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NewsCacheService {
  static const String _pagePrefix = 'news_page_';

  Future<SharedPreferences> get _prefs async {
    return SharedPreferences.getInstance();
  }

  Future<void> savePage(int page, Map<String, dynamic> json) async {
    final prefs = await _prefs;
    final key = '$_pagePrefix$page';
    final payload = jsonEncode(json);
    await prefs.setString(key, payload);
  }

  Future<Map<String, dynamic>?> getPage(int page) async {
    final prefs = await _prefs;
    final key = '$_pagePrefix$page';
    final payload = prefs.getString(key);
    if (payload == null || payload.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  Future<void> clear() async {
    final prefs = await _prefs;
    final keys = prefs.getKeys().where((key) => key.startsWith(_pagePrefix));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
