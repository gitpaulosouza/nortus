import 'package:flutter/material.dart';
import 'package:nortus/src/core/themes/app_colors.dart';
import 'package:nortus/src/features/news/data/models/news_author_model.dart';
import 'package:nortus/src/features/news/data/models/news_image_model.dart';
import 'package:nortus/src/features/news/data/models/news_model.dart';
import 'package:nortus/src/features/news/presentation/widgets/hero_news_list_item.dart';

class FavoriteNewsSection extends StatelessWidget {
  const FavoriteNewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteNews = _getMockFavoriteNews();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            ...favoriteNews.map((news) => HeroNewsListItem(news: news)),
        ],
      ),
    );
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
