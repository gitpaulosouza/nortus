import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nortus/src/core/themes/app_colors.dart';
import 'package:nortus/src/core/widgets/animated_gradient_border.dart';


class NewsResumeCard extends StatefulWidget {
  final String resumeText;

  const NewsResumeCard({super.key, required this.resumeText});

  @override
  State<NewsResumeCard> createState() => _NewsResumeCardState();
}

class _NewsResumeCardState extends State<NewsResumeCard> {
  @override
  Widget build(BuildContext context) {
    return AnimatedGradientBorder(
      gradientColors: [
        AppColors.primaryColor,
        AppColors.resumeCardBackground,
      ],
      borderRadius: BorderRadius.circular(12),
      animationDuration: 3,
      borderWidth: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/ai-stars.svg',
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Resumo NortusAI',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.resumeCardText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.resumeText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.resumeCardText,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
