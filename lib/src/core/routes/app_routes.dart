import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nortus/src/core/di/app_injector.dart';
import 'package:nortus/src/features/auth/presentation/pages/login_page.dart';
import 'package:nortus/src/features/news/presentation/bloc/news_bloc.dart';
import 'package:nortus/src/features/news/presentation/pages/news_page.dart';
import 'package:nortus/src/features/splash/presentation/pages/splash_page.dart';
import 'package:nortus/src/features/user/presentation/bloc/user_bloc.dart';
import 'package:nortus/src/features/user/presentation/bloc/user_event.dart';
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
      builder:
          (context, state) => BlocProvider(
            create: (_) => getIt<NewsBloc>(),
            child: const NewsPage(),
          ),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder:
          (context, state) => BlocProvider(
            create: (_) => getIt<UserBloc>()..add(const UserStarted()),
            child: const UserPage(),
          ),
    ),
    GoRoute(
      path: '/user-settings',
      name: 'userSettings',
      builder: (context, state) {
        // Reuse the same UserBloc instance if passed, otherwise create new
        final userBloc = state.extra as UserBloc?;
        if (userBloc != null) {
          return BlocProvider.value(
            value: userBloc,
            child: const UserSettingsPage(),
          );
        }
        return BlocProvider(
          create: (_) => getIt<UserBloc>()..add(const UserStarted()),
          child: const UserSettingsPage(),
        );
      },
    ),
  ],
);
