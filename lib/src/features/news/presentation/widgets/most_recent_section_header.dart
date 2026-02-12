import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nortus/src/core/themes/app_colors.dart';

class MostRecentSectionHeader extends StatelessWidget {
  final VoidCallback? onViewMorePressed;
  final ScrollController? scrollController;

  const MostRecentSectionHeader({
    super.key,
    this.onViewMorePressed,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.mostRecentSectionBackground,
            border: Border.all(
              color: AppColors.mostRecentSectionMarker,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mais recentes',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.mostRecentButtonBorder,
                ),
              ),
              OutlinedButton(
                onPressed: _handleViewMorePressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryBackground,
                  side: const BorderSide(
                    color: AppColors.mostRecentButtonBorder,
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Ver mais',
                      style: TextStyle(
                        color: AppColors.newsTitleText,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      'assets/icons/arrow.svg',
                      width: 8,
                      height: 8,
                      colorFilter: const ColorFilter.mode(
                        AppColors.newsTitleText,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

  void _handleViewMorePressed() {
    if (scrollController != null) {
      scrollController!.animateTo(
        scrollController!.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    if (onViewMorePressed != null) {
      onViewMorePressed!();
    }
  }
}
