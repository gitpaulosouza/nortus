import 'package:either_dart/either.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/core/http/http_client.dart';
import 'package:nortus/src/core/http/http_exception.dart';
import 'package:nortus/src/features/news/data/datasources/news_details_datasource.dart';
import 'package:nortus/src/features/news/data/models/news_details_model.dart';
import 'package:nortus/src/features/news/mock/news_details_mock_factory.dart';

class NewsDetailsDatasourceImpl implements NewsDetailsDatasource {
  final HttpClient httpClient;

  NewsDetailsDatasourceImpl(this.httpClient);

  @override
  Future<Either<AppError, NewsDetailsModel>> fetchNewsDetails(
    int newsId,
  ) async {
    if (newsId <= 0) {
      return Left(ValidationError('O ID da notícia deve ser maior que 0.'));
    }

    try {
      final response = await httpClient.get('/news/$newsId');

      if (response.statusCode != 200 || response.data == null) {
        if (_shouldUseMock(response.data)) {
          return Right(NewsDetailsMockFactory.buildMock(newsId: newsId));
        }
        return Left(NetworkError('Erro de rede. Tente novamente.'));
      }

      if (response.data is! Map<String, dynamic>) {
        if (_shouldUseMock(response.data)) {
          return Right(NewsDetailsMockFactory.buildMock(newsId: newsId));
        }
        return Left(UnknownError('Resposta inválida do servidor.'));
      }

      final newsDetailsModel = NewsDetailsModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return Right(newsDetailsModel);
    } on HttpException catch (e) {
      if (_shouldUseMock(e.data ?? e.message)) {
        return Right(NewsDetailsMockFactory.buildMock(newsId: newsId));
      }
      final errorMessage = _extractErrorMessage(e);
      return Left(NetworkError(errorMessage));
    } catch (e) {
      return Left(
        UnknownError('Ops! Aconteceu alguma coisa, tente novamente.'),
      );
    }
  }

  bool _shouldUseMock(Object? value) {
    final message = value?.toString().toLowerCase() ?? '';
    return message.contains('quota') ||
        message.contains('exceeded') ||
        message.contains('limite') ||
        message.contains('wiremock');
  }

  String _extractErrorMessage(HttpException exception) {
    try {
      final responseData = exception.data;

      if (responseData is Map<String, dynamic>) {
        final message = responseData['message'] as String?;
        if (message != null && message.isNotEmpty) {
          return message;
        }
      }

      if (exception.data is String) {
        final bodyMessage = exception.data as String;
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
