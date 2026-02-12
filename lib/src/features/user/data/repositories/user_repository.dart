import 'package:either_dart/either.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/user/data/models/user_model.dart';

abstract class UserRepository {
  Future<Either<AppError, UserModel>> getUser();
  Future<Either<AppError, UserModel>> updateUser(UserModel model);
}
