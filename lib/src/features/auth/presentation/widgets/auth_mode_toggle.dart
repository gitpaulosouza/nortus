import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nortus/src/core/themes/app_colors.dart';
import 'package:nortus/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:nortus/src/features/auth/presentation/bloc/auth_form_mode.dart';
import 'package:nortus/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:nortus/src/features/auth/presentation/bloc/auth_bloc.dart';

class AuthModeToggle extends StatelessWidget {
  const AuthModeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) => previous.mode != current.mode,
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final indicatorWidth = constraints.maxWidth / 2;
            final isLogin = state.mode == AuthFormMode.login;

            return Container(
              height: 50,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(999),
              
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    left: isLogin ? 0 : indicatorWidth - 12,
                    top: 0,
                    bottom: 0,
                    width: indicatorWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.read<AuthBloc>().add(
                                AuthModeChanged(AuthFormMode.login),
                              ),
                          child: Container(
                            color: Colors.transparent,
                            child: Center(
                              child: Text(
                                'Acessar conta',
                                style: TextStyle(
                                  color: isLogin ? AppColors.white : AppColors.newsTitleText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.read<AuthBloc>().add(
                                AuthModeChanged(AuthFormMode.register),
                              ),
                          child: Container(
                            color: Colors.transparent,
                            child: Center(
                              child: Text(
                                'Não tenho conta',
                                style: TextStyle(
                                  color: !isLogin ? AppColors.white : AppColors.newsTitleText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
