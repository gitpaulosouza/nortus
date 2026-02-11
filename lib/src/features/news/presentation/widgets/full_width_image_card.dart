import 'package:flutter/material.dart';
import 'package:nortus/src/core/themes/app_colors.dart';
import 'package:nortus/src/features/news/presentation/widgets/nortus_cached_image.dart';

class FullWidthImageCard extends StatelessWidget {
  final String imageUrl;
  final String caption;

  const FullWidthImageCard({
    super.key,
    required this.imageUrl,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NortusCachedImage(
          imageUrl: imageUrl,
          width: double.infinity,
          height: 300,
          borderRadius: BorderRadius.circular(12),
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
