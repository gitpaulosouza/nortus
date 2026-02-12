import 'package:flutter_test/flutter_test.dart';
import 'package:nortus/src/core/storage/prefs_keys.dart';

void main() {
  group('PrefsKeys', () {
    group('Static keys', () {
      test('isLoggedIn deve retornar a chave correta', () {
        expect(PrefsKeys.isLoggedIn.key, 'isLoggedIn');
      });

      test('newsFavorites deve retornar a chave correta', () {
        expect(PrefsKeys.newsFavorites.key, 'news_favorites');
      });

      test('newsFavoritesData deve retornar a chave correta', () {
        expect(PrefsKeys.newsFavoritesData.key, 'news_favorites_data');
      });
    });

    group('Dynamic keys', () {
      test('newsPage deve gerar chaves dinâmicas com o número da página', () {
        expect(PrefsKeys.newsPage(1), 'news_page_1');
        expect(PrefsKeys.newsPage(2), 'news_page_2');
        expect(PrefsKeys.newsPage(99), 'news_page_99');
      });

      test('newsPage deve suportar números grandes', () {
        expect(PrefsKeys.newsPage(1000), 'news_page_1000');
        expect(PrefsKeys.newsPage(999999), 'news_page_999999');
      });
    });

    group('Helper methods', () {
      test('isNewsPageKey deve identificar corretamente chaves de páginas', () {
        expect(PrefsKeys.isNewsPageKey('news_page_1'), true);
        expect(PrefsKeys.isNewsPageKey('news_page_2'), true);
        expect(PrefsKeys.isNewsPageKey('news_page_999'), true);
      });

      test('isNewsPageKey deve retornar false para chaves que não são de páginas', () {
        expect(PrefsKeys.isNewsPageKey('news_favorites'), false);
        expect(PrefsKeys.isNewsPageKey('isLoggedIn'), false);
        expect(PrefsKeys.isNewsPageKey('other_key'), false);
        expect(PrefsKeys.isNewsPageKey('news_page'), false);
        // Note: 'news_page_' retorna true pois startsWith aceita
      });

      test('filterNewsPageKeys deve filtrar apenas chaves de páginas', () {
        final keys = [
          'news_page_1',
          'news_page_2',
          'news_favorites',
          'isLoggedIn',
          'news_page_99',
          'other_key',
        ];

        final filtered = PrefsKeys.filterNewsPageKeys(keys);

        expect(filtered, hasLength(3));
        expect(filtered, contains('news_page_1'));
        expect(filtered, contains('news_page_2'));
        expect(filtered, contains('news_page_99'));
        expect(filtered, isNot(contains('news_favorites')));
        expect(filtered, isNot(contains('isLoggedIn')));
      });

      test('filterNewsPageKeys deve retornar vazio quando não há chaves de páginas', () {
        final keys = [
          'news_favorites',
          'isLoggedIn',
          'other_key',
        ];

        final filtered = PrefsKeys.filterNewsPageKeys(keys);

        expect(filtered, isEmpty);
      });

      test('filterNewsPageKeys deve funcionar com lista vazia', () {
        final filtered = PrefsKeys.filterNewsPageKeys([]);

        expect(filtered, isEmpty);
      });
    });

    group('Backward compatibility', () {
      test('deve manter valores exatos das chaves para compatibilidade com cache existente', () {
        // Valores hardcoded para garantir que nunca mudem
        expect(PrefsKeys.isLoggedIn.key, 'isLoggedIn');
        expect(PrefsKeys.newsFavorites.key, 'news_favorites');
        expect(PrefsKeys.newsFavoritesData.key, 'news_favorites_data');
        expect(PrefsKeys.newsPage(1), 'news_page_1');
      });
    });
  });
}
