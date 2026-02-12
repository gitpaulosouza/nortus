import 'package:get_it/get_it.dart';
import 'package:nortus/src/features/news/data/cache/favorites_cache_service.dart';
import 'package:nortus/src/features/news/data/cache/news_cache_service.dart';
import 'package:nortus/src/features/news/data/datasources/news_datasource.dart';
import 'package:nortus/src/features/news/data/datasources/news_details_datasource.dart';
import 'package:nortus/src/features/news/data/repositories/news_details_repository.dart';
import 'package:nortus/src/features/news/data/repositories/news_repository.dart';
import 'package:nortus/src/features/news/presentation/bloc/news_bloc.dart';
import 'package:nortus/src/features/news/presentation/bloc_details/news_details_bloc.dart';

Future<void> configureNewsDependencies(GetIt getIt) async {
  getIt.registerLazySingleton<NewsDatasource>(
    () => NewsDatasourceImpl(getIt()),
  );

  getIt.registerLazySingleton<NewsCacheService>(() => NewsCacheService());

  getIt.registerLazySingleton<FavoritesCacheService>(
    () => FavoritesCacheService(),
  );

  getIt.registerLazySingleton<NewsDetailsDatasource>(
    () => NewsDetailsDatasourceImpl(getIt()),
  );

  getIt.registerLazySingleton<NewsRepository>(
    () => NewsRepository(getIt(), getIt()),
  );

  getIt.registerLazySingleton<NewsDetailsRepository>(
    () => NewsDetailsRepositoryImpl(getIt()),
  );

  getIt.registerFactory<NewsBloc>(() => NewsBloc(getIt(), getIt()));

  getIt.registerFactory<NewsDetailsBloc>(() => NewsDetailsBloc(getIt()));
}
