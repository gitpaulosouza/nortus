import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/news/data/models/news_details_model.dart';
import 'package:nortus/src/features/news/data/models/news_image_model.dart';
import 'package:nortus/src/features/news/data/repositories/news_details_repository.dart';
import 'package:nortus/src/features/news/presentation/news_details_bloc/news_details_bloc.dart';
import 'package:nortus/src/features/news/presentation/news_details_bloc/news_details_event.dart';
import 'package:nortus/src/features/news/presentation/news_details_bloc/news_details_state.dart';

class MockNewsDetailsRepository extends Mock implements NewsDetailsRepository {}

void main() {
  late MockNewsDetailsRepository mockRepository;
  late NewsDetailsBloc bloc;

  setUp(() {
    mockRepository = MockNewsDetailsRepository();
    bloc = NewsDetailsBloc(mockRepository);
  });

  group('NewsDetailsBloc', () {
    final mockNewsDetails = NewsDetailsModel(
      id: 1,
      title: 'Test News',
      image: const NewsImageModel(src: 'test.jpg', alt: 'Test'),
      imageCaption: 'Caption',
      categories: const ['Tech'],
      publishedAt: DateTime.parse('2024-01-01T12:00:00Z'),
      newsResume: 'Resume',
      estimatedReadingTime: '5 min',
      authors: const [],
      description: 'Description',
      relatedNews: const [],
    );

    test('estado inicial deve estar correto', () {
      expect(bloc.state, NewsDetailsState.initial());
      expect(bloc.state.isLoading, false);
      expect(bloc.state.data, null);
    });

    blocTest<NewsDetailsBloc, NewsDetailsState>(
      'deve carregar news details com sucesso',
      build: () {
        when(() => mockRepository.getNewsDetails(1))
            .thenAnswer((_) async => Right(mockNewsDetails));
        return NewsDetailsBloc(mockRepository);
      },
      act: (bloc) => bloc.add(const NewsDetailsStarted(1)),
      expect: () => [
        NewsDetailsState.initial().copyWith(isLoading: true),
        NewsDetailsState.initial().copyWith(
          data: mockNewsDetails,
          isLoading: false,
          currentPage: 0,
          totalPages: 1,
          hasReachedEnd: true,
        ),
      ],
    );

    blocTest<NewsDetailsBloc, NewsDetailsState>(
      'deve lidar com erro ao carregar news details',
      build: () {
        when(() => mockRepository.getNewsDetails(1))
            .thenAnswer((_) async => Left(NetworkError('Erro de rede')));
        return NewsDetailsBloc(mockRepository);
      },
      act: (bloc) => bloc.add(const NewsDetailsStarted(1)),
      expect: () => [
        NewsDetailsState.initial().copyWith(isLoading: true),
        NewsDetailsState.initial().copyWith(
          isLoading: false,
          error: NetworkError('Erro de rede'),
        ),
      ],
    );

    blocTest<NewsDetailsBloc, NewsDetailsState>(
      'deve fazer refresh dos news details',
      build: () {
        when(() => mockRepository.getNewsDetails(1))
            .thenAnswer((_) async => Right(mockNewsDetails));
        return NewsDetailsBloc(mockRepository);
      },
      act: (bloc) => bloc.add(const NewsDetailsRefreshed(1)),
      expect: () => [
        NewsDetailsState.initial().copyWith(isLoading: true),
        NewsDetailsState.initial().copyWith(
          data: mockNewsDetails,
          isLoading: false,
          currentPage: 0,
          totalPages: 1,
          hasReachedEnd: true,
        ),
      ],
    );
  });
}
