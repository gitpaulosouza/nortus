import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nortus/src/core/di/app_injector.dart';
import 'package:nortus/src/core/storage/local_storage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final localStorage = getIt<LocalStorage>();
              await localStorage.setLoggedIn(false);
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome to Nortus!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
