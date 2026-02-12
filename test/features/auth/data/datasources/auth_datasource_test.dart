import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/auth/data/datasources/auth_datasource.dart';
import 'package:nortus/src/features/auth/data/models/auth_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AuthDatasourceImpl datasource;

  setUp(() {
    mockDio = MockDio();
    datasource = AuthDatasourceImpl(mockDio);
  });

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  group('AuthDataSource', () {
    const validCredentials = AuthModel(
      login: 'desafioLoomi',
      password: 'senha123',
    );

    const invalidCredentials = AuthModel(
      login: 'wrong',
      password: 'wrong',
    );

    group('login', () {
      test('deve retornar Right quando login bem-sucedido', () async {
        when(() => mockDio.post('/auth', data: any(named: 'data')))
            .thenAnswer((_) async => Response(
                  data: <String, dynamic>{'token': 'fake-token'},
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/auth'),
                ));

        final result = await datasource.login(validCredentials);

        expect(result.isRight, true);
      });

      test('deve retornar Right com credenciais válidas quando quota exceeded', () async {
        when(() => mockDio.post('/auth', data: any(named: 'data')))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/auth'),
          response: Response(
            data: 'Monthly request quota has been exceeded',
            statusCode: 429,
            requestOptions: RequestOptions(path: '/auth'),
          ),
        ));

        final result = await datasource.login(validCredentials);

        expect(result.isRight, true);
      });

      test('deve retornar ValidationError com credenciais inválidas quando quota exceeded', () async {
        when(() => mockDio.post('/auth', data: any(named: 'data')))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/auth'),
          response: Response(
            data: 'Monthly request quota has been exceeded',
            statusCode: 429,
            requestOptions: RequestOptions(path: '/auth'),
          ),
        ));

        final result = await datasource.login(invalidCredentials);

        expect(result.isLeft, true);
        result.fold(
          (error) => expect(error, isA<NetworkError>()),
          (_) => fail('Should not return success'),
        );
      });

      test('deve retornar ValidationError quando status 401', () async {
        when(() => mockDio.post('/auth', data: any(named: 'data')))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/auth'),
          response: Response(
            data: 'Unauthorized',
            statusCode: 401,
            requestOptions: RequestOptions(path: '/auth'),
          ),
        ));

        final result = await datasource.login(invalidCredentials);

        expect(result.isLeft, true);
        result.fold(
          (error) {
            expect(error, isA<ValidationError>());
            expect(error.message, 'Credenciais inválidas');
          },
          (_) => fail('Should not return success'),
        );
      });

      test('deve retornar UnknownError quando exceção desconhecida', () async {
        when(() => mockDio.post('/auth', data: any(named: 'data')))
            .thenThrow(Exception('Unknown'));

        final result = await datasource.login(validCredentials);

        expect(result.isLeft, true);
        result.fold(
          (error) {
            expect(error, isA<UnknownError>());
            expect(error.message, 'Ops! Aconteceu alguma coisa, tente novamente.');
          },
          (_) => fail('Should not return success'),
        );
      });
    });

    group('register', () {
      test('deve retornar Right quando dados válidos', () async {
        const model = AuthModel(login: 'newuser', password: 'password123');

        final result = await datasource.register(model);

        expect(result.isRight, true);
      });

      test('deve retornar ValidationError quando login vazio', () async {
        const model = AuthModel(login: '', password: 'password123');

        final result = await datasource.register(model);

        expect(result.isLeft, true);
        result.fold(
          (error) {
            expect(error, isA<ValidationError>());
            expect(error.message, 'Dados de cadastro inválidos');
          },
          (_) => fail('Should not return success'),
        );
      });

      test('deve retornar ValidationError quando password vazio', () async {
        const model = AuthModel(login: 'user', password: '');

        final result = await datasource.register(model);

        expect(result.isLeft, true);
        result.fold(
          (error) => expect(error, isA<ValidationError>()),
          (_) => fail('Should not return success'),
        );
      });
    });
  });
}
