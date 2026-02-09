import 'package:either_dart/either.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/user/data/datasources/user_datasource.dart';
import 'package:nortus/src/features/user/data/models/user_model.dart';
import 'package:nortus/src/features/user/mock/user_mock_factory.dart';

abstract class UserRepository {
  Future<Either<AppError, UserModel>> getUser();
  Future<Either<AppError, UserModel>> updateUser(UserModel model);
}

class UserRepositoryImpl implements UserRepository {
  final UserDatasource datasource;

  UserRepositoryImpl(this.datasource);

  @override
  Future<Either<AppError, UserModel>> getUser() async {
    final result = await datasource.getUser();

    return result.fold((error) {
      if (_shouldUseMock(error)) {
        return Right(UserMockFactory.createMockUser());
      }
      return Left(error);
    }, (user) => Right(user));
  }

  @override
  Future<Either<AppError, UserModel>> updateUser(UserModel model) async {
    final result = await datasource.updateUser(model);

    return result.fold((error) {
      return Left(error);
    }, (user) => Right(user));
  }

  bool _shouldUseMock(AppError error) {
    if (error is NetworkError) {
      final message = error.message.toLowerCase();
      if (message.contains('quota') ||
          message.contains('exceeded') ||
          message.contains('limite')) {
        return true;
      }
      return true;
    }
    return false;
  }
}
