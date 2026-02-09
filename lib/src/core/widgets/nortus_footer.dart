import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nortus/src/core/themes/app_colors.dart';

class NortusFooter extends StatelessWidget {
  const NortusFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.bottomSheetBackground),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/images/nortus_wordmark.svg',
                height: 22,
                colorFilter: const ColorFilter.mode(
                  AppColors.appNameHighlight,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Copyright 2025 Nortus - Todos os Direitos Reservados',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: AppColors.copyrightText,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
