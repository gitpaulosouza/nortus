import 'package:flutter/material.dart';
import 'package:nortus/src/core/di/app_injector.dart';
import 'package:nortus/src/core/routes/app_routes.dart';
import 'package:nortus/src/core/themes/app_theme.dart';

void main() async {
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nortus',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}

