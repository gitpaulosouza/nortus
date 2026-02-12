abstract class NewsCacheService {
  Future<void> savePage(int page, Map<String, dynamic> json);
  Future<Map<String, dynamic>?> getPage(int page);
  Future<void> clear();
}
