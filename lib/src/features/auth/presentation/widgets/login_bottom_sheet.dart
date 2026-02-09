import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nortus/src/core/di/app_injector.dart';
import 'package:nortus/src/core/themes/app_colors.dart';
import 'package:nortus/src/core/utils/snackbar_helper.dart';
import 'package:nortus/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nortus/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:nortus/src/features/auth/presentation/bloc/auth_form_mode.dart';
import 'package:nortus/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:nortus/src/features/auth/presentation/widgets/auth_bottom_links.dart';
import 'package:nortus/src/features/auth/presentation/widgets/auth_mode_toggle.dart';
import 'package:nortus/src/features/auth/presentation/widgets/auth_submit_button.dart';
import 'package:nortus/src/features/auth/presentation/widgets/confirm_password_field.dart';
import 'package:nortus/src/features/auth/presentation/widgets/email_field.dart';
import 'package:nortus/src/features/auth/presentation/widgets/keep_logged_in_checkbox.dart';
import 'package:nortus/src/features/auth/presentation/widgets/password_field.dart';

class LoginBottomSheet extends StatelessWidget {
  const LoginBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: const _LoginBottomSheetContent(),
    );
  }
}

class _LoginBottomSheetContent extends StatelessWidget {
  const _LoginBottomSheetContent();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final minHeight = size.height * 0.4;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          SnackbarHelper.showError(context, state.errorMessage!);
        } else if (state.isRegistrationSuccess) {
          // Registration successful - show message and return to login mode
          SnackbarHelper.showSuccess(context, 'Conta criada com sucesso!');

          // Return to login mode after a brief delay
          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) {
              context.read<AuthBloc>().add(AuthModeChanged(AuthFormMode.login));
            }
          });
        } else if (state.isSuccess) {
          // Login successful - authenticate and navigate
          SnackbarHelper.showSuccess(context, 'Login realizado com sucesso!');
          context.go('/news');
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              constraints: BoxConstraints(minHeight: minHeight),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.primaryBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Form Container
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 24,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Email Field
                                  const EmailField(),
                                  const SizedBox(height: 16),

                                  // Password Field with animation
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (child, animation) {
                                      return SizeTransition(
                                        sizeFactor: animation,
                                        child: FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child:
                                        (state.mode == AuthFormMode.register ||
                                                state.showPasswordField)
                                            ? const Column(
                                              key: ValueKey('password-field'),
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                PasswordField(),
                                                SizedBox(height: 16),
                                              ],
                                            )
                                            : const SizedBox.shrink(
                                              key: ValueKey('no-password'),
                                            ),
                                  ),

                                  // Confirm Password Field with animation
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (child, animation) {
                                      return SizeTransition(
                                        sizeFactor: animation,
                                        child: FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child:
                                        (state.mode == AuthFormMode.register)
                                            ? const Column(
                                              key: ValueKey(
                                                'confirm-password-field',
                                              ),
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ConfirmPasswordField(),
                                                SizedBox(height: 16),
                                              ],
                                            )
                                            : const SizedBox.shrink(
                                              key: ValueKey(
                                                'no-confirm-password',
                                              ),
                                            ),
                                  ),

                                  // Keep Logged In Checkbox with animation
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (child, animation) {
                                      return SizeTransition(
                                        sizeFactor: animation,
                                        child: FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child:
                                        (state.mode == AuthFormMode.login &&
                                                state.showPasswordField)
                                            ? const Column(
                                              key: ValueKey('keep-logged-in'),
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                KeepLoggedInCheckbox(),
                                                SizedBox(height: 24),
                                              ],
                                            )
                                            : const SizedBox.shrink(
                                              key: ValueKey(
                                                'no-keep-logged-in',
                                              ),
                                            ),
                                  ),

                                  // Spacer for button spacing
                                  if (state.mode == AuthFormMode.register &&
                                      !state.isEmailValid)
                                    const SizedBox(height: 24),

                                  // Submit Button
                                  const AuthSubmitButton(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const AuthBottomLinks(),
                    ],
                  ),
                  Positioned(
                    top: -24,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SizedBox(
                        width: size.width * 0.85,
                        child: const AuthModeToggle(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
