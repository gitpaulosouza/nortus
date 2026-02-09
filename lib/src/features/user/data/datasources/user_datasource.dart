import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/user/data/models/user_model.dart';
import 'package:nortus/src/features/user/data/models/user_response_model.dart';

abstract class UserDatasource {
  Future<Either<AppError, UserModel>> getUser();
  Future<Either<AppError, UserModel>> updateUser(UserModel model);
}

class UserDatasourceImpl implements UserDatasource {
  final Dio dio;

  UserDatasourceImpl(this.dio);

  @override
  Future<Either<AppError, UserModel>> getUser() async {
    try {
      final response = await dio.get('/user');

      if (response.statusCode != 200) {
        return Left(NetworkError('Erro de rede. Tente novamente.'));
      }

      if (response.data == null || response.data is! Map<String, dynamic>) {
        return Left(UnknownError('Resposta inválida do servidor.'));
      }

      final userResponse = UserResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      return Right(userResponse.data);
    } on DioException catch (_) {
      return Left(NetworkError('Erro de rede. Tente novamente.'));
    } catch (_) {
      return Left(
        UnknownError('Ops! Aconteceu alguma coisa, tente novamente.'),
      );
    }
  }

  @override
  Future<Either<AppError, UserModel>> updateUser(UserModel model) async {
    try {
      final response = await dio.patch('/user', data: model.toJson());

      if (response.statusCode != 200 && response.statusCode != 204) {
        return Left(NetworkError('Erro de rede. Tente novamente.'));
      }

      if (response.statusCode == 204) {
        return Right(model);
      }

      if (response.data == null || response.data is! Map<String, dynamic>) {
        return Left(UnknownError('Resposta inválida do servidor.'));
      }

      final userResponse = UserResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      return Right(userResponse.data);
    } on DioException catch (_) {
      return Left(NetworkError('Erro de rede. Tente novamente.'));
    } catch (_) {
      return Left(
        UnknownError('Ops! Aconteceu alguma coisa, tente novamente.'),
      );
    }
  }
}
