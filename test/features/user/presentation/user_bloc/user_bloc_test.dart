import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/user/data/models/adress_user_model.dart';
import 'package:nortus/src/features/user/data/models/user_model.dart';
import 'package:nortus/src/features/user/data/repositories/user_repository.dart';
import 'package:nortus/src/features/user/presentation/user_bloc/user_bloc.dart';
import 'package:nortus/src/features/user/presentation/user_bloc/user_event.dart';
import 'package:nortus/src/features/user/presentation/user_bloc/user_state.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockRepository;
  late UserBloc bloc;

  setUp(() {
    mockRepository = MockUserRepository();
    bloc = UserBloc(mockRepository);
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

  group('UserBloc', () {
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

    test('estado inicial deve estar correto', () {
      expect(bloc.state, UserState.initial());
      expect(bloc.state.isLoading, false);
      expect(bloc.state.user, null);
    });

    blocTest<UserBloc, UserState>(
      'deve carregar user com sucesso ao iniciar',
      build: () {
        when(() => mockRepository.getUser())
            .thenAnswer((_) async => Right(mockUser));
        return UserBloc(mockRepository);
      },
      act: (bloc) => bloc.add(const UserStarted()),
      expect: () => [
        UserState.initial().copyWith(isLoading: true),
        UserState.initial().copyWith(
          user: mockUser,
          draft: mockUser,
          isLoading: false,
          hasUnsavedChanges: false,
        ),
      ],
    );

    blocTest<UserBloc, UserState>(
      'deve lidar com erro ao carregar user',
      build: () {
        when(() => mockRepository.getUser())
            .thenAnswer((_) async => Left(NetworkError('Erro de rede')));
        return UserBloc(mockRepository);
      },
      act: (bloc) => bloc.add(const UserStarted()),
      expect: () => [
        UserState.initial().copyWith(isLoading: true),
        UserState.initial().copyWith(
          isLoading: false,
          error: NetworkError('Erro de rede'),
        ),
      ],
    );

    blocTest<UserBloc, UserState>(
      'deve atualizar nome e marcar como mudado',
      build: () {
        when(() => mockRepository.getUser())
            .thenAnswer((_) async => Right(mockUser));
        return UserBloc(mockRepository);
      },
      seed: () => UserState.initial().copyWith(
        user: mockUser,
        draft: mockUser,
      ),
      act: (bloc) => bloc.add(const UserNameChanged('Jane Doe')),
      expect: () => [
        UserState.initial().copyWith(
          user: mockUser,
          draft: mockUser.copyWith(name: 'Jane Doe'),
          hasUnsavedChanges: true,
        ),
      ],
    );

    blocTest<UserBloc, UserState>(
      'deve cancelar edição e restaurar draft',
      build: () => UserBloc(mockRepository),
      seed: () => UserState.initial().copyWith(
        user: mockUser,
        draft: mockUser.copyWith(name: 'Changed'),
        hasUnsavedChanges: true,
      ),
      act: (bloc) => bloc.add(const UserEditCanceled()),
      expect: () => [
        UserState.initial().copyWith(
          user: mockUser,
          draft: mockUser,
          hasUnsavedChanges: false,
        ),
      ],
    );

    blocTest<UserBloc, UserState>(
      'deve salvar user com sucesso',
      build: () {
        final updatedUser = mockUser.copyWith(name: 'Updated Name');
        when(() => mockRepository.updateUser(any()))
            .thenAnswer((_) async => Right(updatedUser));
        return UserBloc(mockRepository);
      },
      seed: () => UserState.initial().copyWith(
        user: mockUser,
        draft: mockUser.copyWith(name: 'Updated Name'),
        hasUnsavedChanges: true,
      ),
      act: (bloc) => bloc.add(const UserSaveRequested()),
      expect: () => [
        UserState.initial().copyWith(
          user: mockUser,
          draft: mockUser.copyWith(name: 'Updated Name'),
          hasUnsavedChanges: true,
          isSaving: true,
        ),
        UserState.initial().copyWith(
          user: mockUser.copyWith(name: 'Updated Name'),
          draft: mockUser.copyWith(name: 'Updated Name'),
          isSaving: false,
          hasUnsavedChanges: false,
          saveSuccess: true,
        ),
      ],
    );

    blocTest<UserBloc, UserState>(
      'deve retornar erro de validação quando nome vazio',
      build: () => UserBloc(mockRepository),
      seed: () => UserState.initial().copyWith(
        user: mockUser,
        draft: mockUser.copyWith(name: ''),
      ),
      act: (bloc) => bloc.add(const UserSaveRequested()),
      expect: () => [
        UserState.initial().copyWith(
          user: mockUser,
          draft: mockUser.copyWith(name: ''),
          error: ValidationError('Nome é obrigatório'),
        ),
      ],
    );

    blocTest<UserBloc, UserState>(
      'deve retornar erro de validação quando email inválido',
      build: () => UserBloc(mockRepository),
      seed: () => UserState.initial().copyWith(
        user: mockUser,
        draft: mockUser.copyWith(email: 'invalid-email'),
      ),
      act: (bloc) => bloc.add(const UserSaveRequested()),
      expect: () => [
        UserState.initial().copyWith(
          user: mockUser,
          draft: mockUser.copyWith(email: 'invalid-email'),
          error: ValidationError('E-mail inválido'),
        ),
      ],
    );
  });
}

extension on UserModel {
  UserModel copyWith({
    String? name,
    String? email,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      language: language,
      dateFormat: dateFormat,
      timezone: timezone,
      address: address,
      updatedAt: updatedAt,
    );
  }
}
