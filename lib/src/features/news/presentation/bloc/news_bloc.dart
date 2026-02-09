import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nortus/src/features/news/data/repositories/news_repository.dart';
import 'package:nortus/src/features/news/presentation/bloc/news_event.dart';
import 'package:nortus/src/features/news/presentation/bloc/news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository repository;

  NewsBloc(this.repository) : super(NewsState.initial()) {
    on<NewsStarted>(_onNewsStarted);
    on<NewsLoadMoreRequested>(_onNewsLoadMoreRequested);
    on<NewsRefreshed>(_onNewsRefreshed);
  }

  Future<void> _onNewsStarted(
    NewsStarted event,
    Emitter<NewsState> emit,
  ) async {
    await _loadFirstPage(emit);
  }

  Future<void> _onNewsLoadMoreRequested(
    NewsLoadMoreRequested event,
    Emitter<NewsState> emit,
  ) async {
    if (state.isLoading || state.isLoadingMore || state.hasReachedEnd) return;

    final nextPage = state.currentPage == 0 ? 1 : state.currentPage + 1;

    emit(state.copyWith(isLoadingMore: true, clearError: true));

    final result = await repository.fetchNewsPage(page: nextPage);

    result.fold(
      (error) {
        emit(state.copyWith(isLoadingMore: false, error: error));
      },
      (response) {
        final updatedItems = List.of(state.items)..addAll(response.data);
        final updatedCurrentPage = response.pagination.page;
        final updatedTotalPages = response.pagination.totalPages;
        final hasReachedEnd =
            updatedTotalPages > 0
                ? updatedCurrentPage >= updatedTotalPages
                : response.data.isEmpty;

        emit(
          state.copyWith(
            items: updatedItems,
            currentPage: updatedCurrentPage,
            totalPages: updatedTotalPages,
            hasReachedEnd: hasReachedEnd,
            isLoadingMore: false,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _onNewsRefreshed(
    NewsRefreshed event,
    Emitter<NewsState> emit,
  ) async {
    await _loadFirstPage(emit);
  }

  Future<void> _loadFirstPage(Emitter<NewsState> emit) async {
    emit(
      state.copyWith(
        items: [],
        currentPage: 0,
        totalPages: 0,
        hasReachedEnd: false,
        isLoading: true,
        isLoadingMore: false,
        clearError: true,
      ),
    );

    final result = await repository.fetchNewsPage(page: 1);

    result.fold(
      (error) {
        emit(
          state.copyWith(isLoading: false, isLoadingMore: false, error: error),
        );
      },
      (response) {
        final totalPages = response.pagination.totalPages;
        final currentPage = response.pagination.page;
        final hasReachedEnd =
            totalPages > 0 ? currentPage >= totalPages : response.data.isEmpty;
        emit(
          state.copyWith(
            items: response.data,
            currentPage: currentPage,
            totalPages: totalPages,
            hasReachedEnd: hasReachedEnd,
            isLoading: false,
            isLoadingMore: false,
            clearError: true,
          ),
        );
      },
    );
  }
}
