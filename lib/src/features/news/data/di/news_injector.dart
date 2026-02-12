import 'package:get_it/get_it.dart';
import 'package:nortus/src/features/news/data/cache/favorites_cache_service.dart';
import 'package:nortus/src/features/news/data/cache/favorites_cache_service_impl.dart';
import 'package:nortus/src/features/news/data/cache/news_cache_service.dart';
import 'package:nortus/src/features/news/data/cache/news_cache_service_impl.dart';
import 'package:nortus/src/features/news/data/datasources/news_datasource.dart';
import 'package:nortus/src/features/news/data/datasources/news_datasource_impl.dart';
import 'package:nortus/src/features/news/data/datasources/news_details_datasource.dart';
import 'package:nortus/src/features/news/data/datasources/news_details_datasource_impl.dart';
import 'package:nortus/src/features/news/data/repositories/news_details_repository.dart';
import 'package:nortus/src/features/news/data/repositories/news_details_repository_impl.dart';
import 'package:nortus/src/features/news/data/repositories/news_repository.dart';
import 'package:nortus/src/features/news/presentation/news_bloc/news_bloc.dart';
import 'package:nortus/src/features/news/presentation/news_details_bloc/news_details_bloc.dart';

Future<void> configureNewsDependencies(GetIt getIt) async {
  getIt.registerFactory<NewsDatasource>(() => NewsDatasourceImpl(getIt()));

  getIt.registerLazySingleton<NewsCacheService>(() => NewsCacheServiceImpl());

  getIt.registerLazySingleton<FavoritesCacheService>(
    () => FavoritesCacheServiceImpl(),
  );

  getIt.registerFactory<NewsDetailsDatasource>(
    () => NewsDetailsDatasourceImpl(getIt()),
  );

  getIt.registerFactory<NewsRepository>(() => NewsRepository(getIt(), getIt()));

  getIt.registerFactory<NewsDetailsRepository>(
    () => NewsDetailsRepositoryImpl(getIt()),
  );

  getIt.registerFactory<NewsBloc>(() => NewsBloc(getIt(), getIt()));

  getIt.registerFactory<NewsDetailsBloc>(() => NewsDetailsBloc(getIt()));
}
