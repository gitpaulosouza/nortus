import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nortus/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nortus/src/features/auth/presentation/bloc/auth_event.dart';

class EmailField extends StatelessWidget {
  const EmailField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged:
          (value) => context.read<AuthBloc>().add(AuthEmailChanged(value)),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Digite seu E-mail',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
