import 'package:flutter/material.dart';
import 'package:nortus/src/core/themes/app_colors.dart';

class AuthBottomLinks extends StatelessWidget {
  const AuthBottomLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {},
          child: const Text(
            'Esqueci a senha',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Continuar sem conta',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
