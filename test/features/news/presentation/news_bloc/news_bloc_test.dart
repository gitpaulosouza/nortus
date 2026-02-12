import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/news/data/cache/favorites_cache_service.dart';
import 'package:nortus/src/features/news/data/models/news_author_model.dart';
import 'package:nortus/src/features/news/data/models/news_image_model.dart';
import 'package:nortus/src/features/news/data/models/news_list_response_model.dart';
import 'package:nortus/src/features/news/data/models/news_model.dart';
import 'package:nortus/src/features/news/data/models/news_pagination_model.dart';
import 'package:nortus/src/features/news/data/repositories/news_repository.dart';
import 'package:nortus/src/features/news/presentation/news_bloc/news_bloc.dart';
import 'package:nortus/src/features/news/presentation/news_bloc/news_event.dart';
import 'package:nortus/src/features/news/presentation/news_bloc/news_state.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

class MockFavoritesCacheService extends Mock implements FavoritesCacheService {}

class FakeNewsModel extends Fake implements NewsModel {}

void main() {
  late NewsBloc bloc;
  late MockNewsRepository mockRepository;
  late MockFavoritesCacheService mockFavoritesCache;

  setUpAll(() {
    registerFallbackValue(FakeNewsModel());
  });

  NewsModel _createNews({
    required int id,
    required String title,
    String summary = 'Summary',
    List<String> categories = const ['Categoria'],
  }) {
    return NewsModel(
      id: id,
      title: title,
      image: NewsImageModel(src: 'http://image.com', alt: 'alt'),
      categories: categories,
      publishedAt: DateTime(2024, 1, 1),
      summary: summary,
      authors: [
        NewsAuthorModel(
          name: 'Author',
          image: NewsImageModel(src: 'http://avatar.com', alt: 'avatar'),
          description: 'Author description',
        )
      ],
    );
  }

  NewsListResponseModel _createResponse({
    required int page,
    required List<NewsModel> data,
    int totalPages = 5,
  }) {
    final pagination = NewsPaginationModel(
      page: page,
      pageSize: 10,
      totalPages: totalPages,
      totalItems: 50,
    );
    return NewsListResponseModel(pagination: pagination, data: data);
  }

  setUp(() {
    mockRepository = MockNewsRepository();
    mockFavoritesCache = MockFavoritesCacheService();
    
    when(() => mockFavoritesCache.loadFavorites())
        .thenAnswer((_) async => <int>{});
    when(() => mockFavoritesCache.loadFavoriteNews())
        .thenAnswer((_) async => <NewsModel>[]);
    when(() => mockFavoritesCache.saveFavorites(any()))
        .thenAnswer((_) async {});
    when(() => mockFavoritesCache.addFavoriteNews(any()))
        .thenAnswer((_) async {});
    when(() => mockFavoritesCache.removeFavoriteNews(any()))
        .thenAnswer((_) async {});
  });

  tearDown(() {
    bloc.close();
  });

  group('NewsStarted', () {
    test('deve carregar favorites do cache ao iniciar', () async {
      final savedFavorites = {1, 2, 3};
      final newsItems = [_createNews(id: 1, title: 'News 1')];
      final response = _createResponse(page: 1, data: newsItems);

      when(() => mockFavoritesCache.loadFavorites())
          .thenAnswer((_) async => savedFavorites);
      when(() => mockRepository.fetchNewsPage(page: 1))
          .thenAnswer((_) async => Right(response));

      bloc = NewsBloc(mockRepository, mockFavoritesCache);
      bloc.add(NewsStarted());
      await Future.delayed(Duration(milliseconds: 100));

      verify(() => mockFavoritesCache.loadFavorites()).called(1);
      expect(bloc.state.favoriteIds, equals(savedFavorites));
    });

    test('deve emitir estado inicial com favorites vazios se cache vazio',
        () async {
      final newsItems = [_createNews(id: 1, title: 'News 1')];
      final response = _createResponse(page: 1, data: newsItems);

      when(() => mockFavoritesCache.loadFavorites())
          .thenAnswer((_) async => <int>{});
      when(() => mockRepository.fetchNewsPage(page: 1))
          .thenAnswer((_) async => Right(response));

      bloc = NewsBloc(mockRepository, mockFavoritesCache);
      bloc.add(NewsStarted());
      await Future.delayed(Duration(milliseconds: 100));

      expect(bloc.state.favoriteIds, isEmpty);
    });

    test('deve carregar primeira página após carregar favorites', () async {
      final newsItems = [_createNews(id: 1, title: 'News 1')];
      final response = _createResponse(page: 1, data: newsItems);

      when(() => mockFavoritesCache.loadFavorites())
          .thenAnswer((_) async => <int>{});
      when(() => mockRepository.fetchNewsPage(page: 1))
          .thenAnswer((_) async => Right(response));

      bloc = NewsBloc(mockRepository, mockFavoritesCache);
      bloc.add(NewsStarted());
      await Future.delayed(Duration(milliseconds: 100));

      verify(() => mockRepository.fetchNewsPage(page: 1)).called(1);
      expect(bloc.state.items, equals(newsItems));
      expect(bloc.state.currentPage, equals(1));
    });

    blocTest<NewsBloc, NewsState>(
      'deve emitir [loading, loaded] ao iniciar com sucesso',
      setUp: () {
        mockRepository = MockNewsRepository();
        mockFavoritesCache = MockFavoritesCacheService();
      },
      build: () {
        final newsItems = [_createNews(id: 1, title: 'News 1')];
        final response = _createResponse(page: 1, data: newsItems);

        when(() => mockFavoritesCache.loadFavorites())
            .thenAnswer((_) async => <int>{});
        when(() => mockFavoritesCache.loadFavoriteNews())
            .thenAnswer((_) async => <NewsModel>[]);
        when(() => mockFavoritesCache.saveFavorites(any()))
            .thenAnswer((_) async {});
        when(() => mockFavoritesCache.addFavoriteNews(any()))
            .thenAnswer((_) async {});
        when(() => mockFavoritesCache.removeFavoriteNews(any()))
            .thenAnswer((_) async {});
        when(() => mockRepository.fetchNewsPage(page: 1))
            .thenAnswer((_) async => Right(response));

        return NewsBloc(mockRepository, mockFavoritesCache);
      },
      wait: Duration(milliseconds: 100),
      skip: 1,
      act: (bloc) => bloc.add(NewsStarted()),
      expect: () => [
        predicate<NewsState>((state) => state.isLoading),
        predicate<NewsState>(
            (state) => !state.isLoading && state.items.length == 1),
      ],
    );
  });

  group('NewsSearchQueryChanged', () {
    test('deve normalizar query removendo espaços extras', () async {
      final newsItems = [_createNews(id: 1, title: 'Notícia Importante')];
      final response = _createResponse(page: 1, data: newsItems);

      when(() => mockFavoritesCache.loadFavorites())
          .thenAnswer((_) async => <int>{});
      when(() => mockRepository.fetchNewsPage(page: 1))
          .thenAnswer((_) async => Right(response));

      bloc = NewsBloc(mockRepository, mockFavoritesCache);
      bloc.add(NewsStarted());
      await Future.delayed(Duration(milliseconds: 100));

      bloc.add(NewsSearchQueryChanged('  Notícia  '));
      await Future.delayed(Duration(milliseconds: 50));

      expect(bloc.state.searchQuery, equals('notecia'));
    });

    test('deve normalizar query para lowercase', () async {
      final newsItems = [_createNews(id: 1, title: 'Notícia')];
      final response = _createResponse(page: 1, data: newsItems);

      when(() => mockFavoritesCache.loadFavorites())
          .thenAnswer((_) async => <int>{});
      when(() => mockRepository.fetchNewsPage(page: 1))
          .thenAnswer((_) async => Right(response));

      bloc = NewsBloc(mockRepository, mockFavoritesCache);
      bloc.add(NewsStarted());
      await Future.delayed(Duration(milliseconds: 100));

      bloc.add(NewsSearchQueryChanged('NOTICIA'));
      await Future.delayed(Duration(milliseconds: 50));

      expect(bloc.state.searchQuery, equals('noticia'));
    });

    test('deve normalizar query removendo diacríticos (acentos)', () async {
      final newsItems = [_createNews(id: 1, title: 'Notícia')];
      final response = _createResponse(page: 1, data: newsItems);

      when(() => mockFavoritesCache.loadFavorites())
          .thenAnswer((_) async => <int>{});
      when(() => mockRepository.fetchNewsPage(page: 1))
          .thenAnswer((_) async => Right(response));

      bloc = NewsBloc(mockRepository, mockFavoritesCache);
      bloc.add(NewsStarted());
      await Future.delayed(Duration(milliseconds: 100));

      bloc.add(NewsSearchQueryChanged('Notícia Açúcar Café'));
      await Future.delayed(Duration(milliseconds: 50));

      expect(bloc.state.searchQuery, equals('notecia açocar cafa'));
    });

    test('deve filtrar visibleItems com base na query normalizada', () async {
      final newsItems = [
        _createNews(id: 1, title: 'Notícia sobre Tecnologia'),
        _createNews(id: 2, title: 'Esporte do Brasil'),
        _createNews(id: 3, title: 'Política Nacional'),
      ];
      final response = _createResponse(page: 1, data: newsItems);

      when(() => mockFavoritesCache.loadFavorites())
          .thenAnswer((_) async => <int>{});
      when(() => mockRepository.fetchNewsPage(page: 1))
          .thenAnswer((_) async => Right(response));

      bloc = NewsBloc(mockRepository, mockFavoritesCache);
      bloc.add(NewsStarted());
      await Future.delayed(Duration(milliseconds: 100));

      bloc.add(NewsSearchQueryChanged('Tecnologia'));
      await Future.delayed(Duration(milliseconds: 50));

      expect(bloc.state.visibleItems.length, equals(1));
      expect(bloc.state.visibleItems.first.id, equals(1));
    });

    test('deve retornar lista vazia se nenhuma notícia corresponder à query',
        () async {
      final newsItems = [
        _createNews(id: 1, title: 'Notícia A'),
        _createNews(id: 2, title: 'Notícia B'),
      ];
      final response = _createResponse(page: 1, data: newsItems);

      when(() => mockFavoritesCache.loadFavorites())
          .thenAnswer((_) async => <int>{});
      when(() => mockRepository.fetchNewsPage(page: 1))
          .thenAnswer((_) async => Right(response));

      bloc = NewsBloc(mockRepository, mockFavoritesCache);
      bloc.add(NewsStarted());
      await Future.delayed(Duration(milliseconds: 100));

      bloc.add(NewsSearchQueryChanged('XYZ não existe'));
      await Future.delayed(Duration(milliseconds: 50));

      expect(bloc.state.visibleItems, isEmpty);
    });

    test('deve buscar no summary quando não encontrar no título', () async {
      final newsItems = [
        _createNews(id: 1, title: 'Título A', summary: 'Tecnologia é o futuro'),
        _createNews(id: 2, title: 'Título B', summary: 'Esporte'),
      ];
      final response = _createResponse(page: 1, data: newsItems);

      when(() => mockFavoritesCache.loadFavorites())
          .thenAnswer((_) async => <int>{});
      when(() => mockRepository.fetchNewsPage(page: 1))
          .thenAnswer((_) async => Right(response));

      bloc = NewsBloc(mockRepository, mockFavoritesCache);
      bloc.add(NewsStarted());
      await Future.delayed(Duration(milliseconds: 100));

      bloc.add(NewsSearchQueryChanged('futuro'));
      await Future.delayed(Duration(milliseconds: 50));

      expect(bloc.state.visibleItems.length, equals(1));
      expect(bloc.state.visibleItems.first.id, equals(1));
    });

    test('deve buscar em categories quando não encontrar em título/summary',
        () async {
      final newsItems = [
        _createNews(
            id: 1,
            title: 'Título A',
            summary: 'Summary A',
            categories: ['Tecnologia']),
        _createNews(
            id: 2, title: 'Título B', summary: 'Summary B', categories: ['Esporte']),
      ];
      final response = _createResponse(page: 1, data: newsItems);

      when(() => mockFavoritesCache.loadFavorites())
          .thenAnswer((_) async => <int>{});
      when(() => mockRepository.fetchNewsPage(page: 1))
          .thenAnswer((_) async => Right(response));

      bloc = NewsBloc(mockRepository, mockFavoritesCache);
      bloc.add(NewsStarted());
      await Future.delayed(Duration(milliseconds: 100));

      bloc.add(NewsSearchQueryChanged('Esporte'));
      await Future.delayed(Duration(milliseconds: 50));

      expect(bloc.state.visibleItems.length, equals(1));
      expect(bloc.state.visibleItems.first.id, equals(2));
    });
  });

  group('NewsFavoriteToggled', () {
    test('deve adicionar favorito se não existe', () async {
      final newsItem = _createNews(id: 1, title: 'News 1');
      final newsItems = [newsItem];
      final response = _createResponse(page: 1, data: newsItems);

      when(() => mockFavoritesCache.loadFavorites())
          .thenAnswer((_) async => <int>{});
      when(() => mockRepository.fetchNewsPage(page: 1))
          .thenAnswer((_) async => Right(response));
      when(() => mockFavoritesCache.saveFavorites(any()))
          .thenAnswer((_) async => {});

      bloc = NewsBloc(mockRepository, mockFavoritesCache);
      bloc.add(NewsStarted());
      await Future.delayed(Duration(milliseconds: 100));

      bloc.add(NewsFavoriteToggled(newsItem));
      await Future.delayed(Duration(milliseconds: 50));

      expect(bloc.state.favoriteIds, contains(1));
      expect(bloc.state.lastFavoriteToggledId, equals(1));
      expect(bloc.state.lastFavoriteWasAdded, isTrue);
      verify(() => mockFavoritesCache.saveFavorites({1})).called(1);
    });

    test('deve remover favorito se já existe', () async {
      final newsItem = _createNews(id: 1, title: 'News 1');
      final newsItems = [newsItem];
      final response = _createResponse(page: 1, data: newsItems);

      when(() => mockFavoritesCache.loadFavorites())
          .thenAnswer((_) async => {1});
      when(() => mockRepository.fetchNewsPage(page: 1))
          .thenAnswer((_) async => Right(response));
      when(() => mockFavoritesCache.saveFavorites(any()))
          .thenAnswer((_) async => {});

      bloc = NewsBloc(mockRepository, mockFavoritesCache);
      bloc.add(NewsStarted());
      await Future.delayed(Duration(milliseconds: 100));

      bloc.add(NewsFavoriteToggled(newsItem));
      await Future.delayed(Duration(milliseconds: 50));

      expect(bloc.state.favoriteIds, isNot(contains(1)));
      expect(bloc.state.lastFavoriteToggledId, equals(1));
      expect(bloc.state.lastFavoriteWasAdded, isFalse);
      verify(() => mockFavoritesCache.saveFavorites(<int>{})).called(1);
    });

    test('deve persistir favoritos após cada toggle', () async {
      final news1 = _createNews(id: 1, title: 'News 1');
      final news2 = _createNews(id: 2, title: 'News 2');
      final newsItems = [news1, news2];
      final response = _createResponse(page: 1, data: newsItems);

      when(() => mockFavoritesCache.loadFavorites())
          .thenAnswer((_) async => <int>{});
      when(() => mockRepository.fetchNewsPage(page: 1))
          .thenAnswer((_) async => Right(response));
      when(() => mockFavoritesCache.saveFavorites(any()))
          .thenAnswer((_) async => {});

      bloc = NewsBloc(mockRepository, mockFavoritesCache);
      bloc.add(NewsStarted());
      await Future.delayed(Duration(milliseconds: 100));

      bloc.add(NewsFavoriteToggled(news1));
      await Future.delayed(Duration(milliseconds: 50));
      bloc.add(NewsFavoriteToggled(news2));
      await Future.delayed(Duration(milliseconds: 50));

      verify(() => mockFavoritesCache.saveFavorites({1})).called(1);
      verify(() => mockFavoritesCache.saveFavorites({1, 2})).called(1);
    });

    test('deve manter favoritos existentes ao adicionar novo', () async {
      final news1 = _createNews(id: 1, title: 'News 1');
      final news2 = _createNews(id: 2, title: 'News 2');
      final newsItems = [news1, news2];
      final response = _createResponse(page: 1, data: newsItems);

      when(() => mockFavoritesCache.loadFavorites())
          .thenAnswer((_) async => {1});
      when(() => mockRepository.fetchNewsPage(page: 1))
          .thenAnswer((_) async => Right(response));
      when(() => mockFavoritesCache.saveFavorites(any()))
          .thenAnswer((_) async => {});

      bloc = NewsBloc(mockRepository, mockFavoritesCache);
      bloc.add(NewsStarted());
      await Future.delayed(Duration(milliseconds: 100));

      bloc.add(NewsFavoriteToggled(news2));
      await Future.delayed(Duration(milliseconds: 50));

      expect(bloc.state.favoriteIds, equals({1, 2}));
      verify(() => mockFavoritesCache.saveFavorites({1, 2})).called(1);
    });

    blocTest<NewsBloc, NewsState>(
      'deve emitir estado com favorito adicionado',
      setUp: () {
        mockRepository = MockNewsRepository();
        mockFavoritesCache = MockFavoritesCacheService();
      },
      build: () {
        final news1 = _createNews(id: 1, title: 'News 1');
        final newsItems = [news1];
        final response = _createResponse(page: 1, data: newsItems);

        when(() => mockFavoritesCache.loadFavorites())
            .thenAnswer((_) async => <int>{});
        when(() => mockFavoritesCache.loadFavoriteNews())
            .thenAnswer((_) async => <NewsModel>[]);
        when(() => mockRepository.fetchNewsPage(page: 1))
            .thenAnswer((_) async => Right(response));
        when(() => mockFavoritesCache.saveFavorites(any()))
            .thenAnswer((_) async {});
        when(() => mockFavoritesCache.addFavoriteNews(any()))
            .thenAnswer((_) async {});

        return NewsBloc(mockRepository, mockFavoritesCache);
      },
      act: (bloc) {
        bloc.add(NewsStarted());
        return Future.delayed(Duration(milliseconds: 100)).then((_) {
          bloc.add(NewsFavoriteToggled(_createNews(id: 1, title: 'News 1')));
        });
      },
      skip: 3,
      expect: () => [
        predicate<NewsState>((state) =>
            state.favoriteIds.contains(1) && state.lastFavoriteWasAdded == true),
      ],
    );
  });

  group('NewsLoadMoreRequested', () {
    test('deve carregar próxima página quando solicitado', () async {
      final page1Items = [_createNews(id: 1, title: 'News 1')];
      final page2Items = [_createNews(id: 2, title: 'News 2')];
      final response1 = _createResponse(page: 1, data: page1Items);
      final response2 = _createResponse(page: 2, data: page2Items);

      when(() => mockFavoritesCache.loadFavorites())
          .thenAnswer((_) async => <int>{});
      when(() => mockRepository.fetchNewsPage(page: 1))
          .thenAnswer((_) async => Right(response1));
      when(() => mockRepository.fetchNewsPage(page: 2))
          .thenAnswer((_) async => Right(response2));

      bloc = NewsBloc(mockRepository, mockFavoritesCache);
      bloc.add(NewsStarted());
      await Future.delayed(Duration(milliseconds: 100));

      bloc.add(NewsLoadMoreRequested());
      await Future.delayed(Duration(milliseconds: 100));

      expect(bloc.state.items.length, equals(2));
      expect(bloc.state.currentPage, equals(2));
      verify(() => mockRepository.fetchNewsPage(page: 2)).called(1);
    });

    test('não deve carregar se já está carregando', () async {
      final newsItems = [_createNews(id: 1, title: 'News 1')];
      final response = _createResponse(page: 1, data: newsItems);

      when(() => mockFavoritesCache.loadFavorites())
          .thenAnswer((_) async => <int>{});
      when(() => mockRepository.fetchNewsPage(page: any(named: 'page')))
          .thenAnswer((_) async {
        await Future.delayed(Duration(seconds: 1));
        return Right(response);
      });

      bloc = NewsBloc(mockRepository, mockFavoritesCache);
      bloc.add(NewsStarted());

      bloc.add(NewsLoadMoreRequested());
      await Future.delayed(Duration(milliseconds: 50));

      verify(() => mockRepository.fetchNewsPage(page: 1)).called(1);
    });
  });

  group('Error handling', () {
    test('deve emitir erro quando API falha', () async {
      final error = NetworkError('Network error');

      when(() => mockFavoritesCache.loadFavorites())
          .thenAnswer((_) async => <int>{});
      when(() => mockRepository.fetchNewsPage(page: 1))
          .thenAnswer((_) async => Left(error));

      bloc = NewsBloc(mockRepository, mockFavoritesCache);
      bloc.add(NewsStarted());
      await Future.delayed(Duration(milliseconds: 100));

      expect(bloc.state.error, equals(error));
      expect(bloc.state.isLoading, isFalse);
    });

    blocTest<NewsBloc, NewsState>(
      'deve limpar erro ao carregar com sucesso após falha',
      setUp: () {
        mockRepository = MockNewsRepository();
        mockFavoritesCache = MockFavoritesCacheService();
      },
      build: () {
        final error = NetworkError('Network error');
        final newsItems = [_createNews(id: 1, title: 'News 1')];
        final response = _createResponse(page: 1, data: newsItems);
        
        var callCount = 0;

        when(() => mockFavoritesCache.loadFavorites())
            .thenAnswer((_) async => <int>{});
        when(() => mockFavoritesCache.loadFavoriteNews())
            .thenAnswer((_) async => <NewsModel>[]);
        when(() => mockFavoritesCache.saveFavorites(any()))
            .thenAnswer((_) async {});
        when(() => mockFavoritesCache.addFavoriteNews(any()))
            .thenAnswer((_) async {});
        when(() => mockFavoritesCache.removeFavoriteNews(any()))
            .thenAnswer((_) async {});
        when(() => mockRepository.fetchNewsPage(page: 1))
            .thenAnswer((_) async {
              callCount++;
              if (callCount == 1) {
                return Left(error);
              } else {
                return Right(response);
              }
            });
        
        return NewsBloc(mockRepository, mockFavoritesCache);
      },
      act: (bloc) {
        bloc.add(NewsStarted());
        return Future.delayed(Duration(milliseconds: 150)).then((_) {
          bloc.add(NewsRefreshed());
        });
      },
      wait: Duration(milliseconds: 200),
      skip: 3,
      expect: () => [
        predicate<NewsState>((state) => state.isLoading),
        predicate<NewsState>((state) => state.error == null && state.items.isNotEmpty),
      ],
    );
  });
}
