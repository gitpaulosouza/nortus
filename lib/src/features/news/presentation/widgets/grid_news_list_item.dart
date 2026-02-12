import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nortus/src/core/themes/app_colors.dart';
import 'package:nortus/src/core/utils/date_formatter.dart';
import 'package:nortus/src/features/news/data/models/news_model.dart';
import 'package:nortus/src/features/news/presentation/news_bloc/news_bloc.dart';
import 'package:nortus/src/features/news/presentation/news_bloc/news_event.dart';
import 'package:nortus/src/features/news/presentation/news_bloc/news_state.dart';
import 'package:nortus/src/features/news/presentation/widgets/nortus_cached_image.dart';

class GridNewsListItem extends StatelessWidget {
  final NewsModel news;

  const GridNewsListItem({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        final isFavorite = state.favoriteIds.contains(news.id);

        return InkWell(
          onTap: () {
            context.pushNamed(
              'newsDetails',
              pathParameters: {'newsId': news.id.toString()},
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  if (news.image.src.isNotEmpty)
                    NortusCachedImage(
                      imageUrl: news.image.src,
                      aspectRatio: 4 / 3,
                      borderRadius: BorderRadius.circular(12),
                      fit: BoxFit.cover,
                    )
                  else
                    AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Container(color: AppColors.bottomSheetBackground),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        context.read<NewsBloc>().add(NewsFavoriteToggled(news));
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.favoriteButtonBackground,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child:
                              isFavorite
                                  ? SvgPicture.asset(
                                    'assets/icons/favorite-star-active.svg',
                                    width: 20,
                                    height: 20,
                                  )
                                  : SvgPicture.asset(
                                    'assets/icons/favorite-star.svg',
                                    width: 20,
                                    height: 20,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (news.categories.isNotEmpty)
                Text(
                  news.categories.first.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.newsCategoryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              if (news.categories.isNotEmpty) const SizedBox(height: 6),
              Text(
                news.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                  color: AppColors.newsTitleText,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                formatRelativeTime(news.publishedAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColors.newsTimeText,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
