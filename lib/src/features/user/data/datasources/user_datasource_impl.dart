import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/user/data/datasources/user_datasource.dart';
import 'package:nortus/src/features/user/data/models/user_list_response_model.dart';
import 'package:nortus/src/features/user/data/models/user_model.dart';
import 'package:nortus/src/features/user/data/models/user_response_model.dart';
import 'package:nortus/src/features/user/mock/user_mock_factory.dart';

class UserDatasourceImpl implements UserDatasource {
  final Dio dio;

  UserDatasourceImpl(this.dio);

  @override
  Future<Either<AppError, UserModel>> getUser() async {
    try {
      final response = await dio.get('/user');

      if (response.statusCode != 200) {
        if (_shouldUseMock(response.data)) {
          return Right(UserMockFactory.createMockUser());
        }
        return Left(NetworkError('Erro de rede. Tente novamente.'));
      }

      if (response.data is List) {
        final listResponse = UserListResponseModel.fromJson(response.data);

        if (listResponse.isEmpty) {
          return Left(UnknownError('Lista de usuários vazia.'));
        }

        return Right(listResponse.firstOrNull!);
      }

      return Left(UnknownError('Resposta inválida do servidor.'));
    } on DioException catch (error) {
      if (_shouldUseMock(error.response?.data ?? error.message)) {
        return Right(UserMockFactory.createMockUser());
      }
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
        if (_shouldUseMock(response.data)) {
          return Right(UserMockFactory.createMockUser());
        }
        return Left(NetworkError('Erro de rede. Tente novamente.'));
      }

      if (response.statusCode == 204) {
        return Right(model);
      }

      if (response.data == null || response.data is! Map<String, dynamic>) {
        if (_shouldUseMock(response.data)) {
          return Right(UserMockFactory.createMockUser());
        }
        return Left(UnknownError('Resposta inválida do servidor.'));
      }

      final userResponse = UserResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      return Right(userResponse.data);
    } on DioException catch (error) {
      if (_shouldUseMock(error.response?.data ?? error.message)) {
        return Right(UserMockFactory.createMockUser());
      }
      return Left(NetworkError('Erro de rede. Tente novamente.'));
    } catch (_) {
      return Left(
        UnknownError('Ops! Aconteceu alguma coisa, tente novamente.'),
      );
    }
  }

  bool _shouldUseMock(Object? value) {
    final message = value?.toString().toLowerCase() ?? '';
    return message.contains('quota') ||
        message.contains('exceeded') ||
        message.contains('limite');
  }
}
