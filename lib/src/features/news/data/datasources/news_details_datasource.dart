import 'package:either_dart/either.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/news/data/models/news_details_model.dart';

abstract class NewsDetailsDatasource {
  Future<Either<AppError, NewsDetailsModel>> fetchNewsDetails(int newsId);
}
