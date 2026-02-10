import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/news/data/models/news_details_model.dart';

abstract class NewsDetailsDatasource {
  Future<Either<AppError, NewsDetailsModel>> fetchNewsDetails(int newsId);
}

class NewsDetailsDatasourceImpl implements NewsDetailsDatasource {
  final Dio dio;

  NewsDetailsDatasourceImpl(this.dio);

  @override
  Future<Either<AppError, NewsDetailsModel>> fetchNewsDetails(
    int newsId,
  ) async {
    if (newsId <= 0) {
      return Left(ValidationError('O ID da notícia deve ser maior que 0.'));
    }

    try {
      final response = await dio.get('/news/$newsId/details');

      if (response.statusCode != 200 || response.data == null) {
        return Left(NetworkError('Erro de rede. Tente novamente.'));
      }

      if (response.data is! Map<String, dynamic>) {
        return Left(UnknownError('Resposta inválida do servidor.'));
      }

      final newsDetailsModel = NewsDetailsModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return Right(newsDetailsModel);
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      return Left(NetworkError(errorMessage));
    } catch (e) {
      return Left(
        UnknownError('Ops! Aconteceu alguma coisa, tente novamente.'),
      );
    }
  }

  String _extractErrorMessage(DioException exception) {
    try {
      final responseData = exception.response?.data;

      if (responseData is Map<String, dynamic>) {
        final message = responseData['message'] as String?;
        if (message != null && message.isNotEmpty) {
          return message;
        }
      }

      if (exception.response?.data is String) {
        final bodyMessage = exception.response?.data as String;
        if (bodyMessage.contains('quota') ||
            bodyMessage.contains('exceeded') ||
            bodyMessage.contains('limite')) {
          return bodyMessage;
        }
      }
    } catch (_) {}

    return 'Erro de rede. Tente novamente.';
  }
}
