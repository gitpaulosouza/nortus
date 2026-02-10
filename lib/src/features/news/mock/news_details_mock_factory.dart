import 'package:nortus/src/features/news/data/models/news_author_model.dart';
import 'package:nortus/src/features/news/data/models/news_details_model.dart';
import 'package:nortus/src/features/news/data/models/news_image_model.dart';
import 'package:nortus/src/features/news/data/models/read_also_model.dart';
import 'package:nortus/src/features/news/data/models/related_news_model.dart';
import 'package:nortus/src/features/news/data/models/content_image_model.dart';
import 'package:nortus/src/features/news/data/models/three_image_grid_model.dart';
import 'package:nortus/src/features/news/data/models/video_placeholder_model.dart';

class NewsDetailsMockFactory {
  static final DateTime _baseDate = DateTime(2025, 10, 15, 10, 0);

  static NewsDetailsModel buildMock({required int newsId}) {
    final id = newsId > 0 ? newsId : 1;
    final publishedAt = _baseDate.subtract(Duration(days: id % 30));

    return NewsDetailsModel(
      id: id,
      title: _buildTitle(id),
      image: NewsImageModel(
        src: 'https://picsum.photos/900/500?random=$id',
        alt: 'Imagem mockada da notícia $id',
      ),
      imageCaption:
          'Imagem ilustrativa de projeto e inovação (conteúdo mockado).',
      categories: _buildCategories(id),
      publishedAt: publishedAt,
      newsResume: _buildResume(id),
      estimatedReadingTime: '${(id % 7) + 3} min de leitura',
      authors: _buildAuthors(id),
      description: _buildDescription(id),
      contentImages: _buildContentImages(id),
      threeImageGrid: _buildThreeImageGrid(id),
      videoPlaceholder: _buildVideoPlaceholder(id),
      relatedNews: _buildRelatedNews(id),
      readAlso: ReadAlsoModel(
        id: id + 1000,
        title: _buildReadAlsoTitle(id),
      ),
    );
  }

  static String _buildTitle(int id) {
    const titles = [
      'Novas soluções digitais aceleram obras inteligentes',
      'Infraestrutura sustentável reduz custos e prazos',
      'IA aplicada eleva produtividade em canteiros de obra',
      'Empresas de construção investem em dados e automação',
      'Tecnologia BIM se consolida em grandes projetos',
      'Eficiência energética impulsiona novos negócios',
    ];

    return titles[id % titles.length];
  }

  static List<String> _buildCategories(int id) {
    const categories = [
      'Construção',
      'Tecnologia',
      'Negócios',
      'Inovação',
      'Sustentabilidade',
      'Dados',
    ];

    return [
      categories[id % categories.length],
      categories[(id + 2) % categories.length],
    ];
  }

  static List<NewsAuthorModel> _buildAuthors(int id) {
    return [
      NewsAuthorModel(
        name: 'Redação Nortus',
        image: NewsImageModel(
          src: 'https://picsum.photos/100/100?random=${id + 1}',
          alt: 'Foto do autor',
        ),
        description: 'Equipe editorial - conteúdo de referência.',
      ),
      NewsAuthorModel(
        name: 'Especialista Convidado',
        image: NewsImageModel(
          src: 'https://picsum.photos/100/100?random=${id + 2}',
          alt: 'Foto do especialista',
        ),
        description: 'Consultor em inovação e transformação digital.',
      ),
    ];
  }

  static String _buildResume(int id) {
    return 'Resumo NortusAI: soluções digitais e práticas de gestão estão '
      'transformando o setor de construção e tecnologia. Este conteúdo '
      'mockado é exibido quando a API atinge o limite mensal de requisições.';
  }

  static String _buildDescription(int id) {
    return 'Este é um conteúdo de demonstração para a notícia $id. '
      'A API principal atingiu o limite mensal de requisições e, por isso, '
      'estamos exibindo dados mockados para garantir a continuidade da experiência.'
      '\n\n'
      'O setor de construção e tecnologia vem adotando plataformas digitais, '
      'modelagem BIM e automação para reduzir custos e melhorar prazos. '
      'Empresas com maturidade em dados conseguem previsões mais precisas, '
      'controle de qualidade e melhor gestão de recursos.'
      '\n\n'
      'Também cresce a busca por soluções sustentáveis, com uso de materiais '
      'de baixo impacto e processos mais eficientes. Os dados são ilustrativos '
      'e podem ser substituídos assim que o serviço principal estiver disponível.';
  }

  static List<RelatedNewsModel> _buildRelatedNews(int id) {
    return List.generate(4, (index) {
      final relatedId = id + index + 1;
      return RelatedNewsModel(
        id: relatedId,
        title: _buildRelatedTitle(relatedId),
        imageUrl: 'https://picsum.photos/600/400?random=$relatedId',
        categories: _buildCategories(relatedId),
        publishedAt: _baseDate.subtract(Duration(days: relatedId % 20)),
        authors: _buildAuthors(relatedId),
      );
    });
  }

  static String _buildRelatedTitle(int id) {
    const titles = [
      'Digitalização melhora a segurança em obras',
      'Startups criam soluções para logística de materiais',
      'Construtoras apostam em IoT para monitoramento',
      'Projetos verdes ganham espaço no mercado',
      'Finanças e tecnologia impulsionam novas parcerias',
    ];

    return titles[id % titles.length];
  }

  static String _buildReadAlsoTitle(int id) {
    const titles = [
      'Leia também: como a IA otimiza cronogramas de obra',
      'Leia também: práticas sustentáveis para novos projetos',
      'Leia também: dados e analytics na construção civil',
    ];

    return titles[id % titles.length];
  }

  static List<ContentImageModel> _buildContentImages(int id) {
    return [
      ContentImageModel(
        imageUrl: 'https://picsum.photos/800/600?random=${id + 100}',
        caption: 'Imagem de conteúdo - ilustra conceitos principais.',
      ),
    ];
  }

  static ThreeImageGridModel _buildThreeImageGrid(int id) {
    return ThreeImageGridModel(
      topImageUrl: 'https://picsum.photos/800/400?random=${id + 200}',
      bottomLeftImageUrl: 'https://picsum.photos/400/400?random=${id + 201}',
      bottomRightImageUrl: 'https://picsum.photos/400/400?random=${id + 202}',
      caption: 'Grid com três imagens - perspectivas diferentes do tema.',
    );
  }

    static VideoPlaceholderModel _buildVideoPlaceholder(int id) {
      return VideoPlaceholderModel(
        imageUrl: 'https://picsum.photos/800/600?random=${id + 300}',
        caption: 'Vídeo relacionado - conteúdo em formato audiovisual.',
      );
    }
  }
