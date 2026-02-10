import 'package:flutter/material.dart';
import 'package:nortus/src/core/themes/app_colors.dart';
import 'package:nortus/src/features/news/data/models/news_author_model.dart';
import 'package:nortus/src/features/news/data/models/news_image_model.dart';
import 'package:nortus/src/features/news/data/models/news_model.dart';
import 'package:nortus/src/features/news/presentation/widgets/search_news_list_item.dart';

class FavoriteNewsSection extends StatelessWidget {
  final String searchQuery;

  const FavoriteNewsSection({super.key, this.searchQuery = ''});

  @override
  Widget build(BuildContext context) {
    final favoriteNews = _getMockFavoriteNews();
    final displayNews = _filterNews(favoriteNews, searchQuery);
    final isSearchActive = searchQuery.isNotEmpty;
    final hasResults = displayNews.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSearchActive) ...[
            _buildSearchResultsHeader(searchQuery),
            const SizedBox(height: 16),
            if (!hasResults)
              _buildEmptySearchState()
            else
              ...displayNews.map((news) => SearchNewsListItem(news: news)),
          ] else ...[
            IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Notícias favoritadas',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (favoriteNews.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    'Você ainda não favoritou nenhuma notícia.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textParagraph,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ...displayNews.map((news) => SearchNewsListItem(news: news)),
          ],
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
            text: '"$query"',
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
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
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
      ),
    );
  }

  List<NewsModel> _filterNews(List<NewsModel> news, String query) {
    if (query.isEmpty) {
      return news;
    }

    final normalizedQuery = _normalizeText(query);

    return news.where((newsItem) {
      final normalizedTitle = _normalizeText(newsItem.title);
      final normalizedSummary = _normalizeText(newsItem.summary);
      final normalizedCategories =
          newsItem.categories.map((c) => _normalizeText(c)).toList();

      if (normalizedTitle.contains(normalizedQuery)) {
        return true;
      }

      if (normalizedSummary.contains(normalizedQuery)) {
        return true;
      }

      for (final category in normalizedCategories) {
        if (category.contains(normalizedQuery)) {
          return true;
        }
      }

      return false;
    }).toList();
  }

  String _normalizeText(String text) {
    var normalized = text.trim().toLowerCase();

    const withDiacritics =
        'áàâãäåāăąǎǻảạắằẳẵặấầẩẫậéèêëēĕėęěẻẽẹếềểễệíìîïīĭįıỉĩịóòôõöōŏőøǿỏọốồổỗộớờởỡợúùûüūŭůűųưủũụứừửữựýỳŷÿȳỷỹỵćĉċčďđĝğġģĥħĵķĺļľŀłńņňŉŋŕŗřśŝşšţťŧẁẃŵẅỳýŷÿźżž';
    const withoutDiacritics =
        'aaaaaaaaaaaaaaaaaaaaaaaaaaaeeeeeeeeeeeeeeeeeeeiiiiiiiiiiiiiooooooooooooooooooooooouuuuuuuuuuuuuuuuuuuuyyyyyyyyycccccddgggghhhjklllllllnnnnnrrrsssstttwwwwyyyyzzzz';

    for (var i = 0; i < withDiacritics.length; i++) {
      normalized = normalized.replaceAll(
        withDiacritics[i],
        withoutDiacritics[i],
      );
    }

    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ');

    return normalized;
  }

  List<NewsModel> _getMockFavoriteNews() {
    return [
      NewsModel(
        id: 1,
        title: 'Tecnologia revoluciona o mercado financeiro brasileiro',
        image: const NewsImageModel(
          src:
              'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800',
          alt: 'Tecnologia',
        ),
        categories: const ['Tecnologia', 'Finanças'],
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        summary:
            'Novas startups de fintech estão transformando a forma como brasileiros lidam com dinheiro.',
        authors: const [
          NewsAuthorModel(
            name: 'João Silva',
            image: NewsImageModel(src: '', alt: ''),
            description: 'Jornalista de tecnologia',
          ),
        ],
      ),
      NewsModel(
        id: 2,
        title: 'Sustentabilidade: empresas adotam práticas ecológicas',
        image: const NewsImageModel(
          src:
              'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=800',
          alt: 'Sustentabilidade',
        ),
        categories: const ['Meio Ambiente'],
        publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
        summary:
            'Grandes corporações investem em energia renovável e redução de carbono.',
        authors: const [
          NewsAuthorModel(
            name: 'Maria Santos',
            image: NewsImageModel(src: '', alt: ''),
            description: 'Especialista em meio ambiente',
          ),
        ],
      ),
    ];
  }
}
