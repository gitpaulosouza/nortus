import 'package:flutter/material.dart';
import 'package:nortus/src/core/themes/app_colors.dart';

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
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
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
