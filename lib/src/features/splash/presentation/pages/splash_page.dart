import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nortus/src/core/di/app_injector.dart';
import 'package:nortus/src/core/themes/app_colors.dart';
import 'package:nortus/src/features/splash/presentation/controllers/splash_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final SplashController controller;

  @override
  void initState() {
    super.initState();
    controller = getIt<SplashController>();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    final route = await controller.resolveRoute();
    if (!mounted) return;
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Center(
        child: SvgPicture.asset(
          'assets/images/nortus_wordmark.svg',
          width: size.width * 0.45,
          colorFilter: const ColorFilter.mode(
            AppColors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
