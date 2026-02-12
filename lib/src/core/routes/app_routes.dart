import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nortus/src/core/di/app_injector.dart';
import 'package:nortus/src/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:nortus/src/features/auth/presentation/pages/login_page.dart';
import 'package:nortus/src/features/news/presentation/news_bloc/news_bloc.dart';
import 'package:nortus/src/features/news/presentation/news_details_bloc/news_details_bloc.dart';
import 'package:nortus/src/features/news/presentation/pages/news_details_page.dart';
import 'package:nortus/src/features/news/presentation/pages/news_page.dart';
import 'package:nortus/src/features/splash/presentation/pages/splash_page.dart';
import 'package:nortus/src/features/user/presentation/user_bloc/user_bloc.dart';
import 'package:nortus/src/features/user/presentation/user_bloc/user_event.dart';
import 'package:nortus/src/features/user/presentation/pages/user_page.dart';
import 'package:nortus/src/features/user/presentation/pages/user_settings_page.dart';

class _NewsShellRoute extends StatelessWidget {
  final Widget child;

  const _NewsShellRoute({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<NewsBloc>(), child: child);
  }
}

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
    ShellRoute(
      builder: (context, state, child) => _NewsShellRoute(child: child),
      routes: [
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

            return BlocProvider(
              create: (_) => getIt<NewsDetailsBloc>(),
              child: NewsDetailsPage(newsId: newsId ?? 0),
            );
          },
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder:
              (context, state) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => getIt<UserBloc>()..add(const UserStarted()),
                  ),
                  BlocProvider(
                    create: (_) => getIt<AuthBloc>(),
                  ),
                ],
                child: const UserPage(),
              ),
        ),
      ],
    ),
    GoRoute(
      path: '/user-settings',
      name: 'userSettings',
      builder: (context, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => getIt<UserBloc>()..add(const UserStarted()),
            ),
            BlocProvider(
              create: (_) => getIt<AuthBloc>(),
            ),
          ],
          child: const UserSettingsPage(),
        );
      },
    ),
  ],
);
