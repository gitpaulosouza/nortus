import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nortus/src/features/news/data/models/news_details_model.dart';
import 'package:nortus/src/features/news/data/repositories/news_details_repository.dart';
import 'package:nortus/src/features/news/presentation/news_details_bloc/news_details_event.dart';
import 'package:nortus/src/features/news/presentation/news_details_bloc/news_details_state.dart';

class NewsDetailsBloc extends Bloc<NewsDetailsEvent, NewsDetailsState> {
  final NewsDetailsRepository repository;

  NewsDetailsBloc(this.repository) : super(NewsDetailsState.initial()) {
    on<NewsDetailsStarted>(_onNewsDetailsStarted);
    on<NewsDetailsRefreshed>(_onNewsDetailsRefreshed);
    on<NewsDetailsLoadMoreRequested>(_onNewsDetailsLoadMoreRequested);
  }

  Future<void> _onNewsDetailsStarted(
    NewsDetailsStarted event,
    Emitter<NewsDetailsState> emit,
  ) async {
    await _loadNewsDetails(event.newsId, emit);
  }

  Future<void> _onNewsDetailsRefreshed(
    NewsDetailsRefreshed event,
    Emitter<NewsDetailsState> emit,
  ) async {
    await _loadNewsDetails(event.newsId, emit);
  }

  Future<void> _onNewsDetailsLoadMoreRequested(
    NewsDetailsLoadMoreRequested event,
    Emitter<NewsDetailsState> emit,
  ) async {
    if (state.isLoading || state.isLoadingMore || state.hasReachedEnd || state.data == null) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true, clearError: true));

    final nextPage = state.currentPage == 0 ? 1 : state.currentPage + 1;

    final result = await repository.getNewsDetails(state.data!.id);

    result.fold(
      (error) {
        emit(state.copyWith(isLoadingMore: false, error: error));
      },
      (newsDetails) {
        final updatedRelatedNews = List<dynamic>.from(state.data!.relatedNews);
        updatedRelatedNews.addAll(newsDetails.relatedNews);

        final updatedData = NewsDetailsModel(
          id: state.data!.id,
          title: state.data!.title,
          image: state.data!.image,
          imageCaption: state.data!.imageCaption,
          categories: state.data!.categories,
          publishedAt: state.data!.publishedAt,
          newsResume: state.data!.newsResume,
          estimatedReadingTime: state.data!.estimatedReadingTime,
          authors: state.data!.authors,
          description: state.data!.description,
          contentImages: state.data!.contentImages,
          threeImageGrid: state.data!.threeImageGrid,
          videoPlaceholder: state.data!.videoPlaceholder,
          relatedNews: updatedRelatedNews.cast(),
          readAlso: state.data!.readAlso,
        );

        final hasReachedEnd = newsDetails.relatedNews.isEmpty;

        emit(
          state.copyWith(
            data: updatedData,
            currentPage: nextPage,
            hasReachedEnd: hasReachedEnd,
            isLoadingMore: false,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _loadNewsDetails(
    int newsId,
    Emitter<NewsDetailsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await repository.getNewsDetails(newsId);

    result.fold(
      (error) {
        emit(state.copyWith(isLoading: false, error: error));
      },
      (newsDetails) {
        emit(
          state.copyWith(
            data: newsDetails,
            isLoading: false,
            currentPage: 0,
            totalPages: 1,
            hasReachedEnd: newsDetails.relatedNews.length < 8,
            clearError: true,
          ),
        );
      },
    );
  }
}
