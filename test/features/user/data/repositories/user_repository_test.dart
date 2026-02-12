import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/user/data/datasources/user_datasource.dart';
import 'package:nortus/src/features/user/data/models/adress_user_model.dart';
import 'package:nortus/src/features/user/data/models/user_model.dart';
import 'package:nortus/src/features/user/data/repositories/user_repository.dart';

class MockUserDatasource extends Mock implements UserDatasource {}

void main() {
  late MockUserDatasource mockDatasource;
  late UserRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockUserDatasource();
    repository = UserRepositoryImpl(mockDatasource);
  });

  setUpAll(() {
    registerFallbackValue(UserModel(
      id: 0,
      name: '',
      email: '',
      language: '',
      dateFormat: '',
      timezone: '',
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
      updatedAt: DateTime.now(),
    ));
  });

  group('UserRepository', () {
    final mockUser = UserModel(
      id: 1,
      name: 'John Doe',
      email: 'john@example.com',
      language: 'pt',
      dateFormat: 'DD/MM/YYYY',
      timezone: 'America/Sao_Paulo',
      address: const AdressUserModel(
        zipCode: '12345',
        country: 'Brazil',
        street: 'Test St',
        number: '123',
        complement: '',
        neighborhood: 'Center',
        city: 'City',
        state: 'ST',
      ),
      updatedAt: DateTime.parse('2024-01-01T12:00:00Z'),
    );

    group('getUser', () {
      test('deve delegar para datasource e retornar Right com user', () async {
        when(() => mockDatasource.getUser())
            .thenAnswer((_) async => Right(mockUser));

        final result = await repository.getUser();

        expect(result.isRight, true);
        result.fold(
          (error) => fail('Should not return error'),
          (user) => expect(user, mockUser),
        );
        verify(() => mockDatasource.getUser()).called(1);
      });

      test('deve propagar erro do datasource', () async {
        when(() => mockDatasource.getUser())
            .thenAnswer((_) async => Left(NetworkError('Erro de rede')));

        final result = await repository.getUser();

        expect(result.isLeft, true);
        result.fold(
          (error) {
            expect(error, isA<NetworkError>());
            expect(error.message, 'Erro de rede');
          },
          (user) => fail('Should not return user'),
        );
      });
    });

    group('updateUser', () {
      test('deve delegar para datasource e retornar Right', () async {
        when(() => mockDatasource.updateUser(any()))
            .thenAnswer((_) async => Right(mockUser));

        final result = await repository.updateUser(mockUser);

        expect(result.isRight, true);
        verify(() => mockDatasource.updateUser(mockUser)).called(1);
      });

      test('deve propagar erro do datasource', () async {
        when(() => mockDatasource.updateUser(any()))
            .thenAnswer((_) async => Left(ValidationError('Dados inválidos')));

        final result = await repository.updateUser(mockUser);

        expect(result.isLeft, true);
        result.fold(
          (error) {
            expect(error, isA<ValidationError>());
            expect(error.message, 'Dados inválidos');
          },
          (user) => fail('Should not return user'),
        );
      });
    });
  });
}
