import 'package:nortus/src/core/storage/local_storage.dart';

class SplashController {
  final LocalStorage localStorage;

  SplashController(this.localStorage);

  Future<String> resolveRoute() async {
    await Future.delayed(const Duration(seconds: 3));
    final isLoggedIn = await localStorage.isLoggedIn();
    return isLoggedIn ? '/news' : '/login';
  }
}
