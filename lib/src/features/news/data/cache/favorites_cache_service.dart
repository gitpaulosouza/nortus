import 'package:nortus/src/features/news/data/models/news_model.dart';

abstract class FavoritesCacheService {
  Future<void> saveFavorites(Set<int> favoriteIds);
  Future<Set<int>> loadFavorites();
  Future<void> clear();
  Future<void> addFavorite(int newsId);
  Future<void> removeFavorite(int newsId);
  
  // Novos métodos para salvar e carregar notícias completas
  Future<void> saveFavoriteNews(List<NewsModel> news);
  Future<List<NewsModel>> loadFavoriteNews();
  Future<void> addFavoriteNews(NewsModel news);
  Future<void> removeFavoriteNews(int newsId);
}
