import 'package:get_it/get_it.dart';
import 'package:nortus/src/core/storage/local_storage.dart';
import 'package:nortus/src/features/splash/presentation/bloc/splash_bloc.dart';

Future<void> configureSplashDependencies(GetIt getIt) async {
  getIt.registerFactory<SplashBloc>(
    () => SplashBloc(getIt<LocalStorage>()),
  );
}
