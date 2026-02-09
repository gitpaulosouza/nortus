import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nortus/src/core/themes/app_colors.dart';
import 'package:nortus/src/features/auth/presentation/widgets/login_bottom_sheet.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Stack(
              children: [
                Positioned(
                  top: size.height * 0.10,
                  right: -size.width * 0.43,
                  child: Opacity(
                    opacity: 0.1,
                    child: Image.asset(
                      'assets/images/nortus_logo.png',
                      width: size.width * 1.5,
                      fit: BoxFit.contain,
                      color: AppColors.bottomSheetBackground,
                      colorBlendMode: BlendMode.srcIn,
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * 0.15,
                  left: 24,
                  child: SvgPicture.asset(
                    'assets/images/nortus_wordmark.svg',
                    width: 140,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const LoginBottomSheet(),
        ],
      ),
    );
  }
}
