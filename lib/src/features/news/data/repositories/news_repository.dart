import 'package:either_dart/either.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/news/data/datasources/news_datasource.dart';
import 'package:nortus/src/features/news/data/models/news_list_response_model.dart';
import 'package:nortus/src/features/news/mock/news_mock_factory.dart';

class NewsRepository {
  final NewsDatasource datasource;
  static const Duration _requestDelay = Duration(seconds: 3);

  NewsRepository(this.datasource);

  Future<Either<AppError, NewsListResponseModel>> fetchNewsPage({
    required int page,
  }) async {
    final result = await datasource.fetchNews(page: page);
    await Future.delayed(_requestDelay);

    return result.fold((error) {
      if (_shouldUseMock(error)) {
        return Right(NewsMockFactory.buildNewsListMock(page: page));
      }
      return Left(error);
    }, (response) => Right(response));
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
//depois voltar para false
    return true;
  }
}
