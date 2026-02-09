import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nortus/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nortus/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:nortus/src/features/auth/presentation/bloc/auth_state.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return TextField(
          onChanged:
              (value) =>
                  context.read<AuthBloc>().add(AuthPasswordChanged(value)),
          obscureText: !state.isPasswordVisible,
          decoration: InputDecoration(
            hintText: 'Digite a senha',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: IconButton(
              icon: Icon(
                state.isPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed:
                  () => context.read<AuthBloc>().add(
                    AuthTogglePasswordVisibility(),
                  ),
            ),
          ),
        );
      },
    );
  }
}
