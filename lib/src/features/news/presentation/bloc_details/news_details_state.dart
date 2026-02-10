import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/news/data/models/news_details_model.dart';

class NewsDetailsState {
  final NewsDetailsModel? data;
  final bool isLoading;
  final AppError? error;

  const NewsDetailsState({this.data, this.isLoading = false, this.error});

  factory NewsDetailsState.initial() {
    return const NewsDetailsState();
  }

  NewsDetailsState copyWith({
    NewsDetailsModel? data,
    bool? isLoading,
    AppError? error,
    bool clearError = false,
  }) {
    return NewsDetailsState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
