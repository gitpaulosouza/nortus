import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nortus/src/core/di/app_injector.dart';
import 'package:nortus/src/core/themes/app_colors.dart';
import 'package:nortus/src/features/splash/presentation/splash_bloc/splash_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SplashBloc>()..add(SplashStarted()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state.nextRoute != null) {
            context.go(state.nextRoute!);
          }
        },
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
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
