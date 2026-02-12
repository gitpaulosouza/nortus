import 'package:flutter_test/flutter_test.dart';
import 'package:nortus/src/features/user/data/models/adress_user_model.dart';
import 'package:nortus/src/features/user/data/models/user_list_response_model.dart';
import 'package:nortus/src/features/user/data/models/user_model.dart';

void main() {
  group('UserListResponseModel', () {
    group('fromJson - Aceitando List', () {
      test('deve fazer parse de List válida com um User', () {
        final json = [
          <String, dynamic>{
            'id': 1,
            'name': 'User 1',
            'email': 'user1@test.com',
            'language': 'pt-BR',
            'dateFormat': 'dd/MM',
            'timezone': 'UTC',
            'address': <String, dynamic>{},
            'updatedAt': '2024-02-12T10:00:00Z',
          }
        ];

        final response = UserListResponseModel.fromJson(json);

        expect(response.users, isNotEmpty);
        expect(response.users.length, 1);
        expect(response.users[0].id, 1);
        expect(response.users[0].name, 'User 1');
      });

      test('deve fazer parse de List com múltiplos Users', () {
        final json = [
          <String, dynamic>{
            'id': 1,
            'name': 'User 1',
            'email': 'user1@test.com',
            'language': 'pt-BR',
            'dateFormat': 'dd/MM',
            'timezone': 'UTC',
            'address': <String, dynamic>{},
          },
          <String, dynamic>{
            'id': 2,
            'name': 'User 2',
            'email': 'user2@test.com',
            'language': 'en-US',
            'dateFormat': 'MM/dd',
            'timezone': 'UTC',
            'address': <String, dynamic>{},
          }
        ];

        final response = UserListResponseModel.fromJson(json);

        expect(response.users.length, 2);
        expect(response.users[0].id, 1);
        expect(response.users[1].id, 2);
      });

      test('deve fazer parse de List vazia', () {
        final json = <dynamic>[];

        final response = UserListResponseModel.fromJson(json);

        expect(response.users, isEmpty);
        expect(response.isEmpty, true);
      });

      test('deve retornar lista vazia quando List é null', () {
        const dynamic json = null;

        final response = UserListResponseModel.fromJson(json);

        expect(response.users, isEmpty);
        expect(response.isEmpty, true);
      });
    });

    group('fromJson - Aceitando formato nested com "data"', () {
      test('deve fazer parse de List com items contendo campo "data"', () {
        final json = [
          <String, dynamic>{
            'data': <String, dynamic>{
              'id': 1,
              'name': 'User 1',
              'email': 'user1@test.com',
              'language': 'pt-BR',
              'dateFormat': 'dd/MM',
              'timezone': 'UTC',
              'address': <String, dynamic>{},
            }
          },
          <String, dynamic>{
            'data': <String, dynamic>{
              'id': 2,
              'name': 'User 2',
              'email': 'user2@test.com',
              'language': 'en-US',
              'dateFormat': 'MM/dd',
              'timezone': 'UTC',
              'address': <String, dynamic>{},
            }
          }
        ];

        final response = UserListResponseModel.fromJson(json);

        expect(response.users.length, 2);
        expect(response.users[0].id, 1);
        expect(response.users[1].id, 2);
      });

      test('deve fazer parse de List com item tendo "data" como Map válido', () {
        final json = [
          <String, dynamic>{
            'data': <String, dynamic>{
              'id': 100,
              'name': 'Nested User',
              'email': 'nested@test.com',
              'language': 'pt-BR',
              'dateFormat': 'dd/MM',
              'timezone': 'UTC',
              'address': <String, dynamic>{},
            }
          }
        ];

        final response = UserListResponseModel.fromJson(json);

        expect(response.users.length, 1);
        expect(response.users[0].id, 100);
        expect(response.users[0].name, 'Nested User');
      });
    });

    group('fromJson - Tratamento de erros', () {
      test('deve ignorar itens não-Map na List', () {
        final json = [
          <String, dynamic>{
            'id': 1,
            'name': 'User 1',
            'email': 'user1@test.com',
            'language': 'pt-BR',
            'dateFormat': 'dd/MM',
            'timezone': 'UTC',
            'address': <String, dynamic>{},
          },
          'invalid-string',
          <String, dynamic>{
            'id': 2,
            'name': 'User 2',
            'email': 'user2@test.com',
            'language': 'en-US',
            'dateFormat': 'MM/dd',
            'timezone': 'UTC',
            'address': <String, dynamic>{},
          }
        ];

        final response = UserListResponseModel.fromJson(json);

        expect(response.users.length, 2);
        expect(response.users[0].id, 1);
        expect(response.users[1].id, 2);
      });

      test('deve ignorar item Map com erro de parsing', () {
        final json = [
          <String, dynamic>{
            'id': 1,
            'name': 'User 1',
            'email': 'user1@test.com',
            'language': 'pt-BR',
            'dateFormat': 'dd/MM',
            'timezone': 'UTC',
            'address': <String, dynamic>{},
          },
          <String, dynamic>{
            'id': 999,
            'name': 'User 999',
            'email': 'user999@test.com',
            'language': 'pt-BR',
            'dateFormat': 'dd/MM',
            'timezone': 'UTC',
            'address': <String, dynamic>{
              'zipCode': 123,
            },
          },
          <String, dynamic>{
            'id': 2,
            'name': 'User 2',
            'email': 'user2@test.com',
            'language': 'en-US',
            'dateFormat': 'MM/dd',
            'timezone': 'UTC',
            'address': <String, dynamic>{},
          }
        ];

        final response = UserListResponseModel.fromJson(json);

        expect(response.users.length, greaterThan(0));
      });

      test('deve ignorar item não-List quando json é inválido', () {
        const dynamic json = {'invalid': 'format'};

        final response = UserListResponseModel.fromJson(json);

        expect(response.users, isEmpty);
        expect(response.isEmpty, true);
      });

      test('deve ignorar item List quando json é String', () {
        const dynamic json = 'not-a-list';

        final response = UserListResponseModel.fromJson(json);

        expect(response.users, isEmpty);
      });
    });

    group('toJson', () {
      test('deve serializar UserListResponseModel para List de JSON', () {
        final response = UserListResponseModel(
          users: [
            UserModel(
              id: 1,
              name: 'User 1',
              email: 'user1@test.com',
              language: 'pt-BR',
              dateFormat: 'dd/MM',
              timezone: 'UTC',
              address: const AdressUserModel(
                zipCode: '',
                country: '',
                street: '',
                number: '',
                complement: '',
                neighborhood: '',
                city: '',
                state: '',
              ),
              updatedAt: DateTime(2024, 2, 12),
            )
          ],
        );

        final json = response.toJson();

        expect(json, isA<List>());
        expect(json.length, 1);
        expect(json[0]['name'], 'User 1');
      });

      test('deve serializar UserListResponseModel vazio para List vazia', () {
        final response = const UserListResponseModel(users: []);

        final json = response.toJson();

        expect(json, isA<List>());
        expect(json, isEmpty);
      });
    });

    group('Getters', () {
      test('firstOrNull deve retornar primeiro User quando lista não está vazia', () {
        final response = UserListResponseModel(
          users: [
            UserModel(
              id: 1,
              name: 'First',
              email: 'first@test.com',
              language: 'pt-BR',
              dateFormat: 'dd/MM',
              timezone: 'UTC',
              address: const AdressUserModel(
                zipCode: '',
                country: '',
                street: '',
                number: '',
                complement: '',
                neighborhood: '',
                city: '',
                state: '',
              ),
              updatedAt: DateTime(2024, 2, 12),
            ),
            UserModel(
              id: 2,
              name: 'Second',
              email: 'second@test.com',
              language: 'en-US',
              dateFormat: 'MM/dd',
              timezone: 'UTC',
              address: const AdressUserModel(
                zipCode: '',
                country: '',
                street: '',
                number: '',
                complement: '',
                neighborhood: '',
                city: '',
                state: '',
              ),
              updatedAt: DateTime(2024, 2, 12),
            ),
          ],
        );

        final first = response.firstOrNull;

        expect(first, isNotNull);
        expect(first?.id, 1);
        expect(first?.name, 'First');
      });

      test('firstOrNull deve retornar null quando lista está vazia', () {
        final response = const UserListResponseModel(users: []);

        final first = response.firstOrNull;

        expect(first, isNull);
      });

      test('isEmpty deve retornar true quando lista está vazia', () {
        final response = const UserListResponseModel(users: []);

        expect(response.isEmpty, true);
      });

      test('isEmpty deve retornar false quando lista contém items', () {
        final response = UserListResponseModel(
          users: [
            UserModel(
              id: 1,
              name: 'User',
              email: 'user@test.com',
              language: 'pt-BR',
              dateFormat: 'dd/MM',
              timezone: 'UTC',
              address: const AdressUserModel(
                zipCode: '',
                country: '',
                street: '',
                number: '',
                complement: '',
                neighborhood: '',
                city: '',
                state: '',
              ),
              updatedAt: DateTime(2024, 2, 12),
            )
          ],
        );

        expect(response.isEmpty, false);
      });
    });

    group('Equatable - Igualdade', () {
      test('dois UserListResponseModels com mesma lista devem ser iguais', () {
        final users = [
          UserModel(
            id: 1,
            name: 'User',
            email: 'user@test.com',
            language: 'pt-BR',
            dateFormat: 'dd/MM',
            timezone: 'UTC',
            address: const AdressUserModel(
              zipCode: '',
              country: '',
              street: '',
              number: '',
              complement: '',
              neighborhood: '',
              city: '',
              state: '',
            ),
            updatedAt: DateTime(2024, 2, 12),
          )
        ];

        final response1 = UserListResponseModel(users: users);
        final response2 = UserListResponseModel(users: users);

        expect(response1, equals(response2));
      });

      test('dois UserListResponseModels com listas diferentes devem ser diferentes', () {
        final users1 = [
          UserModel(
            id: 1,
            name: 'User 1',
            email: 'user1@test.com',
            language: 'pt-BR',
            dateFormat: 'dd/MM',
            timezone: 'UTC',
            address: const AdressUserModel(
              zipCode: '',
              country: '',
              street: '',
              number: '',
              complement: '',
              neighborhood: '',
              city: '',
              state: '',
            ),
            updatedAt: DateTime(2024, 2, 12),
          )
        ];

        final users2 = [
          UserModel(
            id: 2,
            name: 'User 2',
            email: 'user2@test.com',
            language: 'en-US',
            dateFormat: 'MM/dd',
            timezone: 'UTC',
            address: const AdressUserModel(
              zipCode: '',
              country: '',
              street: '',
              number: '',
              complement: '',
              neighborhood: '',
              city: '',
              state: '',
            ),
            updatedAt: DateTime(2024, 2, 12),
          )
        ];

        final response1 = UserListResponseModel(users: users1);
        final response2 = UserListResponseModel(users: users2);

        expect(response1, isNot(equals(response2)));
      });
    });
  });
}
