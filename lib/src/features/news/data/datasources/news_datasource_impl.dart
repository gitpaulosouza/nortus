import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/news/data/datasources/news_datasource.dart';
import 'package:nortus/src/features/news/data/models/news_list_response_model.dart';

class NewsDatasourceImpl implements NewsDatasource {
  NewsDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<Either<AppError, NewsListResponseModel>> fetchNews({
    required int page,
  }) async {
    if (page <= 0) {
      return Left(ValidationError('A página deve ser maior que 0.'));
    }

    try {
      final response = await _dio.get('/news', queryParameters: {'page': page});

      final model = _parseNewsListResponse(response.data);
      return Right(model);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToAppError(e));
    } catch (_) {
      return Left(
        UnknownError('Ops! Aconteceu alguma coisa, tente novamente.'),
      );
    }
  }

  NewsListResponseModel _parseNewsListResponse(dynamic data) {
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid response format');
    }
    return NewsListResponseModel.fromJson(data);
  }

  AppError _mapDioExceptionToAppError(DioException e) {
    final message =
        _extractServerMessage(e) ?? 'Erro de rede. Tente novamente.';
    return NetworkError(message);
  }

  String? _extractServerMessage(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final errors = data['errors'];
      if (errors is List && errors.isNotEmpty) {
        final first = errors.first;
        if (first is String && first.trim().isNotEmpty) {
          return first.trim();
        }
      }
    }

    if (data is String && data.trim().isNotEmpty) {
      return data.trim();
    }

    return null;
  }
}
