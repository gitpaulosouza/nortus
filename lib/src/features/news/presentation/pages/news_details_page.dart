import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nortus/src/core/themes/app_colors.dart';
import 'package:nortus/src/core/widgets/nortus_nav_item.dart';
import 'package:nortus/src/core/widgets/nortus_scaffold.dart';
import 'package:nortus/src/features/news/presentation/bloc_details/news_details_bloc.dart';
import 'package:nortus/src/features/news/presentation/bloc_details/news_details_event.dart';
import 'package:nortus/src/features/news/presentation/bloc_details/news_details_state.dart';
import 'package:nortus/src/features/news/presentation/bloc/news_bloc.dart';
import 'package:nortus/src/features/news/presentation/bloc/news_event.dart';
import 'package:nortus/src/features/news/presentation/bloc/news_state.dart';
import 'package:nortus/src/features/news/presentation/widgets/load_more_button.dart';
import 'package:nortus/src/features/news/presentation/widgets/news_resume_card.dart';
import 'package:nortus/src/features/news/presentation/widgets/related_news_section_header.dart';
import 'package:nortus/src/features/news/presentation/widgets/grid_news_list_item.dart';
import 'package:nortus/src/features/news/presentation/widgets/full_width_image_card.dart';
import 'package:nortus/src/features/news/presentation/widgets/three_image_grid_card.dart';
import 'package:nortus/src/features/news/presentation/widgets/video_placeholder_image_card.dart';
import 'package:nortus/src/features/news/data/models/news_model.dart';
import 'package:nortus/src/features/news/data/models/news_image_model.dart';

class NewsDetailsPage extends StatefulWidget {
  final int newsId;

  const NewsDetailsPage({super.key, required this.newsId});

  @override
  State<NewsDetailsPage> createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NewsDetailsBloc>().add(NewsDetailsStarted(widget.newsId));
  }

  @override
  Widget build(BuildContext context) {
    return NortusScaffold(
      activeItem: NortusNavItem.news,
      body: BlocBuilder<NewsDetailsBloc, NewsDetailsState>(
        builder: (context, state) {
          if (state.isLoading && state.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null && state.data == null) {
            return _buildErrorState(context);
          }

          if (state.data == null) {
            return const SizedBox.shrink();
          }

          return _buildContent(context, state);
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.dangerRed,
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar notícia',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () {
                context.read<NewsDetailsBloc>().add(
                  NewsDetailsRefreshed(widget.newsId),
                );
              },
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, NewsDetailsState state) {
    final data = state.data!;
    final formattedDate = _formatDateTime(data.publishedAt);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: InkWell(
                onTap: () => context.pop(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/arrow-left.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        AppColors.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Voltar',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (data.categories.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.categoryChipBackground,
                          border: Border.all(
                            color: AppColors.categoryChipBorder,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          data.categories.first,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.categoryText,
                          ),
                        ),
                      ),
                    _buildFavoriteButton(context, data.id),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.newsTitleDark,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Publicado: $formattedDate',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.newsTitleText,
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(data.image.src),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              data.imageCaption,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textParagraph,
              ),
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: NewsResumeCard(resumeText: data.newsResume),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              data.description,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.descriptionText,
                height: 1.8,
              ),
            ),
          ),

          const SizedBox(height: 32),

          if (data.contentImages.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children:
                    data.contentImages
                        .map(
                          (contentImage) => Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: FullWidthImageCard(
                              imageUrl: contentImage.imageUrl,
                              caption: contentImage.caption,
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                data.description,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.descriptionText,
                  height: 1.8,
                ),
              ),
            ),
          ],

          if (data.threeImageGrid != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ThreeImageGridCard(
                    topImageUrl: data.threeImageGrid!.topImageUrl,
                    bottomLeftImageUrl: data.threeImageGrid!.bottomLeftImageUrl,
                    bottomRightImageUrl:
                        data.threeImageGrid!.bottomRightImageUrl,
                    caption: data.threeImageGrid!.caption,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                data.description,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.descriptionText,
                  height: 1.8,
                ),
              ),
            ),
          ],

          if (data.videoPlaceholder != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  VideoPlaceholderImageCard(
                    imageUrl: data.videoPlaceholder!.imageUrl,
                    caption: data.videoPlaceholder!.caption,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                data.description,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.descriptionText,
                  height: 1.8,
                ),
              ),
            ),
          ],

          if (data.categories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    data.categories
                        .map(
                          (category) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.categoryChipBackground,
                              border: Border.all(
                                color: AppColors.categoryChipBorder,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              category,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.categoryText,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          const SizedBox(height: 32),
          if (data.relatedNews.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: RelatedNewsSectionHeader(),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemCount:
                    data.relatedNews.length > 8 ? 8 : data.relatedNews.length,
                itemBuilder: (context, index) {
                  final relatedNews = data.relatedNews[index];
                  final newsModel = NewsModel(
                    id: relatedNews.id,
                    title: relatedNews.title,
                    image: NewsImageModel(
                      src: relatedNews.imageUrl,
                      alt: relatedNews.title,
                    ),
                    categories: relatedNews.categories,
                    publishedAt: relatedNews.publishedAt,
                    summary: '',
                    authors: relatedNews.authors,
                  );
                  return GridNewsListItem(news: newsModel);
                },
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: LoadMoreButton(
                onPressed: () {
                  context.read<NewsDetailsBloc>().add(
                    const NewsDetailsLoadMoreRequested(),
                  );
                },
                isLoading: state.isLoadingMore,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context, int newsId) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, newsState) {
        final isFavorite = newsState.favoriteIds.contains(newsId);

        return Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.favoriteButtonBackground,
            shape: BoxShape.circle,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                final data = context.read<NewsDetailsBloc>().state.data;
                if (data != null) {
                  final newsModel = NewsModel(
                    id: data.id,
                    title: data.title,
                    image: data.image,
                    categories: data.categories,
                    publishedAt: data.publishedAt,
                    summary: data.newsResume,
                    authors: data.authors,
                  );
                  context.read<NewsBloc>().add(NewsFavoriteToggled(newsModel));
                }
              },
              customBorder: const CircleBorder(),
              child: SvgPicture.asset(
                isFavorite
                    ? 'assets/icons/favorite-star-active.svg'
                    : 'assets/icons/favorite-star.svg',
                width: 20,
                height: 20,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    try {
      final local = dateTime.toLocal();
      final day = local.day.toString().padLeft(2, '0');
      final month = local.month.toString().padLeft(2, '0');
      final year = local.year;
      final hour = local.hour.toString().padLeft(2, '0');
      final minute = local.minute.toString().padLeft(2, '0');
      return '$day/$month/$year às $hour:$minute';
    } catch (_) {
      return 'Data indisponível';
    }
  }
}
