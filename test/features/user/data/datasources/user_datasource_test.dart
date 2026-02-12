import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/core/http/http_client.dart';
import 'package:nortus/src/core/http/http_exception.dart';
import 'package:nortus/src/core/http/http_response.dart';
import 'package:nortus/src/features/user/data/datasources/user_datasource_impl.dart';
import 'package:nortus/src/features/user/data/models/user_model.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late MockHttpClient mockHttpClient;
  late UserDatasourceImpl datasource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = UserDatasourceImpl(mockHttpClient);
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
      test('deve retornar Right com UserModel quando sucesso com lista',
          () async {
        when(() => mockHttpClient.get('/user'))
            .thenAnswer((_) async => HttpResponse(
                  data: [mockUserData],
                  statusCode: 200,
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
        when(() => mockHttpClient.get('/user'))
            .thenThrow(const HttpException(
          message: 'quota exceeded',
          statusCode: 429,
          data: 'quota exceeded',
        ));

        final result = await datasource.getUser();

        expect(result.isRight, true);
        result.fold(
          (error) => fail('Should return mock data'),
          (user) => expect(user, isA<UserModel>()),
        );
      });

      test('deve retornar UnknownError quando lista vazia', () async {
        when(() => mockHttpClient.get('/user'))
            .thenAnswer((_) async => const HttpResponse(
                  data: [],
                  statusCode: 200,
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

      test('deve retornar NetworkError quando HttpException', () async {
        when(() => mockHttpClient.get('/user'))
            .thenThrow(const HttpException(
          message: 'error',
          statusCode: 500,
          data: 'error',
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
        when(() => mockHttpClient.put('/user', data: any(named: 'data')))
            .thenAnswer((_) async => HttpResponse(
                  data: <String, dynamic>{'data': mockUserData},
                  statusCode: 200,
                ));

        final result = await datasource.updateUser(mockUser);

        expect(result.isRight, true);
      });

      test('deve retornar modelo original quando status 204', () async {
        when(() => mockHttpClient.put('/user', data: any(named: 'data')))
            .thenAnswer((_) async => const HttpResponse(
                  data: null,
                  statusCode: 204,
                ));

        final result = await datasource.updateUser(mockUser);

        expect(result.isRight, true);
        result.fold(
          (error) => fail('Should not return error'),
          (user) => expect(user, mockUser),
        );
      });

      test('deve retornar mock quando quota exceeded', () async {
        when(() => mockHttpClient.put('/user', data: any(named: 'data')))
            .thenThrow(const HttpException(
          message: 'limite exceeded',
          data: 'limite exceeded',
        ));

        final result = await datasource.updateUser(mockUser);

        expect(result.isRight, true);
      });

      test('deve retornar NetworkError quando falha', () async {
        when(() => mockHttpClient.put('/user', data: any(named: 'data')))
            .thenThrow(const HttpException(
          message: 'error',
          statusCode: 500,
          data: 'error',
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
