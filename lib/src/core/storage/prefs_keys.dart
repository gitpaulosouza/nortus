/// Centralized SharedPreferences keys to avoid hardcoded strings.
///
/// Usage examples:
/// ```dart
/// // Static keys
/// prefs.getString(PrefsKeys.isLoggedIn.key);
/// prefs.setStringList(PrefsKeys.newsFavorites.key, values);
///
/// // Dynamic keys
/// prefs.getString(PrefsKeys.newsPage(1));
/// prefs.getString(PrefsKeys.newsPage(2));
/// ```
enum PrefsKeys {
  /// Authentication: User login state
  /// Value: 'isLoggedIn'
  isLoggedIn._('isLoggedIn'),

  /// News: Favorite news IDs (list of int as strings)
  /// Value: 'news_favorites'
  newsFavorites._('news_favorites'),

  /// News: Favorite news complete data (list of JSON strings)
  /// Value: 'news_favorites_data'
  newsFavoritesData._('news_favorites_data');

  const PrefsKeys._(this.key);

  /// The actual key used in SharedPreferences
  final String key;

  /// Prefix for news page cache keys
  static const String _newsPagePrefix = 'news_page_';

  /// Returns a dynamic key for news page cache
  /// Example: newsPage(1) => 'news_page_1'
  static String newsPage(int page) => '$_newsPagePrefix$page';

  /// Returns true if the given key is a news page cache key
  static bool isNewsPageKey(String key) => key.startsWith(_newsPagePrefix);

  /// Returns all news page keys from a set of keys
  static Iterable<String> filterNewsPageKeys(Iterable<String> keys) {
    return keys.where(isNewsPageKey);
  }
}
