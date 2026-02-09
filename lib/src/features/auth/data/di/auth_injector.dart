import 'package:get_it/get_it.dart';
import 'package:nortus/src/features/auth/data/datasources/auth_datasource.dart';
import 'package:nortus/src/features/auth/data/repositories/auth_repository.dart';
import 'package:nortus/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nortus/src/features/auth/presentation/controllers/auth_controller.dart';

Future<void> configureAuthDependencies(GetIt getIt) async {
  getIt.registerLazySingleton<AuthDatasource>(
    () => AuthDatasourceImpl(getIt()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt(), getIt()),
  );

  getIt.registerFactory<AuthController>(
    () => AuthController(getIt()),
  );

  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(getIt()),
  );
}
