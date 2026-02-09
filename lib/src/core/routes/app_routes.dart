import 'package:go_router/go_router.dart';
import 'package:nortus/src/features/auth/presentation/pages/login_page.dart';
import 'package:nortus/src/features/home/presentation/pages/home_page.dart';
import 'package:nortus/src/features/splash/presentation/pages/splash_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);
