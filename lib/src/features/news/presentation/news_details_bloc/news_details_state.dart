import 'package:equatable/equatable.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/news/data/models/news_details_model.dart';

class NewsDetailsState extends Equatable {
  final NewsDetailsModel? data;
  final bool isLoading;
  final bool isLoadingMore;
  final int currentPage;
  final int totalPages;
  final bool hasReachedEnd;
  final AppError? error;

  const NewsDetailsState({
    this.data,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.currentPage = 0,
    this.totalPages = 0,
    this.hasReachedEnd = false,
    this.error,
  });

  factory NewsDetailsState.initial() {
    return const NewsDetailsState();
  }

  NewsDetailsState copyWith({
    NewsDetailsModel? data,
    bool? isLoading,
    bool? isLoadingMore,
    int? currentPage,
    int? totalPages,
    bool? hasReachedEnd,
    AppError? error,
    bool clearError = false,
  }) {
    return NewsDetailsState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
        data,
        isLoading,
        isLoadingMore,
        currentPage,
        totalPages,
        hasReachedEnd,
        error,
      ];
}
