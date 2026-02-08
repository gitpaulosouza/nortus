import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
  Future<bool> isLoggedIn();
  Future<void> setLoggedIn(bool value);
}

class LocalStorageImpl implements LocalStorage {
  static const String _isLoggedInKey = 'isLoggedIn';

  Future<SharedPreferences> get _prefs async {
    return SharedPreferences.getInstance();
  }

  @override
  Future<bool> isLoggedIn() async {
    final prefs = await _prefs;
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  @override
  Future<void> setLoggedIn(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_isLoggedInKey, value);
  }
}
