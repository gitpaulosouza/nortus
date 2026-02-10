import 'package:get_it/get_it.dart';
import 'package:nortus/src/features/user/data/datasources/user_datasource.dart';
import 'package:nortus/src/features/user/data/repositories/user_repository.dart';
import 'package:nortus/src/features/user/presentation/bloc/user_bloc.dart';

Future<void> configureUserDependencies(GetIt getIt) async {
  getIt.registerLazySingleton<UserDatasource>(
    () => UserDatasourceImpl(getIt()),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt()),
  );

  getIt.registerFactory<UserBloc>(() => UserBloc(getIt()));
}
