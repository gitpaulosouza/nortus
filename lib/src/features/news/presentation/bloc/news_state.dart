import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/news/data/models/news_model.dart';

class NewsState {
  final List<NewsModel> items;
  final int currentPage;
  final int totalPages;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final AppError? error;

  const NewsState({
    required this.items,
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
    int? currentPage,
    int? totalPages,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasReachedEnd,
    AppError? error,
    bool clearError = false,
  }) {
    return NewsState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
