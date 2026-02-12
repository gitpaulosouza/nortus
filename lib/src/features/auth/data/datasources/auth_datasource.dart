import 'package:either_dart/either.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/auth/data/models/auth_model.dart';

abstract class AuthDatasource {
  Future<Either<AppError, void>> login(AuthModel model);

  Future<Either<AppError, void>> register(AuthModel model);
}
