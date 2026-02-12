import 'package:nortus/src/features/news/data/cache/favorites_cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesCacheServiceImpl implements FavoritesCacheService {
  static const String _favoritesKey = 'news_favorites';

  Future<SharedPreferences> get _prefs async {
    return SharedPreferences.getInstance();
  }

  @override
  Future<void> saveFavorites(Set<int> favoriteIds) async {
    final prefs = await _prefs;
    final favoritesList = favoriteIds.toList();
    await prefs.setStringList(
      _favoritesKey,
      favoritesList.map((id) => id.toString()).toList(),
    );
  }

  @override
  Future<Set<int>> loadFavorites() async {
    try {
      final prefs = await _prefs;
      final savedFavorites = prefs.getStringList(_favoritesKey) ?? [];
      return savedFavorites.map((id) => int.parse(id)).toSet();
    } catch (_) {
      final prefs = await _prefs;
      await prefs.remove(_favoritesKey);
      return {};
    }
  }

  @override
  Future<void> clear() async {
    final prefs = await _prefs;
    await prefs.remove(_favoritesKey);
  }

  @override
  Future<void> addFavorite(int newsId) async {
    final favorites = await loadFavorites();
    favorites.add(newsId);
    await saveFavorites(favorites);
  }

  @override
  Future<void> removeFavorite(int newsId) async {
    final favorites = await loadFavorites();
    favorites.remove(newsId);
    await saveFavorites(favorites);
  }
}
