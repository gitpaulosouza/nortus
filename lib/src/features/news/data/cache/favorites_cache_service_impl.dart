import 'dart:convert';
import 'package:nortus/src/features/news/data/cache/favorites_cache_service.dart';
import 'package:nortus/src/features/news/data/models/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesCacheServiceImpl implements FavoritesCacheService {
  static const String _favoritesKey = 'news_favorites';
  static const String _favoriteNewsKey = 'news_favorites_data';

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
    await prefs.remove(_favoriteNewsKey);
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

  @override
  Future<void> saveFavoriteNews(List<NewsModel> news) async {
    try {
      final prefs = await _prefs;
      final newsJsonList = news.map((n) => json.encode(n.toJson())).toList();
      await prefs.setStringList(_favoriteNewsKey, newsJsonList);
    } catch (_) {
      // Ignora erro ao salvar
    }
  }

  @override
  Future<List<NewsModel>> loadFavoriteNews() async {
    try {
      final prefs = await _prefs;
      final newsJsonList = prefs.getStringList(_favoriteNewsKey) ?? [];
      return newsJsonList
          .map((jsonStr) => NewsModel.fromJson(json.decode(jsonStr)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> addFavoriteNews(NewsModel news) async {
    final favoriteNews = await loadFavoriteNews();
    // Remove se já existir para evitar duplicatas
    favoriteNews.removeWhere((n) => n.id == news.id);
    favoriteNews.add(news);
    await saveFavoriteNews(favoriteNews);
  }

  @override
  Future<void> removeFavoriteNews(int newsId) async {
    final favoriteNews = await loadFavoriteNews();
    favoriteNews.removeWhere((n) => n.id == newsId);
    await saveFavoriteNews(favoriteNews);
  }
}
