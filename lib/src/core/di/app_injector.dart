import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nortus/src/core/dio/dio_client.dart';
import 'package:nortus/src/core/storage/local_storage.dart';
import 'package:nortus/src/features/splash/presentation/di/splash_injector.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerSingleton<Dio>(DioClient().dio);
  getIt.registerLazySingleton<LocalStorage>(() => LocalStorageImpl());

  await configureSplashDependencies(getIt);
}
