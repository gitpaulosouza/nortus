import 'package:either_dart/either.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/news/data/datasources/news_details_datasource.dart';
import 'package:nortus/src/features/news/data/models/news_details_model.dart';

abstract class NewsDetailsRepository {
  Future<Either<AppError, NewsDetailsModel>> getNewsDetails(int newsId);
}

class NewsDetailsRepositoryImpl implements NewsDetailsRepository {
  final NewsDetailsDatasource datasource;
  static const Duration _requestDelay = Duration(seconds: 2);

  NewsDetailsRepositoryImpl(this.datasource);

  @override
  Future<Either<AppError, NewsDetailsModel>> getNewsDetails(int newsId) async {
    final result = await datasource.fetchNewsDetails(newsId);
    await Future.delayed(_requestDelay);
    return result;
  }
}
