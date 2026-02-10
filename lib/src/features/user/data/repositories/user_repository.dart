import 'package:either_dart/either.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/user/data/datasources/user_datasource.dart';
import 'package:nortus/src/features/user/data/models/user_model.dart';

abstract class UserRepository {
  Future<Either<AppError, UserModel>> getUser();
  Future<Either<AppError, UserModel>> updateUser(UserModel model);
}

class UserRepositoryImpl implements UserRepository {
  final UserDatasource datasource;
  static const Duration _requestDelay = Duration(seconds: 3);

  UserRepositoryImpl(this.datasource);

  @override
  Future<Either<AppError, UserModel>> getUser() async {
    final result = await datasource.getUser();
    await Future.delayed(_requestDelay);
    return result;
  }

  @override
  Future<Either<AppError, UserModel>> updateUser(UserModel model) async {
    final result = await datasource.updateUser(model);
    await Future.delayed(_requestDelay);
    return result;
  }
}
