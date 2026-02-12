import 'package:go_router/go_router.dart';
import 'package:nortus/src/features/auth/presentation/pages/login_page.dart';
import 'package:nortus/src/features/news/presentation/pages/news_details_page.dart';
import 'package:nortus/src/features/news/presentation/pages/news_page.dart';
import 'package:nortus/src/features/splash/presentation/pages/splash_page.dart';
import 'package:nortus/src/features/user/presentation/pages/user_page.dart';
import 'package:nortus/src/features/user/presentation/pages/user_settings_page.dart';

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
      path: '/news',
      name: 'news',
      builder: (context, state) => const NewsPage(),
    ),
    GoRoute(
      path: '/news/:newsId',
      name: 'newsDetails',
      builder: (context, state) {
        final newsId = int.tryParse(state.pathParameters['newsId'] ?? '');
        return NewsDetailsPage(newsId: newsId ?? 0);
      },
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const UserPage(),
    ),
    GoRoute(
      path: '/user-settings',
      name: 'userSettings',
      builder: (context, state) => const UserSettingsPage(),
    ),
  ],
);
