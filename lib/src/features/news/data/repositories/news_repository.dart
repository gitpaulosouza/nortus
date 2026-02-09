import 'package:either_dart/either.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/news/data/datasources/news_datasource.dart';
import 'package:nortus/src/features/news/data/models/news_list_response_model.dart';

class NewsRepository {
  final NewsDatasource datasource;
  static const Duration _requestDelay = Duration(seconds: 3);

  NewsRepository(this.datasource);

  Future<Either<AppError, NewsListResponseModel>> fetchNewsPage({
    required int page,
  }) async {
    final result = await datasource.fetchNews(page: page);
    await Future.delayed(_requestDelay);
    return result;
  }
}
