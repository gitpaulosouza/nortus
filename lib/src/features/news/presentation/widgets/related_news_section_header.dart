import 'package:flutter/material.dart';
import 'package:nortus/src/core/themes/app_colors.dart';

class RelatedNewsSectionHeader extends StatelessWidget {
  const RelatedNewsSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
          decoration: BoxDecoration(
            color: AppColors.mostRecentSectionBackground,
            border: Border.all(
              color: AppColors.mostRecentSectionMarker,
              width: 1,
            ),
          ),
          child: Text(
            'Notícias Relacionadas',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.mostRecentButtonBorder,
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: -6,
          bottom: -6,
          child: Container(width: 1, color: AppColors.mostRecentSectionMarker),
        ),
        Positioned(
          right: 0,
          top: -6,
          bottom: -6,
          child: Container(width: 1, color: AppColors.mostRecentSectionMarker),
        ),
      ],
    );
  }
}
