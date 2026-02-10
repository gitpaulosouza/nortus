import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nortus/src/core/themes/app_colors.dart';
import 'package:nortus/src/features/news/data/models/news_model.dart';

class SearchNewsListItem extends StatelessWidget {
  final NewsModel news;

  const SearchNewsListItem({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            'newsDetails',
            pathParameters: {'newsId': news.id.toString()},
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.image.src.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 19 / 9,
                  child: Image.network(
                    news.image.src,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: AppColors.bottomSheetBackground,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.bottomSheetBackground,
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 48,
                            color: AppColors.copyrightText,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (news.categories.isNotEmpty)
                    Text(
                      news.categories.first.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.newsCategoryText,
                      ),
                    ),
                  if (news.categories.isNotEmpty) const SizedBox(height: 8),
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      color: AppColors.newsTitleText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    news.summary,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textParagraph,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '12 horas atrás',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.newsTimeText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
