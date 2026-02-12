import 'package:either_dart/either.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/news/data/datasources/news_details_datasource.dart';
import 'package:nortus/src/features/news/data/models/news_details_model.dart';
import 'package:nortus/src/features/news/data/repositories/news_details_repository.dart';
import 'package:nortus/src/features/news/mock/news_details_mock_factory.dart';

class NewsDetailsRepositoryImpl implements NewsDetailsRepository {
  final NewsDetailsDatasource datasource;
  static const Duration _requestDelay = Duration(seconds: 2);

  NewsDetailsRepositoryImpl(this.datasource);

  @override
  Future<Either<AppError, NewsDetailsModel>> getNewsDetails(int newsId) async {
    final result = await datasource.fetchNewsDetails(newsId);
    await Future.delayed(_requestDelay);
    return result.fold((error) {
      if (_shouldUseMock(error)) {
        return Right(
          NewsDetailsMockFactory.buildMock(newsId: newsId),
        );
      }
      return Left(error);
    }, (response) => Right(response));
  }

  bool _shouldUseMock(AppError error) {
    final message = error.message.toLowerCase();

    return message.contains('monthly request quota') ||
        message.contains('quota exceeded') ||
        message.contains('limite') ||
        message.contains('wiremock');
  }
}
