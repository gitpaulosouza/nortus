import 'package:get_it/get_it.dart';
import 'package:nortus/src/features/news/data/datasources/news_datasource.dart';
import 'package:nortus/src/features/news/data/repositories/news_repository.dart';
import 'package:nortus/src/features/news/presentation/bloc/news_bloc.dart';

Future<void> configureNewsDependencies(GetIt getIt) async {
  getIt.registerLazySingleton<NewsDatasource>(
    () => NewsDatasourceImpl(getIt()),
  );

  getIt.registerLazySingleton<NewsRepository>(() => NewsRepository(getIt()));

  getIt.registerFactory<NewsBloc>(() => NewsBloc(getIt()));
}
