import 'dart:convert';
import 'package:nortus/src/features/news/data/cache/news_cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsCacheServiceImpl implements NewsCacheService {
  static const String _pagePrefix = 'news_page_';

  Future<SharedPreferences> get _prefs async {
    return SharedPreferences.getInstance();
  }

  @override
  Future<void> savePage(int page, Map<String, dynamic> json) async {
    final prefs = await _prefs;
    final key = '$_pagePrefix$page';
    final payload = jsonEncode(json);
    await prefs.setString(key, payload);
  }

  @override
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

  @override
  Future<void> clear() async {
    final prefs = await _prefs;
    final keys = prefs.getKeys().where((key) => key.startsWith(_pagePrefix));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
