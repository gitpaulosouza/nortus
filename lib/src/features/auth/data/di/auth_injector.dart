import 'package:get_it/get_it.dart';
import 'package:nortus/src/features/auth/data/datasources/auth_datasource.dart';
import 'package:nortus/src/features/auth/data/datasources/auth_datasource_impl.dart';
import 'package:nortus/src/features/auth/data/repositories/auth_repository.dart';
import 'package:nortus/src/features/auth/presentation/auth_bloc/auth_bloc.dart';

Future<void> configureAuthDependencies(GetIt getIt) async {
  getIt.registerFactory<AuthDatasource>(() => AuthDatasourceImpl(getIt()));

  getIt.registerFactory<AuthRepository>(() => AuthRepository(getIt(), getIt()));

  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt()));
}
