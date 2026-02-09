import 'package:either_dart/either.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/core/storage/local_storage.dart';
import 'package:nortus/src/features/auth/data/datasources/auth_datasource.dart';
import 'package:nortus/src/features/auth/data/models/auth_model.dart';

class AuthRepository {
  final AuthDatasource datasource;
  final LocalStorage localStorage;
  static const Duration _requestDelay = Duration(seconds: 3);

  AuthRepository(this.datasource, this.localStorage);

  Future<Either<AppError, void>> login(
    AuthModel model, {
    bool keepLoggedIn = false,
  }) async {
    final result = await datasource.login(model);

    await Future.delayed(_requestDelay);

    if (result.isRight && keepLoggedIn) {
      try {
        await localStorage.setLoggedIn(true);
      } catch (e) {
        return Left(
          UnknownError('Ops! Aconteceu alguma coisa, tente novamente.'),
        );
      }
    }

    return result;
  }

  Future<Either<AppError, void>> register(AuthModel model) async {
    final result = await datasource.register(model);

    await Future.delayed(_requestDelay);

    return result;
  }

  Future<Either<AppError, void>> logout() async {
    try {
      await Future.delayed(_requestDelay);

      await localStorage.setLoggedIn(false);

      return Right(null);
    } catch (e) {
      return Left(
        UnknownError('Ops! Aconteceu alguma coisa, tente novamente.'),
      );
    }
  }

  Future<bool> isLoggedIn() async {
    return await localStorage.isLoggedIn();
  }
}
