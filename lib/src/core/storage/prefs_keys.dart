enum PrefsKeys {
  isLoggedIn._('isLoggedIn'),

  newsFavorites._('news_favorites'),

  newsFavoritesData._('news_favorites_data');

  const PrefsKeys._(this.key);

  final String key;

  static const String _newsPagePrefix = 'news_page_';

  static String newsPage(int page) => '$_newsPagePrefix$page';

  static bool isNewsPageKey(String key) => key.startsWith(_newsPagePrefix);

  static Iterable<String> filterNewsPageKeys(Iterable<String> keys) {
    return keys.where(isNewsPageKey);
  }
}
