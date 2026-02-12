abstract class FavoritesCacheService {
  Future<void> saveFavorites(Set<int> favoriteIds);
  Future<Set<int>> loadFavorites();
  Future<void> clear();
  Future<void> addFavorite(int newsId);
  Future<void> removeFavorite(int newsId);
}
