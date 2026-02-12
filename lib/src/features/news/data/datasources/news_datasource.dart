import 'package:either_dart/either.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/news/data/models/news_list_response_model.dart';

abstract class NewsDatasource {
  Future<Either<AppError, NewsListResponseModel>> fetchNews({
    required int page,
  });
}
