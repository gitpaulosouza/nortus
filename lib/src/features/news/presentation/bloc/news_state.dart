import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/news/data/models/news_model.dart';

class NewsState {
  final List<NewsModel> items;
  final List<NewsModel> visibleItems;
  final String searchQuery;
  final String selectedCategory;
  final List<String> categories;
  final Set<int> favoriteIds;
  final int? lastFavoriteToggledId;
  final bool? lastFavoriteWasAdded;
  final int currentPage;
  final int totalPages;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final AppError? error;

  const NewsState({
    required this.items,
    required this.visibleItems,
    required this.searchQuery,
    required this.selectedCategory,
    required this.categories,
    required this.favoriteIds,
    this.lastFavoriteToggledId,
    this.lastFavoriteWasAdded,
    required this.currentPage,
    required this.totalPages,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasReachedEnd,
    required this.error,
  });

  factory NewsState.initial() {
    return const NewsState(
      items: [],
      visibleItems: [],
      searchQuery: '',
      selectedCategory: 'Todas as notícias',
      categories: ['Todas as notícias'],
      favoriteIds: {},
      lastFavoriteToggledId: null,
      lastFavoriteWasAdded: null,
      currentPage: 0,
      totalPages: 0,
      isLoading: false,
      isLoadingMore: false,
      hasReachedEnd: false,
      error: null,
    );
  }

  NewsState copyWith({
    List<NewsModel>? items,
    List<NewsModel>? visibleItems,
    String? searchQuery,
    String? selectedCategory,
    List<String>? categories,
    Set<int>? favoriteIds,
    int? lastFavoriteToggledId,
    bool? lastFavoriteWasAdded,
    int? currentPage,
    int? totalPages,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasReachedEnd,
    AppError? error,
    bool clearError = false,
    bool clearFavoriteFeedback = false,
  }) {
    return NewsState(
      items: items ?? this.items,
      visibleItems: visibleItems ?? this.visibleItems,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      lastFavoriteToggledId:
          clearFavoriteFeedback
              ? null
              : (lastFavoriteToggledId ?? this.lastFavoriteToggledId),
      lastFavoriteWasAdded:
          clearFavoriteFeedback
              ? null
              : (lastFavoriteWasAdded ?? this.lastFavoriteWasAdded),
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      error: clearError ? null : (error ?? this.error),
    );
  }

  List<NewsModel> get favoriteItems {
    return items.where((news) => favoriteIds.contains(news.id)).toList();
  }
}
