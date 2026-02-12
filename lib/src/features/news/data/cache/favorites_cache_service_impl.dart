import 'dart:convert';
import 'package:nortus/src/core/storage/prefs_keys.dart';
import 'package:nortus/src/features/news/data/cache/favorites_cache_service.dart';
import 'package:nortus/src/features/news/data/models/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesCacheServiceImpl implements FavoritesCacheService {

  Future<SharedPreferences> get _prefs async {
    return SharedPreferences.getInstance();
  }

  @override
  Future<void> saveFavorites(Set<int> favoriteIds) async {
    final prefs = await _prefs;
    final favoritesList = favoriteIds.toList();
    await prefs.setStringList(
      PrefsKeys.newsFavorites.key,
      favoritesList.map((id) => id.toString()).toList(),
    );
  }

  @override
  Future<Set<int>> loadFavorites() async {
    try {
      final prefs = await _prefs;
      final savedFavorites = prefs.getStringList(PrefsKeys.newsFavorites.key) ?? [];
      return savedFavorites.map((id) => int.parse(id)).toSet();
    } catch (_) {
      final prefs = await _prefs;
      await prefs.remove(PrefsKeys.newsFavorites.key);
      return {};
    }
  }

  @override
  Future<void> clear() async {
    final prefs = await _prefs;
    await prefs.remove(PrefsKeys.newsFavorites.key);
    await prefs.remove(PrefsKeys.newsFavoritesData.key);
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
      await prefs.setStringList(PrefsKeys.newsFavoritesData.key, newsJsonList);
    } catch (_) {
    }
  }

  @override
  Future<List<NewsModel>> loadFavoriteNews() async {
    try {
      final prefs = await _prefs;
      final newsJsonList = prefs.getStringList(PrefsKeys.newsFavoritesData.key) ?? [];
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
