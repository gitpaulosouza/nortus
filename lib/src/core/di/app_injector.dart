import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nortus/src/core/dio/dio_client.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<Dio>(DioClient().dio);

  _setupNewsModule();
  _setupProfileModule();
}

void _setupNewsModule() {
}

void _setupProfileModule() {
}
