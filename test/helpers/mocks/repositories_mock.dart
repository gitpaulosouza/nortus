import 'package:mocktail/mocktail.dart';

class MockNewsRepository extends Mock {}

class MockUserRepository extends Mock {}

class MockNewsCacheService extends Mock {
  Future<void> save(String key, dynamic value) =>
      Future.value();
  
  Future<dynamic> get(String key) =>
      Future.value(null);
  
  Future<void> clear() =>
      Future.value();
}
