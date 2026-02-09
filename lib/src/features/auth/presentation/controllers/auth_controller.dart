import 'package:either_dart/either.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/auth/data/models/auth_model.dart';
import 'package:nortus/src/features/auth/data/repositories/auth_repository.dart';

class AuthController {
  final AuthRepository repository;

  AuthController(this.repository);

  Future<Either<AppError, void>> login(AuthModel model) async {
    return await repository.login(model);
  }

  Future<Either<AppError, void>> logout() async {
    return await repository.logout();
  }
}
