import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/news/data/models/news_list_response_model.dart';

abstract class NewsDatasource {
  Future<Either<AppError, NewsListResponseModel>> fetchNews({
    required int page,
  });
}

class NewsDatasourceImpl implements NewsDatasource {
  final Dio dio;

  NewsDatasourceImpl(this.dio);

  @override
  Future<Either<AppError, NewsListResponseModel>> fetchNews({
    required int page,
  }) async {
    if (page <= 0) {
      return Left(ValidationError('A página deve ser maior que 0.'));
    }

    try {
      final response = await dio.get('/news', queryParameters: {'page': page});

      if (response.statusCode != 200 || response.data == null) {
        return Left(NetworkError('Erro de rede. Tente novamente.'));
      }

      final responseModel = NewsListResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return Right(responseModel);
    } on DioException catch (e) {
      // Try to extract error message from response
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

      // Check if response data contains error message
      if (responseData is Map<String, dynamic>) {
        final message = responseData['message'] as String?;
        if (message != null && message.isNotEmpty) {
          return message;
        }
      }

      // Check if response body is a string (WireMock quota message)
      if (exception.response?.data is String) {
        final bodyMessage = exception.response?.data as String;
        if (bodyMessage.contains('Monthly request quota') ||
            bodyMessage.contains('quota')) {
          return bodyMessage;
        }
      }
    } catch (_) {
      // If parsing fails, use generic message
    }

    return 'Erro de rede. Tente novamente.';
  }
}
