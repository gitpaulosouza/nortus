import 'package:flutter_test/flutter_test.dart';
import 'package:nortus/src/features/news/data/models/news_model.dart';
import 'package:nortus/src/features/news/data/models/news_image_model.dart';
import 'package:nortus/src/features/news/data/models/news_author_model.dart';

void main() {
  group('NewsModel', () {
    group('fromJson', () {
      test('deve fazer parse de JSON completo', () {
        final json = <String, dynamic>{
          'id': 1,
          'title': 'Test News',
          'image': <String, dynamic>{'src': 'test.jpg', 'alt': 'Test'},
          'categories': ['Tech', 'Science'],
          'publishedAt': '2024-01-01T12:00:00Z',
          'summary': 'Test summary',
          'authors': [
            <String, dynamic>{
              'name': 'John Doe',
              'image': <String, dynamic>{'src': 'author.jpg', 'alt': 'Author'},
              'description': 'Author bio',
            },
          ],
        };

        final model = NewsModel.fromJson(json);

        expect(model.id, 1);
        expect(model.title, 'Test News');
        expect(model.image.src, 'test.jpg');
        expect(model.categories, ['Tech', 'Science']);
        expect(model.publishedAt, DateTime.parse('2024-01-01T12:00:00Z'));
        expect(model.summary, 'Test summary');
        expect(model.authors.length, 1);
        expect(model.authors.first.name, 'John Doe');
      });

      test('deve usar valores padrão quando campos faltam', () {
        final json = <String, dynamic>{};

        final model = NewsModel.fromJson(json);

        expect(model.id, 0);
        expect(model.title, '');
        expect(model.image.src, '');
        expect(model.categories, []);
        expect(model.publishedAt, DateTime.fromMillisecondsSinceEpoch(0, isUtc: true));
        expect(model.summary, '');
        expect(model.authors, []);
      });

      test('deve tratar publishedAt inválido', () {
        final json = <String, dynamic>{'publishedAt': 'invalid-date'};

        final model = NewsModel.fromJson(json);

        expect(model.publishedAt, DateTime.fromMillisecondsSinceEpoch(0, isUtc: true));
      });

      test('deve converter categories para strings', () {
        final json = <String, dynamic>{
          'categories': [1, 2, 3],
        };

        final model = NewsModel.fromJson(json);

        expect(model.categories, ['1', '2', '3']);
      });
    });

    group('toJson', () {
      test('deve serializar NewsModel para JSON', () {
        final model = NewsModel(
          id: 1,
          title: 'Test News',
          image: const NewsImageModel(src: 'test.jpg', alt: 'Test'),
          categories: const ['Tech'],
          publishedAt: DateTime.parse('2024-01-01T12:00:00Z'),
          summary: 'Summary',
          authors: const [
            NewsAuthorModel(
              name: 'John',
              image: NewsImageModel(src: 'author.jpg', alt: 'Author'),
              description: 'Bio',
            ),
          ],
        );

        final json = model.toJson();

        expect(json['id'], 1);
        expect(json['title'], 'Test News');
        expect(json['image']['src'], 'test.jpg');
        expect(json['categories'], ['Tech']);
        expect(json['publishedAt'], '2024-01-01T12:00:00.000Z');
        expect(json['summary'], 'Summary');
        expect(json['authors'].length, 1);
      });
    });

    group('Equatable', () {
      test('dois NewsModels com mesmos dados devem ser iguais', () {
        final model1 = NewsModel(
          id: 1,
          title: 'Test',
          image: const NewsImageModel(src: 'test.jpg', alt: 'Test'),
          categories: const ['Tech'],
          publishedAt: DateTime.parse('2024-01-01T12:00:00Z'),
          summary: 'Summary',
          authors: const [],
        );

        final model2 = NewsModel(
          id: 1,
          title: 'Test',
          image: const NewsImageModel(src: 'test.jpg', alt: 'Test'),
          categories: const ['Tech'],
          publishedAt: DateTime.parse('2024-01-01T12:00:00Z'),
          summary: 'Summary',
          authors: const [],
        );

        expect(model1, model2);
      });

      test('NewsModels com dados diferentes não devem ser iguais', () {
        final model1 = NewsModel(
          id: 1,
          title: 'Test 1',
          image: const NewsImageModel(src: 'test.jpg', alt: 'Test'),
          categories: const ['Tech'],
          publishedAt: DateTime.parse('2024-01-01T12:00:00Z'),
          summary: 'Summary',
          authors: const [],
        );

        final model2 = NewsModel(
          id: 2,
          title: 'Test 2',
          image: const NewsImageModel(src: 'test.jpg', alt: 'Test'),
          categories: const ['Tech'],
          publishedAt: DateTime.parse('2024-01-01T12:00:00Z'),
          summary: 'Summary',
          authors: const [],
        );

        expect(model1, isNot(model2));
      });
    });
  });
}
