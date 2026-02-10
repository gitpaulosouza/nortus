import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nortus/src/features/news/data/repositories/news_details_repository.dart';
import 'package:nortus/src/features/news/presentation/bloc_details/news_details_event.dart';
import 'package:nortus/src/features/news/presentation/bloc_details/news_details_state.dart';

class NewsDetailsBloc extends Bloc<NewsDetailsEvent, NewsDetailsState> {
  final NewsDetailsRepository repository;

  NewsDetailsBloc(this.repository) : super(NewsDetailsState.initial()) {
    on<NewsDetailsStarted>(_onNewsDetailsStarted);
    on<NewsDetailsRefreshed>(_onNewsDetailsRefreshed);
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
          state.copyWith(data: newsDetails, isLoading: false, clearError: true),
        );
      },
    );
  }
}
