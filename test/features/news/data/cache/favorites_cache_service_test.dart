import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nortus/src/core/storage/prefs_keys.dart';
import 'package:nortus/src/features/news/data/cache/favorites_cache_service_impl.dart';

void main() {
  group('FavoritesCacheService', () {
    late FavoritesCacheServiceImpl favoritesService;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      favoritesService = FavoritesCacheServiceImpl();
    });

    group('saveFavorites', () {
      test('deve salvar Set vazio sem erro', () async {
        await favoritesService.saveFavorites({});
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.containsKey(PrefsKeys.newsFavorites.key), true);
      });

      test('deve salvar um favorito', () async {
        const favorites = {1};

        await favoritesService.saveFavorites(favorites);

        final prefs = await SharedPreferences.getInstance();
        final saved = prefs.getStringList(PrefsKeys.newsFavorites.key);
        expect(saved, isNotNull);
        expect(saved!.length, 1);
        expect(saved[0], '1');
      });

      test('deve salvar múltiplos favoritos', () async {
        const favorites = {1, 2, 3, 4, 5};

        await favoritesService.saveFavorites(favorites);

        final prefs = await SharedPreferences.getInstance();
        final saved = prefs.getStringList(PrefsKeys.newsFavorites.key);
        expect(saved!.length, 5);
        expect(saved.contains('1'), true);
        expect(saved.contains('2'), true);
        expect(saved.contains('5'), true);
      });

      test('deve sobrescrever favoritos anteriores', () async {
        const favorites1 = {1, 2, 3};
        const favorites2 = {10, 20, 30, 40};

        await favoritesService.saveFavorites(favorites1);
        await favoritesService.saveFavorites(favorites2);

        final prefs = await SharedPreferences.getInstance();
        final saved = prefs.getStringList(PrefsKeys.newsFavorites.key);
        expect(saved!.length, 4);
        expect(saved.contains('1'), false);
        expect(saved.contains('10'), true);
      });

      test('deve salvar Set com IDs grandes', () async {
        const favorites = {999999, 888888, 777777};

        await favoritesService.saveFavorites(favorites);

        final prefs = await SharedPreferences.getInstance();
        final saved = prefs.getStringList(PrefsKeys.newsFavorites.key);
        expect(saved!.length, 3);
        expect(saved.contains('999999'), true);
      });
    });

    group('loadFavorites', () {
      test('deve retornar Set vazio quando nunca foi salvo', () async {
        final favorites = await favoritesService.loadFavorites();

        expect(favorites, isEmpty);
        expect(favorites, isA<Set<int>>());
      });

      test('deve retornar Set com um favorito salvo', () async {
        const toSave = {42};
        await favoritesService.saveFavorites(toSave);

        final favorites = await favoritesService.loadFavorites();

        expect(favorites.length, 1);
        expect(favorites.contains(42), true);
      });

      test('deve retornar Set com múltiplos favoritos', () async {
        const toSave = {1, 2, 3, 4, 5};
        await favoritesService.saveFavorites(toSave);

        final favorites = await favoritesService.loadFavorites();

        expect(favorites.length, 5);
        expect(favorites, equals({1, 2, 3, 4, 5}));
      });

      test('deve retornar Set vazio quando lista salva é vazia', () async {
        const toSave = <int>{};
        await favoritesService.saveFavorites(toSave);

        final favorites = await favoritesService.loadFavorites();

        expect(favorites, isEmpty);
      });

      test('deve retornar Set vazio quando JSON salvo é inválido', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList(PrefsKeys.newsFavorites.key, ['invalid', 'not-numbers']);

        final favorites = await favoritesService.loadFavorites();

        expect(favorites, isEmpty);
      });

      test('deve limpar chave quando há erro de parsing', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList(PrefsKeys.newsFavorites.key, ['invalid']);

        await favoritesService.loadFavorites();

        final afterLoad = await SharedPreferences.getInstance();
        expect(afterLoad.containsKey(PrefsKeys.newsFavorites.key), false);
      });

      test('deve retornar Set sem duplicatas', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList(PrefsKeys.newsFavorites.key, ['1', '2', '2', '3', '3', '3']);

        final favorites = await favoritesService.loadFavorites();

        expect(favorites.length, 3);
        expect(favorites, equals({1, 2, 3}));
      });
    });

    group('addFavorite', () {
      test('deve adicionar favorito a um Set vazio', () async {
        await favoritesService.addFavorite(1);

        final favorites = await favoritesService.loadFavorites();
        expect(favorites.contains(1), true);
        expect(favorites.length, 1);
      });

      test('deve adicionar favorito a Set existente', () async {
        const initial = {1, 2, 3};
        await favoritesService.saveFavorites(initial);

        await favoritesService.addFavorite(4);

        final favorites = await favoritesService.loadFavorites();
        expect(favorites, equals({1, 2, 3, 4}));
      });

      test('não deve adicionar duplicata', () async {
        const initial = {1, 2, 3};
        await favoritesService.saveFavorites(initial);

        await favoritesService.addFavorite(2);

        final favorites = await favoritesService.loadFavorites();
        expect(favorites, equals({1, 2, 3}));
      });

      test('deve persistir favorito adicionado', () async {
        const initial = {1, 2};
        await favoritesService.saveFavorites(initial);

        await favoritesService.addFavorite(99);

        final prefs = await SharedPreferences.getInstance();
        final saved = prefs.getStringList(PrefsKeys.newsFavorites.key);
        expect(saved!.contains('99'), true);
      });
    });

    group('removeFavorite', () {
      test('deve remover favorito de Set', () async {
        const initial = {1, 2, 3};
        await favoritesService.saveFavorites(initial);

        await favoritesService.removeFavorite(2);

        final favorites = await favoritesService.loadFavorites();
        expect(favorites, equals({1, 3}));
      });

      test('deve não falhar ao remover favorito inexistente', () async {
        const initial = {1, 2, 3};
        await favoritesService.saveFavorites(initial);

        await favoritesService.removeFavorite(999);

        final favorites = await favoritesService.loadFavorites();
        expect(favorites, equals({1, 2, 3}));
      });

      test('deve deixar Set vazio após remover último favorito', () async {
        const initial = {42};
        await favoritesService.saveFavorites(initial);

        await favoritesService.removeFavorite(42);

        final favorites = await favoritesService.loadFavorites();
        expect(favorites, isEmpty);
      });

      test('deve persistir após remover favorito', () async {
        const initial = {1, 2, 3};
        await favoritesService.saveFavorites(initial);

        await favoritesService.removeFavorite(2);

        final prefs = await SharedPreferences.getInstance();
        final saved = prefs.getStringList(PrefsKeys.newsFavorites.key);
        expect(saved!.contains('2'), false);
        expect(saved.contains('1'), true);
        expect(saved.contains('3'), true);
      });
    });

    group('clear', () {
      test('deve limpar favoritos salvos', () async {
        const favorites = {1, 2, 3};
        await favoritesService.saveFavorites(favorites);

        expect(await favoritesService.loadFavorites(), isNotEmpty);

        await favoritesService.clear();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.containsKey(PrefsKeys.newsFavorites.key), false);
      });

      test('deve permitir clear quando não há dados', () async {
        await favoritesService.clear();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.containsKey(PrefsKeys.newsFavorites.key), false);
      });

      test('deve permitir adicionar favoritos após clear', () async {
        const initial = {1, 2, 3};
        await favoritesService.saveFavorites(initial);
        await favoritesService.clear();

        await favoritesService.addFavorite(100);

        final favorites = await favoritesService.loadFavorites();
        expect(favorites.contains(100), true);
        expect(favorites.length, 1);
      });
    });

    group('Comportamento integrado', () {
      test('fluxo completo: save -> load -> add -> load -> remove -> load -> clear -> load', () async {
        const initial = {1, 2, 3};
        await favoritesService.saveFavorites(initial);
        var favorites = await favoritesService.loadFavorites();
        expect(favorites, equals({1, 2, 3}));

        await favoritesService.addFavorite(4);
        favorites = await favoritesService.loadFavorites();
        expect(favorites, equals({1, 2, 3, 4}));

        await favoritesService.removeFavorite(2);
        favorites = await favoritesService.loadFavorites();
        expect(favorites, equals({1, 3, 4}));

        await favoritesService.clear();
        favorites = await favoritesService.loadFavorites();
        expect(favorites, isEmpty);
      });

      test('múltiplas operações de add e remove', () async {
        await favoritesService.addFavorite(10);
        await favoritesService.addFavorite(20);
        await favoritesService.addFavorite(30);

        var favorites = await favoritesService.loadFavorites();
        expect(favorites, equals({10, 20, 30}));

        await favoritesService.removeFavorite(20);
        favorites = await favoritesService.loadFavorites();
        expect(favorites, equals({10, 30}));

        await favoritesService.addFavorite(20);
        favorites = await favoritesService.loadFavorites();
        expect(favorites, equals({10, 20, 30}));
      });
    });
  });
}
