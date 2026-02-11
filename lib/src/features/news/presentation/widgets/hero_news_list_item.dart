import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nortus/src/core/themes/app_colors.dart';
import 'package:nortus/src/features/news/data/models/news_model.dart';
import 'package:nortus/src/features/news/presentation/bloc/news_bloc.dart';
import 'package:nortus/src/features/news/presentation/bloc/news_event.dart';
import 'package:nortus/src/features/news/presentation/bloc/news_state.dart';
import 'package:nortus/src/features/news/presentation/widgets/nortus_cached_image.dart';

class HeroNewsListItem extends StatelessWidget {
  final NewsModel news;

  const HeroNewsListItem({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        final isFavorite = state.favoriteIds.contains(news.id);

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
                  Stack(
                    children: [
                      NortusCachedImage(
                        imageUrl: news.image.src,
                        aspectRatio: 16 / 9,
                        borderRadius: BorderRadius.circular(16),
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: GestureDetector(
                          onTap: () {
                            context.read<NewsBloc>().add(
                              NewsFavoriteToggled(news),
                            );
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.favoriteButtonBackground,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child:
                                  isFavorite
                                      ? SvgPicture.asset(
                                        'assets/icons/favorite-star-active.svg',
                                        width: 24,
                                        height: 24,
                                      )
                                      : SvgPicture.asset(
                                        'assets/icons/favorite-star.svg',
                                        width: 24,
                                        height: 24,
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
      },
    );
  }
}
