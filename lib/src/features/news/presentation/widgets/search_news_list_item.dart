import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nortus/src/core/themes/app_colors.dart';
import 'package:nortus/src/features/news/data/models/news_model.dart';
import 'package:nortus/src/features/news/presentation/widgets/nortus_cached_image.dart';

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
              NortusCachedImage(
                imageUrl: news.image.src,
                aspectRatio: 19 / 9,
                borderRadius: BorderRadius.circular(16),
                fit: BoxFit.cover,
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
