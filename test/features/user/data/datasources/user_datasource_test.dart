import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/user/data/datasources/user_datasource.dart';
import 'package:nortus/src/features/user/data/models/user_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late UserDatasourceImpl datasource;

  setUp(() {
    mockDio = MockDio();
    datasource = UserDatasourceImpl(mockDio);
  });

  group('UserDataSource', () {
    final mockUserData = <String, dynamic>{
      'id': 1,
      'name': 'John Doe',
      'email': 'john@example.com',
      'language': 'pt',
      'dateFormat': 'DD/MM/YYYY',
      'timezone': 'America/Sao_Paulo',
      'address': <String, dynamic>{
        'zipCode': '12345',
        'country': 'Brazil',
        'street': 'Test St',
        'number': '123',
        'complement': '',
        'neighborhood': 'Center',
        'city': 'City',
        'state': 'ST',
      },
      'updatedAt': '2024-01-01T12:00:00Z',
    };

    group('getUser', () {
      test('deve retornar Right com UserModel quando sucesso com lista', () async {
        when(() => mockDio.get('/user')).thenAnswer((_) async => Response(
              data: [mockUserData],
              statusCode: 200,
              requestOptions: RequestOptions(path: '/user'),
            ));

        final result = await datasource.getUser();

        expect(result.isRight, true);
        result.fold(
          (error) => fail('Should not return error'),
          (user) {
            expect(user, isA<UserModel>());
            expect(user.name, 'John Doe');
          },
        );
      });

      test('deve retornar mock quando quota exceeded', () async {
        when(() => mockDio.get('/user')).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/user'),
          response: Response(
            data: 'quota exceeded',
            statusCode: 429,
            requestOptions: RequestOptions(path: '/user'),
          ),
        ));

        final result = await datasource.getUser();

        expect(result.isRight, true);
        result.fold(
          (error) => fail('Should return mock data'),
          (user) => expect(user, isA<UserModel>()),
        );
      });

      test('deve retornar UnknownError quando lista vazia', () async {
        when(() => mockDio.get('/user')).thenAnswer((_) async => Response(
              data: [],
              statusCode: 200,
              requestOptions: RequestOptions(path: '/user'),
            ));

        final result = await datasource.getUser();

        expect(result.isLeft, true);
        result.fold(
          (error) {
            expect(error, isA<UnknownError>());
            expect(error.message, 'Lista de usuários vazia.');
          },
          (user) => fail('Should not return user'),
        );
      });

      test('deve retornar NetworkError quando DioException', () async {
        when(() => mockDio.get('/user')).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/user'),
          response: Response(
            data: 'error',
            statusCode: 500,
            requestOptions: RequestOptions(path: '/user'),
          ),
        ));

        final result = await datasource.getUser();

        expect(result.isLeft, true);
        result.fold(
          (error) => expect(error, isA<NetworkError>()),
          (user) => fail('Should not return user'),
        );
      });
    });

    group('updateUser', () {
      final mockUser = UserModel.fromJson(mockUserData);

      test('deve retornar Right quando sucesso com status 200', () async {
        when(() => mockDio.patch('/user', data: any(named: 'data')))
            .thenAnswer((_) async => Response(
                  data: <String, dynamic>{'data': mockUserData},
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/user'),
                ));

        final result = await datasource.updateUser(mockUser);

        expect(result.isRight, true);
      });

      test('deve retornar modelo original quando status 204', () async {
        when(() => mockDio.patch('/user', data: any(named: 'data')))
            .thenAnswer((_) async => Response(
                  data: null,
                  statusCode: 204,
                  requestOptions: RequestOptions(path: '/user'),
                ));

        final result = await datasource.updateUser(mockUser);

        expect(result.isRight, true);
        result.fold(
          (error) => fail('Should not return error'),
          (user) => expect(user, mockUser),
        );
      });

      test('deve retornar mock quando quota exceeded', () async {
        when(() => mockDio.patch('/user', data: any(named: 'data')))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/user'),
          message: 'limite exceeded',
        ));

        final result = await datasource.updateUser(mockUser);

        expect(result.isRight, true);
      });

      test('deve retornar NetworkError quando falha', () async {
        when(() => mockDio.patch('/user', data: any(named: 'data')))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/user'),
          response: Response(
            data: 'error',
            statusCode: 500,
            requestOptions: RequestOptions(path: '/user'),
          ),
        ));

        final result = await datasource.updateUser(mockUser);

        expect(result.isLeft, true);
        result.fold(
          (error) => expect(error, isA<NetworkError>()),
          (user) => fail('Should not return user'),
        );
      });
    });
  });
}
