import 'package:either_dart/either.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/news/data/cache/news_cache_service.dart';
import 'package:nortus/src/features/news/data/datasources/news_datasource.dart';
import 'package:nortus/src/features/news/data/models/news_list_response_model.dart';
import 'package:nortus/src/features/news/mock/news_mock_factory.dart';

class NewsRepository {
  final NewsDatasource datasource;
  final NewsCacheService cacheService;
  static const Duration _requestDelay = Duration(seconds: 3);

  NewsRepository(this.datasource, this.cacheService);

  Future<Either<AppError, NewsListResponseModel>> fetchNewsPage({
    required int page,
  }) async {
    final result = await datasource.fetchNews(page: page);
    await Future.delayed(_requestDelay);

    return await result.fold<Future<Either<AppError, NewsListResponseModel>>>(
      (error) async {
        if (_shouldTryCache(error)) {
          final cachedJson = await cacheService.getPage(page);
          if (cachedJson != null) {
            final cachedResponse = NewsListResponseModel.fromJson(cachedJson);
            return Right(cachedResponse);
          }
        }

        if (_shouldUseMock(error)) {
          return Right(NewsMockFactory.buildNewsListMock(page: page));
        }

        return Left(error);
      },
      (response) async {
        await cacheService.savePage(page, response.toJson());
        return Right(response);
      },
    );
  }

  bool _shouldUseMock(AppError error) {
    final message = error.message.toLowerCase();

    if (message.contains('monthly request quota') ||
        message.contains('quota exceeded')) {
      return true;
    }

    if (error is NetworkError && message.contains('404')) {
      return true;
    }
    return false;
  }

  bool _shouldTryCache(AppError error) {
    final message = error.message.toLowerCase();

    final isQuotaError =
        message.contains('monthly request quota') ||
        message.contains('quota') ||
        message.contains('exceeded') ||
        message.contains('limite');

    final isTimeoutError =
        message.contains('timeout') ||
        message.contains('timed out') ||
        message.contains('tempo limite');

    final isNetworkError =
        message.contains('rede') || message.contains('network');

    return isQuotaError || isTimeoutError || isNetworkError;
  }
}
