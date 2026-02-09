import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nortus/src/core/themes/app_colors.dart';
import 'package:nortus/src/core/utils/date_formatter.dart';
import 'package:nortus/src/features/news/data/models/news_model.dart';

class GridNewsListItem extends StatefulWidget {
  final NewsModel news;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const GridNewsListItem({
    super.key,
    required this.news,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  State<GridNewsListItem> createState() => _GridNewsListItemState();
}

class _GridNewsListItemState extends State<GridNewsListItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Navigate to news detail page
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with favorite button
          Stack(
            children: [
              // Image
              if (widget.news.image.src.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.network(
                      widget.news.image.src,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: AppColors.bottomSheetBackground,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.bottomSheetBackground,
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 32,
                              color: AppColors.copyrightText,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              else
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Container(color: AppColors.bottomSheetBackground),
                ),
              // Favorite button
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: widget.onFavoriteToggle,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.favoriteButtonBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/favorite-star.svg',
                        width: 20,
                        height: 20,
                        colorFilter:
                            widget.isFavorite
                                ? const ColorFilter.mode(
                                  AppColors.primaryBackground,
                                  BlendMode.srcIn,
                                )
                                : null,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Content
          const SizedBox(height: 12),
          // Category
          if (widget.news.categories.isNotEmpty)
            Text(
              widget.news.categories.first.toUpperCase(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.newsCategoryText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          if (widget.news.categories.isNotEmpty) const SizedBox(height: 6),
          // Title
          Text(
            widget.news.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.3,
              color: AppColors.newsTitleText,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          // Time
          Text(
            formatRelativeTime(widget.news.publishedAt),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.newsTimeText,
            ),
          ),
        ],
      ),
    );
  }
}
