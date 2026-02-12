import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nortus/src/core/utils/snackbar_helper.dart';
import 'package:nortus/src/core/themes/app_colors.dart';
import 'package:nortus/src/core/widgets/nortus_nav_item.dart';
import 'package:nortus/src/core/widgets/nortus_scaffold.dart';
import 'package:nortus/src/features/news/presentation/news_bloc/news_bloc.dart';
import 'package:nortus/src/features/news/presentation/news_bloc/news_event.dart';
import 'package:nortus/src/features/news/presentation/news_bloc/news_state.dart';
import 'package:nortus/src/features/news/presentation/widgets/grid_news_list_item.dart';
import 'package:nortus/src/features/news/presentation/widgets/hero_news_list_item.dart';
import 'package:nortus/src/features/news/presentation/widgets/most_recent_news_list_item.dart';
import 'package:nortus/src/features/news/presentation/widgets/most_recent_section_header.dart';
import 'package:nortus/src/features/news/presentation/widgets/load_more_button.dart';
import 'package:nortus/src/features/news/presentation/widgets/news_search_bar.dart';
import 'package:nortus/src/features/news/presentation/widgets/search_news_list_item.dart';
import 'package:nortus/src/features/news/presentation/widgets/news_category_menu.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late final ScrollController _scrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    context.read<NewsBloc>().add(const NewsStarted());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onLoadMorePressed() {
    context.read<NewsBloc>().add(const NewsLoadMoreRequested());
  }

  void _openCategoryMenu() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const NewsCategoryMenu(),
      body: NortusScaffold(
        activeItem: NortusNavItem.news,
        body: BlocConsumer<NewsBloc, NewsState>(
          listener: (context, state) {
            if (state.lastFavoriteToggledId != null &&
                state.lastFavoriteWasAdded != null) {
              if (state.lastFavoriteWasAdded!) {
                SnackbarHelper.showSuccess(
                  context,
                  'Você favoritou esta notícia',
                  subtitle: 'Você pode encontrá-la no perfil',
                );
              } else {
                SnackbarHelper.showSuccess(
                  context,
                  'Você removeu esta notícia dos favoritos',
                  subtitle: 'Ela não aparece mais no perfil',
                );
              }
              context.read<NewsBloc>().add(
                const NewsFavoriteFeedbackConsumed(),
              );
            }

            if (state.error != null && state.items.isNotEmpty) {
              SnackbarHelper.showError(
                context,
                'Erro ao carregar notícias',
                subtitle: state.error!.message,
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading && state.items.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.items.isEmpty && state.error != null) {
              return _buildEmptyErrorState(context);
            }

            final isSearchActive = state.searchQuery.isNotEmpty;
            final displayItems = state.visibleItems;

            return Column(
              children: [
                NewsSearchBar(onMenuPressed: _openCategoryMenu),
                Expanded(
                  child:
                      isSearchActive
                          ? _buildSearchResults(context, state)
                          : _buildDefaultContent(context, state, displayItems),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDefaultContent(
    BuildContext context,
    NewsState state,
    List displayItems,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<NewsBloc>().add(const NewsRefreshed());
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          ...displayItems.take(2).map((news) => HeroNewsListItem(news: news)),

          if (displayItems.length > 2)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemCount: _getGridItemCount(displayItems.length),
                itemBuilder: (context, index) {
                  final newsIndex = index + 2;
                  final news = displayItems[newsIndex];
                  return GridNewsListItem(news: news);
                },
              ),
            ),

          if (displayItems.length > 6)
            Container(
              margin: const EdgeInsets.only(top: 24, bottom: 16),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MostRecentSectionHeader(
                    onViewMorePressed: _onLoadMorePressed,
                    scrollController: _scrollController,
                  ),
                  SizedBox(height: 20),
                  ...displayItems
                      .skip(6)
                      .map((news) => MostRecentNewsListItem(news: news)),
                ],
              ),
            ),

          if (!state.hasReachedEnd)
            LoadMoreButton(
              onPressed: _onLoadMorePressed,
              isLoading: state.isLoadingMore,
            ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, NewsState state) {
    final hasResults = state.visibleItems.isNotEmpty;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<NewsBloc>().add(const NewsRefreshed());
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSearchResultsHeader(state.searchQuery),
          if (hasResults) ...[
            const SizedBox(height: 16),
            ...state.visibleItems.map((news) => SearchNewsListItem(news: news)),
          ] else
            _buildEmptySearchState(),
        ],
      ),
    );
  }

  Widget _buildSearchResultsHeader(String query) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: 'Resultado da busca por ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.newsTitleText,
            ),
          ),
          TextSpan(
            text: query,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBackground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verifique se existe algum erro de digitação no termo',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: AppColors.emptyStateHintText),
        ),
        const SizedBox(height: 32),
        Image.asset(
          'assets/images/empty-state.png',
          width: 400,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  int _getGridItemCount(int totalItems) {
    if (totalItems <= 2) return 0;
    if (totalItems <= 6) return totalItems - 2;
    return 4;
  }

  Widget _buildEmptyErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Não foi possível carregar as notícias',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Verifique sua conexão e tente novamente',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.copyrightText),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<NewsBloc>().add(const NewsStarted());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBackground,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
