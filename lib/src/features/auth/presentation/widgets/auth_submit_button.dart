import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nortus/src/core/themes/app_colors.dart';
import 'package:nortus/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nortus/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:nortus/src/features/auth/presentation/bloc/auth_form_mode.dart';
import 'package:nortus/src/features/auth/presentation/bloc/auth_state.dart';

class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        late bool isEnabled;

        if (state.mode == AuthFormMode.login) {
          isEnabled =
              state.showPasswordField
                  ? (state.isEmailValid && state.isPasswordValid)
                  : state.isEmailValid;
        } else {
          isEnabled = state.canSubmit;
        }

        return ElevatedButton(
          onPressed:
              isEnabled && !state.isSubmitting
                  ? () {
                    FocusScope.of(context).unfocus();
                    context.read<AuthBloc>().add(AuthSubmitRequested());
                  }
                  : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child:
              state.isSubmitting
                  ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.white,
                      ),
                      strokeWidth: 2,
                    ),
                  )
                  : Text(
                    state.mode == AuthFormMode.login
                        ? 'Entrar'
                        : 'Cadastrar-se',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
        );
      },
    );
  }
}
