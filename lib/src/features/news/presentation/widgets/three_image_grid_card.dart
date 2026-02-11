import 'package:flutter/material.dart';
import 'package:nortus/src/core/themes/app_colors.dart';
import 'package:nortus/src/features/news/presentation/widgets/nortus_cached_image.dart';

class ThreeImageGridCard extends StatelessWidget {
  final String topImageUrl;
  final String bottomLeftImageUrl;
  final String bottomRightImageUrl;
  final String caption;

  const ThreeImageGridCard({
    super.key,
    required this.topImageUrl,
    required this.bottomLeftImageUrl,
    required this.bottomRightImageUrl,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            NortusCachedImage(
              imageUrl: topImageUrl,
              width: double.infinity,
              height: 200,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: NortusCachedImage(
                    imageUrl: bottomLeftImageUrl,
                    height: 150,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NortusCachedImage(
                    imageUrl: bottomRightImageUrl,
                    height: 150,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          caption,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.textParagraph,
          ),
        ),
      ],
    );
  }
}
