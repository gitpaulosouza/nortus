import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nortus/src/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:nortus/src/features/auth/presentation/auth_bloc/auth_event.dart';
import 'package:nortus/src/features/auth/presentation/auth_bloc/auth_state.dart';

class ConfirmPasswordField extends StatelessWidget {
  const ConfirmPasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return TextField(
          onChanged:
              (value) => context.read<AuthBloc>().add(
                AuthConfirmPasswordChanged(value),
              ),
          obscureText: !state.isConfirmPasswordVisible,
          decoration: InputDecoration(
            hintText: 'Confirme a senha',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: IconButton(
              icon: Icon(
                state.isConfirmPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed:
                  () => context.read<AuthBloc>().add(
                    AuthToggleConfirmPasswordVisibility(),
                  ),
            ),
          ),
        );
      },
    );
  }
}
