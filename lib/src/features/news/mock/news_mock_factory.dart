import 'package:nortus/src/features/news/data/models/news_author_model.dart';
import 'package:nortus/src/features/news/data/models/news_image_model.dart';
import 'package:nortus/src/features/news/data/models/news_list_response_model.dart';
import 'package:nortus/src/features/news/data/models/news_model.dart';
import 'package:nortus/src/features/news/data/models/news_pagination_model.dart';

class NewsMockFactory {
  static const int _pageSize = 10;
  static const int _totalPages = 5;
  static const int _totalItems = 50;

  static NewsListResponseModel buildNewsListMock({required int page}) {
    final pagination = NewsPaginationModel(
      page: page,
      pageSize: _pageSize,
      totalPages: _totalPages,
      totalItems: _totalItems,
    );

    final startId = ((page - 1) * _pageSize) + 1;
    final endId = (page * _pageSize).clamp(0, _totalItems);

    final items = <NewsModel>[];
    for (int i = startId; i <= endId; i++) {
      items.add(_buildNewsItem(i));
    }

    return NewsListResponseModel(pagination: pagination, data: items);
  }

  static NewsModel _buildNewsItem(int id) {
    final categories = _getCategoriesForId(id);
    final authors = _getAuthorsForId(id);
    final imageId = ((id - 1) % 10) + 1;
    final authorCount = (id % 3) + 1;

    return NewsModel(
      id: id,
      title: _getTitleForId(id),
      image: NewsImageModel(
        src: 'https://picsum.photos/800/450?random=$imageId',
        alt: 'Notícia $id - Imagem',
      ),
      categories: categories,
      publishedAt: _getDateForId(id),
      summary: _getSummaryForId(id),
      authors: authors.take(authorCount).toList(),
    );
  }

  static String _getTitleForId(int id) {
    final titles = [
      'Inovação em Tecnologia Digital Transforma o Mercado',
      'Novas Tendências em Desenvolvimento de Aplicações',
      'Inteligência Artificial Revoluciona a Indústria',
      'Segurança em Sistemas de Informação Cresce em Importância',
      'Cloud Computing: O Futuro dos Negócios Digitais',
      'Transformação Digital Impulsiona Crescimento Empresarial',
      'Ferramentas de Análise de Dados Ganham Protagonismo',
      'Desenvolvimento Ágil: Metodologias que Funcionam',
      'Experiência do Usuário Define Sucesso de Aplicativos',
      'Sustentabilidade na Tecnologia: Uma Prioridade Global',
    ];
    return titles[(id - 1) % titles.length];
  }

  static String _getSummaryForId(int id) {
    final summaries = [
      'Explore as últimas inovações tecnológicas que estão transformando a forma como trabalhamos e nos comunicamos.',
      'Descubra as melhores práticas para desenvolvimento de aplicações modernas e escaláveis.',
      'Entenda como a inteligência artificial está revolucionando diferentes setores da economia.',
      'Saiba mais sobre as medidas essenciais para proteger seus sistemas e dados.',
      'Conheça os benefícios da computação em nuvem para o seu negócio.',
      'Aprenda sobre estratégias de transformação digital para sua empresa.',
      'Veja como a análise de dados impulsiona a tomada de decisões inteligentes.',
      'Descubra os princípios da metodologia ágil para projetos de sucesso.',
      'Entenda a importância de uma excelente experiência do usuário.',
      'Conheça iniciativas sustentáveis no universo da tecnologia.',
    ];
    return summaries[(id - 1) % summaries.length];
  }

  static List<String> _getCategoriesForId(int id) {
    final allCategories = [
      ['Tecnologia', 'Inovação'],
      ['Desenvolvimento', 'Backend'],
      ['IA', 'Machine Learning'],
      ['Segurança', 'DevSecOps'],
      ['Cloud', 'AWS'],
      ['Transformação Digital'],
      ['Data Science'],
      ['Frontend', 'UX'],
      ['DevOps', 'Infraestrutura'],
      ['Sustentabilidade'],
    ];
    return allCategories[(id - 1) % allCategories.length];
  }

  static DateTime _getDateForId(int id) {
    final now = DateTime.now();
    final daysAgo = (id - 1) % 30;
    return now.subtract(Duration(days: daysAgo));
  }

  static List<NewsAuthorModel> _getAuthorsForId(int id) {
    return [
      NewsAuthorModel(
        name: 'Paulo Gabriel',
        image: NewsImageModel(
          src: 'https://picsum.photos/100/100?random=1',
          alt: 'Autor Paulo Gabriel',
        ),
        description: 'Especialista em desenvolvimento de aplicações modernas.',
      ),
      NewsAuthorModel(
        name: 'Ana Silva',
        image: NewsImageModel(
          src: 'https://picsum.photos/100/100?random=2',
          alt: 'Autora Ana Silva',
        ),
        description:
            'Consultora em transformação digital e estratégia tecnológica.',
      ),
      NewsAuthorModel(
        name: 'Carlos Mendes',
        image: NewsImageModel(
          src: 'https://picsum.photos/100/100?random=3',
          alt: 'Autor Carlos Mendes',
        ),
        description: 'Arquiteto de sistemas e especialista em cloud computing.',
      ),
    ];
  }
}
