import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/news/data/cache/news_cache_service.dart';
import 'package:nortus/src/features/news/data/datasources/news_datasource.dart';
import 'package:nortus/src/features/news/data/models/news_list_response_model.dart';
import 'package:nortus/src/features/news/data/models/news_pagination_model.dart';
import 'package:nortus/src/features/news/data/repositories/news_repository.dart';
import 'package:nortus/src/features/news/mock/news_mock_factory.dart';

class MockNewsDatasource extends Mock implements NewsDatasource {}

class MockNewsCacheService extends Mock implements NewsCacheService {}

void main() {
  late NewsRepository repository;
  late MockNewsDatasource mockDatasource;
  late MockNewsCacheService mockCacheService;

  setUp(() {
    mockDatasource = MockNewsDatasource();
    mockCacheService = MockNewsCacheService();
    repository = NewsRepository(mockDatasource, mockCacheService);
    
    when(() => mockCacheService.getPage(any())).thenAnswer((_) async => null);
  });

  NewsListResponseModel _createValidResponse({required int page}) {
    final pagination = NewsPaginationModel(
      page: page,
      pageSize: 10,
      totalPages: 5,
      totalItems: 50,
    );
    return NewsListResponseModel(pagination: pagination, data: []);
  }

  group('fetchNewsPage - API success', () {
    test('deve retornar Right com dados quando API sucesso', () async {
      const page = 1;
      final response = _createValidResponse(page: page);
      when(() => mockDatasource.fetchNews(page: page))
          .thenAnswer((_) async => Right(response));
      when(() => mockCacheService.savePage(page, any()))
          .thenAnswer((_) async => {});

      final result = await repository.fetchNewsPage(page: page);

      expect(result.isRight, isTrue);
      expect(result.right, equals(response));
      verify(() => mockDatasource.fetchNews(page: page)).called(1);
      verify(() => mockCacheService.savePage(page, any())).called(1);
    });

    test('deve salvar no cache quando API retorna dados', () async {
      const page = 2;
      final response = _createValidResponse(page: page);
      when(() => mockDatasource.fetchNews(page: page))
          .thenAnswer((_) async => Right(response));
      when(() => mockCacheService.savePage(page, any()))
          .thenAnswer((_) async => {});

      await repository.fetchNewsPage(page: page);

      verify(() => mockCacheService.savePage(page, any())).called(1);
    });

    test('deve retornar dados com items quando API retorna lista não vazia',
        () async {
      const page = 1;
      final response = NewsMockFactory.buildNewsListMock(page: page);
      when(() => mockDatasource.fetchNews(page: page))
          .thenAnswer((_) async => Right(response));
      when(() => mockCacheService.savePage(page, any()))
          .thenAnswer((_) async => {});

      final result = await repository.fetchNewsPage(page: page);

      expect(result.isRight, isTrue);
      expect(result.right.data.length, equals(10));
      expect(result.right.pagination.page, equals(page));
    });
  });

  group('fetchNewsPage - Fallback para cache', () {
    test('deve retornar cache quando API falha com NetworkError', () async {
      const page = 1;
      final error = NetworkError('Network error');
      final cachedJson = {'pagination': {'page': 1, 'pageSize': 10, 'totalPages': 5, 'totalItems': 50}, 'data': []};

      when(() => mockDatasource.fetchNews(page: page))
          .thenAnswer((_) async => Left(error));
      when(() => mockCacheService.getPage(page))
          .thenAnswer((_) async => cachedJson);

      final result = await repository.fetchNewsPage(page: page);

      expect(result.isRight, isTrue);
      verifyNever(() => mockDatasource.fetchNews(page: page));
      verify(() => mockCacheService.getPage(page)).called(1);
      verifyNever(() => mockCacheService.savePage(any(), any()));
    });

    test('deve retornar cache quando API retorna 429 (quota exceeded)',
        () async {
      const page = 2;
      final cachedJson = {'pagination': {'page': 2, 'pageSize': 10, 'totalPages': 5, 'totalItems': 50}, 'data': []};

      when(() => mockCacheService.getPage(page))
          .thenAnswer((_) async => cachedJson);

      final result = await repository.fetchNewsPage(page: page);

      expect(result.isRight, isTrue);
      verify(() => mockCacheService.getPage(page)).called(1);
    });

    test('deve retornar cache quando API timeout', () async {
      const page = 1;
      final error = NetworkError('Connection timeout');
      final cachedJson = {'pagination': {'page': 1, 'pageSize': 10, 'totalPages': 5, 'totalItems': 50}, 'data': []};

      when(() => mockDatasource.fetchNews(page: page))
          .thenAnswer((_) async => Left(error));
      when(() => mockCacheService.getPage(page))
          .thenAnswer((_) async => cachedJson);

      final result = await repository.fetchNewsPage(page: page);

      expect(result.isRight, isTrue);
      verify(() => mockCacheService.getPage(page)).called(1);
    });

    test('não deve usar cache quando API falha com ValidationError',
        () async {
      const page = 0;
      final error = ValidationError('Invalid page');

      when(() => mockDatasource.fetchNews(page: page))
          .thenAnswer((_) async => Left(error));

      final result = await repository.fetchNewsPage(page: page);

      expect(result.isLeft, isTrue);
      expect(result.left, equals(error));
      verify(() => mockCacheService.getPage(any())).called(1);
    });
  });

  group('fetchNewsPage - Fallback para mock', () {
    test('deve retornar mock quando API falha e cache vazio e quota exceeded',
        () async {
      const page = 1;
      final error = NetworkError('quota exceeded');

      when(() => mockDatasource.fetchNews(page: page))
          .thenAnswer((_) async => Left(error));

      final result = await repository.fetchNewsPage(page: page);

      expect(result.isRight, isTrue);
      expect(result.right.data.length, equals(10));
      expect(result.right.pagination.page, equals(page));
      verify(() => mockCacheService.getPage(page)).called(2);
    });

    test('deve retornar mock quando API 404 e cache vazio', () async {
      const page = 1;
      final error = NetworkError('404 not found');

      when(() => mockDatasource.fetchNews(page: page))
          .thenAnswer((_) async => Left(error));
      when(() => mockCacheService.getPage(page)).thenAnswer((_) async => null);

      final result = await repository.fetchNewsPage(page: page);

      expect(result.isRight, isTrue);
      expect(result.right.data.isNotEmpty, isTrue);
    });

    test('deve retornar erro quando API falha, cache vazio e erro não é quota',
        () async {
      const page = 1;
      final error = NetworkError('Internal Server Error');

      when(() => mockDatasource.fetchNews(page: page))
          .thenAnswer((_) async => Left(error));
      when(() => mockCacheService.getPage(page)).thenAnswer((_) async => null);

      final result = await repository.fetchNewsPage(page: page);

      expect(result.isLeft, isTrue);
      expect(result.left, equals(error));
    });

    test('mock deve gerar dados diferentes para páginas diferentes', () async {
      const page1 = 1;
      const page2 = 2;
      final error = NetworkError('quota exceeded');

      when(() => mockDatasource.fetchNews(page: any(named: 'page')))
          .thenAnswer((_) async => Left(error));
      when(() => mockCacheService.getPage(any()))
          .thenAnswer((_) async => null);

      final result1 = await repository.fetchNewsPage(page: page1);
      final result2 = await repository.fetchNewsPage(page: page2);

      expect(result1.isRight, isTrue);
      expect(result2.isRight, isTrue);
      expect(result1.right.pagination.page, equals(1));
      expect(result2.right.pagination.page, equals(2));

      final firstIdPage1 = result1.right.data.first.id;
      final firstIdPage2 = result2.right.data.first.id;
      expect(firstIdPage1, isNot(equals(firstIdPage2)));
    });
  });

  group('fetchNewsPage - Guards e edge cases', () {
    test('deve processar página 1 corretamente', () async {
      const page = 1;
      final response = _createValidResponse(page: page);
      when(() => mockDatasource.fetchNews(page: page))
          .thenAnswer((_) async => Right(response));
      when(() => mockCacheService.savePage(page, any()))
          .thenAnswer((_) async => {});

      final result = await repository.fetchNewsPage(page: page);

      expect(result.isRight, isTrue);
    });

    test('deve processar página alta (>100) corretamente', () async {
      const page = 150;
      final response = _createValidResponse(page: page);
      when(() => mockDatasource.fetchNews(page: page))
          .thenAnswer((_) async => Right(response));
      when(() => mockCacheService.savePage(page, any()))
          .thenAnswer((_) async => {});

      final result = await repository.fetchNewsPage(page: page);

      expect(result.isRight, isTrue);
      expect(result.right.pagination.page, equals(page));
    });

    test('deve retornar erro quando datasource retorna UnknownError', () async {
      const page = 1;
      final error = UnknownError('Unknown error');

      when(() => mockDatasource.fetchNews(page: page))
          .thenAnswer((_) async => Left(error));
      when(() => mockCacheService.getPage(page)).thenAnswer((_) async => null);

      final result = await repository.fetchNewsPage(page: page);

      expect(result.isLeft, isTrue);
      expect(result.left, equals(error));
    });
  });

  group('fetchNewsPage - Fluxo integrado completo', () {
    test('deve seguir ordem correta: API → salvar cache → retornar dados',
        () async {
      const page = 1;
      final response = _createValidResponse(page: page);
      final calls = <String>[];

      when(() => mockDatasource.fetchNews(page: page)).thenAnswer((_) async {
        calls.add('fetchNews');
        return Right(response);
      });

      when(() => mockCacheService.savePage(page, any()))
          .thenAnswer((_) async {
        calls.add('savePage');
      });

      await repository.fetchNewsPage(page: page);

      expect(calls, equals(['fetchNews', 'savePage']));
    });

    test(
        'deve seguir ordem correta: cache primeiro → se vazio → API → erro → tentar cache novamente',
        () async {
      const page = 1;
      final error = NetworkError('Network error');
      final cachedJson = {'pagination': {'page': 1, 'pageSize': 10, 'totalPages': 5, 'totalItems': 50}, 'data': []};
      final calls = <String>[];

      var cacheCallCount = 0;
      when(() => mockCacheService.getPage(page)).thenAnswer((_) async {
        calls.add('getPage');
        cacheCallCount++;
        return cacheCallCount == 1 ? null : cachedJson;
      });

      when(() => mockDatasource.fetchNews(page: page)).thenAnswer((_) async {
        calls.add('fetchNews');
        return Left(error);
      });

      await repository.fetchNewsPage(page: page);

      expect(calls, equals(['getPage', 'fetchNews', 'getPage']));
      verifyNever(() => mockCacheService.savePage(any(), any()));
    });

    test(
        'deve seguir ordem: cache vazio → API error → cache null → usar mock quando quota exceeded',
        () async {
      const page = 1;
      final error = NetworkError('quota exceeded');
      final calls = <String>[];

      when(() => mockCacheService.getPage(page)).thenAnswer((_) async {
        calls.add('getPage');
        return null;
      });

      when(() => mockDatasource.fetchNews(page: page)).thenAnswer((_) async {
        calls.add('fetchNews');
        return Left(error);
      });

      final result = await repository.fetchNewsPage(page: page);

      expect(calls, equals(['getPage', 'fetchNews', 'getPage']));
      expect(result.isRight, isTrue);
      expect(result.right.data.isNotEmpty, isTrue);
    });

    test('deve persistir múltiplas páginas no cache independentemente',
        () async {
      final response1 = _createValidResponse(page: 1);
      final response2 = _createValidResponse(page: 2);

      when(() => mockDatasource.fetchNews(page: 1))
          .thenAnswer((_) async => Right(response1));
      when(() => mockDatasource.fetchNews(page: 2))
          .thenAnswer((_) async => Right(response2));
      when(() => mockCacheService.savePage(any(), any()))
          .thenAnswer((_) async => {});

      await repository.fetchNewsPage(page: 1);
      await repository.fetchNewsPage(page: 2);

      verify(() => mockCacheService.savePage(1, any())).called(1);
      verify(() => mockCacheService.savePage(2, any())).called(1);
    });
  });

  group('fetchNewsPage - Stale-While-Revalidate', () {
    test('deve retornar cache imediatamente quando disponível (sem chamar API)', () async {
      const page = 1;
      final cachedResponse = _createValidResponse(page: page);
      when(() => mockCacheService.getPage(page))
          .thenAnswer((_) async => cachedResponse.toJson());

      final result = await repository.fetchNewsPage(page: page);

      expect(result.isRight, isTrue);
      expect(result.right, isNotNull);
      verify(() => mockCacheService.getPage(page)).called(1);
      verifyNever(() => mockDatasource.fetchNews(page: page));
    });

    test('deve buscar da API quando não há cache disponível', () async {
      const page = 1;
      final apiResponse = _createValidResponse(page: page);
      when(() => mockCacheService.getPage(page)).thenAnswer((_) async => null);
      when(() => mockDatasource.fetchNews(page: page))
          .thenAnswer((_) async => Right(apiResponse));
      when(() => mockCacheService.savePage(page, any()))
          .thenAnswer((_) async => {});

      final result = await repository.fetchNewsPage(page: page);

      expect(result.isRight, isTrue);
      verify(() => mockCacheService.getPage(page)).called(1);
      verify(() => mockDatasource.fetchNews(page: page)).called(1);
      verify(() => mockCacheService.savePage(page, any())).called(1);
    });

    test('deve ignorar cache quando forceRefresh=true', () async {
      const page = 1;
      final cachedResponse = _createValidResponse(page: page);
      final apiResponse = _createValidResponse(page: page);
      when(() => mockCacheService.getPage(page))
          .thenAnswer((_) async => cachedResponse.toJson());
      when(() => mockDatasource.fetchNews(page: page))
          .thenAnswer((_) async => Right(apiResponse));
      when(() => mockCacheService.savePage(page, any()))
          .thenAnswer((_) async => {});

      final result = await repository.fetchNewsPage(page: page, forceRefresh: true);

      expect(result.isRight, isTrue);
      verifyNever(() => mockCacheService.getPage(page));
      verify(() => mockDatasource.fetchNews(page: page)).called(1);
      verify(() => mockCacheService.savePage(page, any())).called(1);
    });

    test('deve usar cache como fallback quando API falha (mesmo com forceRefresh)', () async {
      const page = 1;
      final cachedResponse = _createValidResponse(page: page);
      final error = NetworkError('Network error');
      when(() => mockCacheService.getPage(page))
          .thenAnswer((_) async => cachedResponse.toJson());
      when(() => mockDatasource.fetchNews(page: page))
          .thenAnswer((_) async => Left(error));

      final result = await repository.fetchNewsPage(page: page, forceRefresh: true);

      expect(result.isRight, isTrue);
      verify(() => mockDatasource.fetchNews(page: page)).called(1);
      verify(() => mockCacheService.getPage(page)).called(1);
    });
  });
}
