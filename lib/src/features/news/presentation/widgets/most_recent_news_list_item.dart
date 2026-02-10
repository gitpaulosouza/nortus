import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nortus/src/core/themes/app_colors.dart';
import 'package:nortus/src/core/utils/date_formatter.dart';
import 'package:nortus/src/features/news/data/models/news_model.dart';

class MostRecentNewsListItem extends StatelessWidget {
  final NewsModel news;

  const MostRecentNewsListItem({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: InkWell(
            onTap: () {
              context.pushNamed(
                'newsDetails',
                pathParameters: {'newsId': news.id.toString()},
              );
            },
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child:
                        news.image.src.isNotEmpty
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: AspectRatio(
                                aspectRatio: 1.57,
                                child: Image.network(
                                  news.image.src,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: AppColors.bottomSheetBackground,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: AppColors.bottomSheetBackground,
                                      child: const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 24,
                                          color: AppColors.copyrightText,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                            : AspectRatio(
                              aspectRatio: 173 / 110,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.bottomSheetBackground,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (news.categories.isNotEmpty)
                          Text(
                            news.categories.first.toUpperCase(),
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.newsCategoryText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        else
                          const SizedBox.shrink(),
                        Text(
                          news.title,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                            color: AppColors.newsTitleText,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          formatRelativeTime(news.publishedAt),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
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
          ),
        ),
        const Divider(
          height: 24,
          thickness: 2,
          color: AppColors.mostRecentSectionMarker,
        ),
      ],
    );
  }
}
