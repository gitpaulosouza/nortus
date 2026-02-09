import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nortus/src/core/themes/app_colors.dart';

class LoadMoreButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const LoadMoreButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBackground,
          disabledForegroundColor: AppColors.primaryBackground.withValues(
            alpha: 0.5,
          ),
          side: BorderSide(
            color:
                isLoading
                    ? AppColors.mostRecentButtonBorder.withValues(alpha: 0.5)
                    : AppColors.mostRecentButtonBorder,
            width: 1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ver mais',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color:
                    isLoading
                        ? AppColors.newsTitleText.withValues(alpha: 0.5)
                        : AppColors.newsTitleText,
              ),
            ),
            const SizedBox(width: 8),
            if (isLoading)
              const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryBackground,
                  ),
                ),
              )
            else
              Transform.rotate(
                angle: 1.5708,
                child: SvgPicture.asset(
                  'assets/icons/arrow.svg',
                  width: 12,
                  height: 12,
                  colorFilter: const ColorFilter.mode(
                    AppColors.newsTitleText,
                    BlendMode.srcIn,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
