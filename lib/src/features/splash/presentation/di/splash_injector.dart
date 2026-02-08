import 'package:get_it/get_it.dart';
import 'package:nortus/src/core/storage/local_storage.dart';
import 'package:nortus/src/features/splash/presentation/controllers/splash_controller.dart';

Future<void> configureSplashDependencies(GetIt getIt) async {
  getIt.registerFactory<SplashController>(
    () => SplashController(getIt<LocalStorage>()),
  );
}
