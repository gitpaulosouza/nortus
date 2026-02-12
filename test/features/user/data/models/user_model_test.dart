import 'package:flutter_test/flutter_test.dart';
import 'package:nortus/src/features/user/data/models/adress_user_model.dart';
import 'package:nortus/src/features/user/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    group('_parseId', () {
      test('deve converter int para int com sucesso', () {
        const json = {'id': 123};

        final user = UserModel.fromJson(json);

        expect(user.id, 123);
      });

      test('deve converter String numérica para int', () {
        const json = {'id': '456'};

        final user = UserModel.fromJson(json);

        expect(user.id, 456);
      });

      test('deve retornar 0 quando id é String inválida', () {
        const json = {'id': 'abc'};

        final user = UserModel.fromJson(json);

        expect(user.id, 0);
      });

      test('deve retornar 0 quando id é null', () {
        const json = <String, dynamic>{'id': null};

        final user = UserModel.fromJson(json);

        expect(user.id, 0);
      });

      test('deve retornar 0 quando id não está no JSON', () {
        const json = <String, dynamic>{};

        final user = UserModel.fromJson(json);

        expect(user.id, 0);
      });

      test('deve retornar 0 quando id é tipo inválido (bool)', () {
        const json = {'id': true};

        final user = UserModel.fromJson(json);

        expect(user.id, 0);
      });
    });

    group('_parseDate', () {
      test('deve fazer parse de String ISO 8601 para DateTime', () {
        const isoString = '2024-02-12T10:30:00Z';
        final json = {'updatedAt': isoString};

        final user = UserModel.fromJson(json);

        expect(user.updatedAt, isA<DateTime>());
        expect(user.updatedAt.year, 2024);
        expect(user.updatedAt.month, 2);
        expect(user.updatedAt.day, 12);
      });

      test('deve retornar DateTime.now() quando updatedAt é null', () {
        final json = <String, dynamic>{'updatedAt': null};
        final beforeParse = DateTime.now();

        final user = UserModel.fromJson(json);
        final afterParse = DateTime.now();

        expect(user.updatedAt, isA<DateTime>());
        expect(user.updatedAt.isAfter(beforeParse.subtract(const Duration(milliseconds: 1))) || user.updatedAt.isAtSameMomentAs(beforeParse), true);
        expect(user.updatedAt.isBefore(afterParse.add(const Duration(milliseconds: 1))) || user.updatedAt.isAtSameMomentAs(afterParse), true);
      });

      test('deve retornar DateTime.now() quando updatedAt é String inválida', () {
        const json = {'updatedAt': 'invalid-date'};
        final beforeParse = DateTime.now();

        final user = UserModel.fromJson(json);
        final afterParse = DateTime.now();

        expect(user.updatedAt, isA<DateTime>());
        expect(user.updatedAt.isAfter(beforeParse.subtract(const Duration(milliseconds: 1))) || user.updatedAt.isAtSameMomentAs(beforeParse), true);
        expect(user.updatedAt.isBefore(afterParse.add(const Duration(milliseconds: 1))) || user.updatedAt.isAtSameMomentAs(afterParse), true);
      });

      test('deve retornar DateTime.now() quando updatedAt não está no JSON', () {
        const json = <String, dynamic>{};
        final beforeParse = DateTime.now();

        final user = UserModel.fromJson(json);
        final afterParse = DateTime.now();

        expect(user.updatedAt, isA<DateTime>());
        expect(user.updatedAt.isAfter(beforeParse.subtract(const Duration(milliseconds: 1))) || user.updatedAt.isAtSameMomentAs(beforeParse), true);
        expect(user.updatedAt.isBefore(afterParse.add(const Duration(milliseconds: 1))) || user.updatedAt.isAtSameMomentAs(afterParse), true);
      });

      test('deve retornar DateTime.now() quando updatedAt é tipo inválido (int)', () {
        const json = {'updatedAt': 12345};
        final beforeParse = DateTime.now();

        final user = UserModel.fromJson(json);
        final afterParse = DateTime.now();

        expect(user.updatedAt, isA<DateTime>());
        expect(user.updatedAt.isAfter(beforeParse.subtract(const Duration(milliseconds: 1))) || user.updatedAt.isAtSameMomentAs(beforeParse), true);
        expect(user.updatedAt.isBefore(afterParse.add(const Duration(milliseconds: 1))) || user.updatedAt.isAtSameMomentAs(afterParse), true);
      });
    });

    group('_parseAddress', () {
      test('deve fazer parse de Map válido para AdressUserModel', () {
        final json = {
          'address': {
            'zipCode': '12345-678',
            'country': 'Brazil',
            'street': 'Av. Main',
            'number': '100',
            'complement': 'Apt 101',
            'neighborhood': 'Centro',
            'city': 'São Paulo',
            'state': 'SP',
          }
        };

        final user = UserModel.fromJson(json);

        expect(user.address, isA<AdressUserModel>());
        expect(user.address.zipCode, '12345-678');
        expect(user.address.city, 'São Paulo');
      });

      test('deve retornar AdressUserModel vazio quando address é null', () {
        final json = <String, dynamic>{'address': null};

        final user = UserModel.fromJson(json);

        expect(user.address, isA<AdressUserModel>());
        expect(user.address.zipCode, '');
        expect(user.address.street, '');
      });

      test('deve retornar AdressUserModel vazio quando address não está no JSON', () {
        const json = <String, dynamic>{};

        final user = UserModel.fromJson(json);

        expect(user.address, isA<AdressUserModel>());
        expect(user.address.zipCode, '');
        expect(user.address.country, '');
      });

      test('deve fazer parse de Map vazio para AdressUserModel com valores padrão', () {
        final json = {'address': <String, dynamic>{}};

        final user = UserModel.fromJson(json);

        expect(user.address, isA<AdressUserModel>());
        expect(user.address.zipCode, '');
        expect(user.address.country, '');
        expect(user.address.street, '');
      });

      test('deve fazer parse de Map parcialmente preenchido para AdressUserModel', () {
        final json = {
          'address': {
            'zipCode': '12345-678',
            'city': 'São Paulo',
          }
        };

        final user = UserModel.fromJson(json);

        expect(user.address.zipCode, '12345-678');
        expect(user.address.city, 'São Paulo');
        expect(user.address.street, '');
      });
    });

    group('Comportamento completo do fromJson', () {
      test('deve criar UserModel válido a partir de JSON bem-formado', () {
        final json = {
          'id': 1,
          'name': 'João Silva',
          'email': 'joao@example.com',
          'language': 'pt-BR',
          'dateFormat': 'dd/MM/yyyy',
          'timezone': 'America/Sao_Paulo',
          'address': {
            'zipCode': '12345-678',
            'country': 'Brazil',
            'street': 'Av. Main',
            'number': '100',
            'complement': 'Apt 101',
            'neighborhood': 'Centro',
            'city': 'São Paulo',
            'state': 'SP',
          },
          'updatedAt': '2024-02-12T10:00:00Z',
        };

        final user = UserModel.fromJson(json);

        expect(user.id, 1);
        expect(user.name, 'João Silva');
        expect(user.email, 'joao@example.com');
        expect(user.language, 'pt-BR');
        expect(user.address.city, 'São Paulo');
      });

      test('deve criar UserModel com valores padrão a partir de JSON mínimo', () {
        const json = <String, dynamic>{};

        final user = UserModel.fromJson(json);

        expect(user.id, 0);
        expect(user.name, '');
        expect(user.email, '');
        expect(user.language, '');
        expect(user.address.zipCode, '');
      });

      test('deve fazer parse de campos string ausentes como string vazia', () {
        const json = {'id': 1};

        final user = UserModel.fromJson(json);

        expect(user.id, 1);
        expect(user.name, '');
        expect(user.email, '');
        expect(user.language, '');
        expect(user.dateFormat, '');
        expect(user.timezone, '');
      });
    });

    group('toJson', () {
      test('deve serializar UserModel para JSON válido', () {
        final user = UserModel(
          id: 1,
          name: 'João Silva',
          email: 'joao@example.com',
          language: 'pt-BR',
          dateFormat: 'dd/MM/yyyy',
          timezone: 'America/Sao_Paulo',
          address: const AdressUserModel(
            zipCode: '12345-678',
            country: 'Brazil',
            street: 'Av. Main',
            number: '100',
            complement: 'Apt 101',
            neighborhood: 'Centro',
            city: 'São Paulo',
            state: 'SP',
          ),
          updatedAt: DateTime(2024, 2, 12),
        );

        final json = user.toJson();

        expect(json['name'], 'João Silva');
        expect(json['email'], 'joao@example.com');
        expect(json['language'], 'pt-BR');
        expect(json['address']['city'], 'São Paulo');
      });
    });

    group('Equatable - Igualdade', () {
      test('dois UserModels com mesmos dados devem ser iguais', () {
        final address = const AdressUserModel(
          zipCode: '12345',
          country: 'BR',
          street: 'St',
          number: '1',
          complement: '',
          neighborhood: 'N',
          city: 'C',
          state: 'S',
        );
        final date = DateTime(2024, 2, 12);

        final user1 = UserModel(
          id: 1,
          name: 'Test',
          email: 'test@test.com',
          language: 'pt',
          dateFormat: 'dd/MM',
          timezone: 'UTC',
          address: address,
          updatedAt: date,
        );

        final user2 = UserModel(
          id: 1,
          name: 'Test',
          email: 'test@test.com',
          language: 'pt',
          dateFormat: 'dd/MM',
          timezone: 'UTC',
          address: address,
          updatedAt: date,
        );

        expect(user1, equals(user2));
      });

      test('dois UserModels com dados diferentes devem ser diferentes', () {
        final address = const AdressUserModel(
          zipCode: '12345',
          country: 'BR',
          street: 'St',
          number: '1',
          complement: '',
          neighborhood: 'N',
          city: 'C',
          state: 'S',
        );
        final date = DateTime(2024, 2, 12);

        final user1 = UserModel(
          id: 1,
          name: 'Test',
          email: 'test@test.com',
          language: 'pt',
          dateFormat: 'dd/MM',
          timezone: 'UTC',
          address: address,
          updatedAt: date,
        );

        final user2 = UserModel(
          id: 2,
          name: 'Test',
          email: 'test@test.com',
          language: 'pt',
          dateFormat: 'dd/MM',
          timezone: 'UTC',
          address: address,
          updatedAt: date,
        );

        expect(user1, isNot(equals(user2)));
      });
    });
  });
}
