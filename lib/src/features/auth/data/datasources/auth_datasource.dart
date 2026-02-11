import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/auth/data/models/auth_model.dart';

abstract class AuthDatasource {
  Future<Either<AppError, void>> login(AuthModel model);

  Future<Either<AppError, void>> register(AuthModel model);
}

class AuthDatasourceImpl implements AuthDatasource {
  final Dio _dio;

  static const String _validLogin = 'desafioLoomi';
  static const String _validPassword = 'senha123';

  AuthDatasourceImpl(this._dio);

  bool _isQuotaExceededError(dynamic error) {
    if (error is DioException) {
      final responseData = error.response?.data;
      if (responseData != null) {
        final dataString = responseData.toString();
        if (dataString.contains('Monthly request quota has been exceeded')) {
          return true;
        }
      }

      final statusCode = error.response?.statusCode;
      if (statusCode == 404 || statusCode == null || statusCode >= 500) {
        return true;
      }
    }
    return false;
  }

  bool _areValidCredentials(AuthModel model) {
    return model.login == _validLogin && model.password == _validPassword;
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

      final message = data['message'] as String?;
      if (message != null && message.trim().isNotEmpty) {
        return message.trim();
      }
    }

    if (data is String && data.trim().isNotEmpty) {
      return data.trim();
    }

    return null;
  }

  @override
  Future<Either<AppError, void>> login(AuthModel model) async {
    try {
      await _dio.post('/auth', data: model.toJson());
      return Right(null);
    } on DioException catch (e) {
      if (_isQuotaExceededError(e)) {
        if (_areValidCredentials(model)) {
          return Right(null);
        }

        return Left(_mapDioExceptionToAppError(e));
      }

      if (e.response?.statusCode == 401) {
        return Left(ValidationError('Credenciais inválidas'));
      }

      return Left(_mapDioExceptionToAppError(e));
    } catch (e) {
      return Left(
        UnknownError('Ops! Aconteceu alguma coisa, tente novamente.'),
      );
    }
  }

  @override
  Future<Either<AppError, void>> register(AuthModel model) async {
    if (model.login.isEmpty || model.password.isEmpty) {
      return Left(ValidationError('Dados de cadastro inválidos'));
    }
    return Right(null);
  }
}
