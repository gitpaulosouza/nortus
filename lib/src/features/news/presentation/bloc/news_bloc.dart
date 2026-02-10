import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nortus/src/features/news/data/models/news_model.dart';
import 'package:nortus/src/features/news/data/repositories/news_repository.dart';
import 'package:nortus/src/features/news/presentation/bloc/news_event.dart';
import 'package:nortus/src/features/news/presentation/bloc/news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository repository;

  NewsBloc(this.repository) : super(NewsState.initial()) {
    on<NewsStarted>(_onNewsStarted);
    on<NewsLoadMoreRequested>(_onNewsLoadMoreRequested);
    on<NewsRefreshed>(_onNewsRefreshed);
    on<NewsSearchQueryChanged>(_onNewsSearchQueryChanged);
    on<NewsFavoriteToggled>(_onNewsFavoriteToggled);
    on<NewsFavoriteFeedbackConsumed>(_onNewsFavoriteFeedbackConsumed);
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

        final visibleItems = _applyFilter(updatedItems, state.searchQuery);

        emit(
          state.copyWith(
            items: updatedItems,
            visibleItems: visibleItems,
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

  void _onNewsSearchQueryChanged(
    NewsSearchQueryChanged event,
    Emitter<NewsState> emit,
  ) {
    final normalizedQuery = _normalizeQuery(event.query);
    final visibleItems = _applyFilter(state.items, normalizedQuery);

    emit(
      state.copyWith(searchQuery: normalizedQuery, visibleItems: visibleItems),
    );
  }

  Future<void> _loadFirstPage(Emitter<NewsState> emit) async {
    emit(
      state.copyWith(
        items: [],
        visibleItems: [],
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

        final visibleItems = _applyFilter(response.data, state.searchQuery);

        emit(
          state.copyWith(
            items: response.data,
            visibleItems: visibleItems,
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

  String _normalizeQuery(String query) {
    return _normalizeText(query);
  }

  String _normalizeText(String text) {
    var normalized = text.trim().toLowerCase();

    const withDiacritics =
        'áàâãäåāăąǎǻảạắằẳẵặấầẩẫậéèêëēĕėęěẻẽẹếềểễệíìîïīĭįıỉĩịóòôõöōŏőøǿỏọốồổỗộớờởỡợúùûüūŭůűųưủũụứừửữựýỳŷÿȳỷỹỵćĉċčďđĝğġģĥħĵķĺļľŀłńņňŉŋŕŗřśŝşšţťŧẁẃŵẅỳýŷÿźżž';
    const withoutDiacritics =
        'aaaaaaaaaaaaaaaaaaaaaaaaaaaeeeeeeeeeeeeeeeeeeeiiiiiiiiiiiiiooooooooooooooooooooooouuuuuuuuuuuuuuuuuuuuyyyyyyyyycccccddgggghhhjklllllllnnnnnrrrsssstttwwwwyyyyzzzz';

    for (var i = 0; i < withDiacritics.length; i++) {
      normalized = normalized.replaceAll(
        withDiacritics[i],
        withoutDiacritics[i],
      );
    }

    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ');

    return normalized;
  }

  List<NewsModel> _applyFilter(List<NewsModel> items, String query) {
    if (query.isEmpty) {
      return items;
    }

    return items.where((news) {
      final normalizedTitle = _normalizeText(news.title);
      final normalizedSummary = _normalizeText(news.summary);
      final normalizedCategories =
          news.categories.map((c) => _normalizeText(c)).toList();

      if (normalizedTitle.contains(query)) {
        return true;
      }

      if (normalizedSummary.contains(query)) {
        return true;
      }

      for (final category in normalizedCategories) {
        if (category.contains(query)) {
          return true;
        }
      }

      return false;
    }).toList();
  }

  void _onNewsFavoriteToggled(
    NewsFavoriteToggled event,
    Emitter<NewsState> emit,
  ) {
    final newsId = event.news.id;
    final updatedFavorites = Set<int>.from(state.favoriteIds);

    if (updatedFavorites.contains(newsId)) {
      updatedFavorites.remove(newsId);
    } else {
      updatedFavorites.add(newsId);
    }

    final wasAdded = updatedFavorites.contains(newsId);

    emit(
      state.copyWith(
        favoriteIds: updatedFavorites,
        lastFavoriteToggledId: newsId,
        lastFavoriteWasAdded: wasAdded,
      ),
    );
  }

  void _onNewsFavoriteFeedbackConsumed(
    NewsFavoriteFeedbackConsumed event,
    Emitter<NewsState> emit,
  ) {
    emit(state.copyWith(clearFavoriteFeedback: true));
  }
}
