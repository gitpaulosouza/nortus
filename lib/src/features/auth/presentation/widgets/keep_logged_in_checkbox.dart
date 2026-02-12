import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nortus/src/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:nortus/src/features/auth/presentation/auth_bloc/auth_event.dart';
import 'package:nortus/src/features/auth/presentation/auth_bloc/auth_state.dart';

class KeepLoggedInCheckbox extends StatelessWidget {
  const KeepLoggedInCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Transform.translate(
          offset: const Offset(-12, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                value: state.keepLoggedIn,
                onChanged:
                    (_) =>
                        context.read<AuthBloc>().add(AuthToggleKeepLoggedIn()),
              ),
              const Text('Mantenha-me conectado'),
            ],
          ),
        );
      },
    );
  }
}
