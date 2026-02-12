import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nortus/src/features/news/data/cache/news_cache_service.dart';

void main() {
  group('NewsCacheService', () {
    late NewsCacheService cacheService;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      cacheService = NewsCacheService();
    });

    group('savePage', () {
      test('deve salvar page 1 com sucesso', () async {
        final json = {
          'pagination': {'page': 1, 'pageSize': 10},
          'data': [
            {'id': 1, 'title': 'News 1'}
          ]
        };

        await cacheService.savePage(1, json);

        final prefs = await SharedPreferences.getInstance();
        final saved = prefs.getString('news_page_1');
        expect(saved, isNotNull);

        final decoded = jsonDecode(saved!);
        expect(decoded['pagination']['page'], 1);
      });

      test('deve salvar múltiplas pages com chaves diferentes', () async {
        final json1 = {'page': 1, 'data': []};
        final json2 = {'page': 2, 'data': []};

        await cacheService.savePage(1, json1);
        await cacheService.savePage(2, json2);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.containsKey('news_page_1'), true);
        expect(prefs.containsKey('news_page_2'), true);

        final saved1 = prefs.getString('news_page_1');
        final saved2 = prefs.getString('news_page_2');
        expect(saved1, isNotNull);
        expect(saved2, isNotNull);
      });

      test('deve sobrescrever page existente', () async {
        final json1 = {'page': 1, 'version': 1};
        final json2 = {'page': 1, 'version': 2};

        await cacheService.savePage(1, json1);
        await cacheService.savePage(1, json2);

        final prefs = await SharedPreferences.getInstance();
        final saved = prefs.getString('news_page_1');
        final decoded = jsonDecode(saved!);
        expect(decoded['version'], 2);
      });

      test('deve salvar Map vazio sem erro', () async {
        const json = <String, dynamic>{};

        await cacheService.savePage(1, json);
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.containsKey('news_page_1'), true);
      });

      test('deve salvar Map com dados complexos (aninhados)', () async {
        final json = {
          'pagination': {
            'page': 1,
            'pageSize': 10,
            'totalPages': 5,
            'totalItems': 45
          },
          'data': [
            {
              'id': 1,
              'title': 'News 1',
              'authors': [
                {'name': 'Author 1', 'image': {'src': 'url'}}
              ]
            }
          ]
        };

        await cacheService.savePage(1, json);

        final prefs = await SharedPreferences.getInstance();
        final saved = prefs.getString('news_page_1');
        final decoded = jsonDecode(saved!);
        expect(decoded['data'][0]['authors'][0]['name'], 'Author 1');
      });
    });

    group('getPage', () {
      test('deve recuperar page salva anteriormente', () async {
        final json = {'page': 1, 'title': 'Test Page'};
        await cacheService.savePage(1, json);

        final retrieved = await cacheService.getPage(1);

        expect(retrieved, isNotNull);
        expect(retrieved!['page'], 1);
        expect(retrieved['title'], 'Test Page');
      });

      test('deve retornar null quando page não foi salva', () async {
        final retrieved = await cacheService.getPage(999);

        expect(retrieved, isNull);
      });

      test('deve retornar null quando chave existe mas está vazia', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('news_page_1', '');

        final retrieved = await cacheService.getPage(1);

        expect(retrieved, isNull);
      });

      test('deve retornar null quando JSON no cache é inválido', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('news_page_1', 'invalid-json-{');

        final retrieved = await cacheService.getPage(1);

        expect(retrieved, isNull);
      });

      test('deve retornar null quando decoded JSON não é Map', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('news_page_1', jsonEncode(['array', 'not', 'map']));

        final retrieved = await cacheService.getPage(1);

        expect(retrieved, isNull);
      });

      test('deve recuperar dados complexos sem corrupção', () async {
        final originalJson = {
          'pagination': {
            'page': 2,
            'pageSize': 20,
          },
          'data': [
            {
              'id': 100,
              'title': 'Complex News',
              'nested': {
                'deep': {
                  'value': 'preserved'
                }
              }
            }
          ]
        };

        await cacheService.savePage(2, originalJson);

        final retrieved = await cacheService.getPage(2);

        expect(retrieved!['data'][0]['nested']['deep']['value'], 'preserved');
      });

      test('deve retornar Map diferente de page 1 quando recupera page 2', () async {
        final json1 = {'page': 1, 'title': 'Page 1'};
        final json2 = {'page': 2, 'title': 'Page 2'};

        await cacheService.savePage(1, json1);
        await cacheService.savePage(2, json2);

        final retrieved1 = await cacheService.getPage(1);
        final retrieved2 = await cacheService.getPage(2);

        expect(retrieved1!['title'], 'Page 1');
        expect(retrieved2!['title'], 'Page 2');
      });
    });

    group('clear', () {
      test('deve limpar todas as pages salvas', () async {
        await cacheService.savePage(1, {'page': 1});
        await cacheService.savePage(2, {'page': 2});
        await cacheService.savePage(3, {'page': 3});

        final prefsBefore = await SharedPreferences.getInstance();
        expect(prefsBefore.containsKey('news_page_1'), true);
        expect(prefsBefore.containsKey('news_page_2'), true);
        expect(prefsBefore.containsKey('news_page_3'), true);

        await cacheService.clear();

        final prefsAfter = await SharedPreferences.getInstance();
        expect(prefsAfter.containsKey('news_page_1'), false);
        expect(prefsAfter.containsKey('news_page_2'), false);
        expect(prefsAfter.containsKey('news_page_3'), false);
      });

      test('deve permitir clear quando não há dados salvos', () async {
        await cacheService.clear();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getKeys().where((k) => k.startsWith('news_page_')).toList(), isEmpty);
      });

      test('deve remover apenas chaves com prefixo news_page_', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('news_page_1', jsonEncode({'data': 1}));
        await prefs.setString('other_key', 'should-remain');
        await prefs.setString('favorites', 'should-remain');

        await cacheService.clear();

        expect(prefs.containsKey('news_page_1'), false);
        expect(prefs.containsKey('other_key'), true);
        expect(prefs.containsKey('favorites'), true);
      });

      test('deve permitir salvar novamente após clear', () async {
        await cacheService.savePage(1, {'page': 1});
        await cacheService.clear();

        final json = {'page': 1, 'restored': true};

        await cacheService.savePage(1, json);
        final retrieved = await cacheService.getPage(1);

        expect(retrieved!['restored'], true);
      });
    });

    group('Comportamento integrado', () {
      test('fluxo completo: save -> get -> clear -> get', () async {
        final json = {'page': 1, 'data': 'test'};

        await cacheService.savePage(1, json);
        expect(await cacheService.getPage(1), isNotNull);

        await cacheService.clear();
        expect(await cacheService.getPage(1), isNull);
      });

      test('múltiplas pages podem coexistir', () async {
        await cacheService.savePage(1, {'page': 1});
        await cacheService.savePage(2, {'page': 2});
        await cacheService.savePage(3, {'page': 3});

        final page1 = await cacheService.getPage(1);
        final page2 = await cacheService.getPage(2);
        final page3 = await cacheService.getPage(3);

        expect(page1!['page'], 1);
        expect(page2!['page'], 2);
        expect(page3!['page'], 3);

        await cacheService.clear();

        expect(await cacheService.getPage(1), isNull);
        expect(await cacheService.getPage(2), isNull);
        expect(await cacheService.getPage(3), isNull);
      });
    });
  });
}
