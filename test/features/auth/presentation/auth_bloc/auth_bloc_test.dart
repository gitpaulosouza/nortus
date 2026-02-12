import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/features/auth/data/models/auth_model.dart';
import 'package:nortus/src/features/auth/data/repositories/auth_repository.dart';
import 'package:nortus/src/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:nortus/src/features/auth/presentation/auth_bloc/auth_event.dart';
import 'package:nortus/src/features/auth/presentation/auth_bloc/auth_form_mode.dart';
import 'package:nortus/src/features/auth/presentation/auth_bloc/auth_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late AuthBloc bloc;

  setUp(() {
    mockRepository = MockAuthRepository();
    bloc = AuthBloc(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(const AuthModel(login: '', password: ''));
  });

  group('AuthBloc', () {
    test('estado inicial deve estar correto', () {
      expect(bloc.state, AuthState.initial());
      expect(bloc.state.mode, AuthFormMode.login);
      expect(bloc.state.email, '');
      expect(bloc.state.isSubmitting, false);
    });

    blocTest<AuthBloc, AuthState>(
      'deve mudar modo para registro',
      build: () => AuthBloc(mockRepository),
      act: (bloc) => bloc.add(AuthModeChanged(AuthFormMode.register)),
      expect: () => [
        AuthState.initial().copyWith(
          mode: AuthFormMode.register,
          password: '',
          confirmPassword: '',
          isPasswordValid: false,
          isConfirmPasswordValid: false,
          showPasswordField: false,
          isRegistrationSuccess: false,
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'deve atualizar email e validar',
      build: () => AuthBloc(mockRepository),
      act: (bloc) => bloc.add(AuthEmailChanged('test@example.com')),
      expect: () => [
        AuthState.initial().copyWith(
          email: 'test@example.com',
          isEmailValid: true,
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'deve marcar email como inválido se muito curto',
      build: () => AuthBloc(mockRepository),
      act: (bloc) => bloc.add(AuthEmailChanged('ab')),
      expect: () => [
        AuthState.initial().copyWith(
          email: 'ab',
          isEmailValid: false,
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'deve atualizar password e validar',
      build: () => AuthBloc(mockRepository),
      act: (bloc) => bloc.add(AuthPasswordChanged('Password123!')),
      expect: () => [
        AuthState.initial().copyWith(
          password: 'Password123!',
          isPasswordValid: true,
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'deve alternar visibilidade da senha',
      build: () => AuthBloc(mockRepository),
      act: (bloc) => bloc.add(AuthTogglePasswordVisibility()),
      expect: () => [
        AuthState.initial().copyWith(isPasswordVisible: true),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'deve alternar keep logged in',
      build: () => AuthBloc(mockRepository),
      act: (bloc) => bloc.add(AuthToggleKeepLoggedIn()),
      expect: () => [
        AuthState.initial().copyWith(keepLoggedIn: true),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'deve mostrar campo de senha ao submeter sem senha visível',
      build: () => AuthBloc(mockRepository),
      seed: () => AuthState.initial().copyWith(
        email: 'test@example.com',
        isEmailValid: true,
      ),
      act: (bloc) => bloc.add(AuthSubmitRequested()),
      expect: () => [
        AuthState.initial().copyWith(
          email: 'test@example.com',
          isEmailValid: true,
          showPasswordField: true,
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'deve fazer login com sucesso',
      build: () {
        when(() => mockRepository.login(any(), keepLoggedIn: any(named: 'keepLoggedIn')))
            .thenAnswer((_) async => const Right(null));
        return AuthBloc(mockRepository);
      },
      seed: () => AuthState.initial().copyWith(
        email: 'test@example.com',
        password: 'Password123!',
        isEmailValid: true,
        isPasswordValid: true,
        showPasswordField: true,
      ),
      act: (bloc) => bloc.add(AuthSubmitRequested()),
      expect: () => [
        AuthState.initial().copyWith(
          email: 'test@example.com',
          password: 'Password123!',
          isEmailValid: true,
          isPasswordValid: true,
          showPasswordField: true,
          isSubmitting: true,
        ),
        AuthState.initial().copyWith(
          email: 'test@example.com',
          password: 'Password123!',
          isEmailValid: true,
          isPasswordValid: true,
          showPasswordField: true,
          isSubmitting: false,
          isSuccess: true,
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'deve lidar com erro de login',
      build: () {
        when(() => mockRepository.login(any(), keepLoggedIn: any(named: 'keepLoggedIn')))
            .thenAnswer((_) async => Left(ValidationError('Credenciais inválidas')));
        return AuthBloc(mockRepository);
      },
      seed: () => AuthState.initial().copyWith(
        email: 'test@example.com',
        password: 'wrong',
        isEmailValid: true,
        isPasswordValid: true,
        showPasswordField: true,
      ),
      act: (bloc) => bloc.add(AuthSubmitRequested()),
      expect: () => [
        AuthState.initial().copyWith(
          email: 'test@example.com',
          password: 'wrong',
          isEmailValid: true,
          isPasswordValid: true,
          showPasswordField: true,
          isSubmitting: true,
        ),
        AuthState.initial().copyWith(
          email: 'test@example.com',
          password: 'wrong',
          isEmailValid: true,
          isPasswordValid: true,
          showPasswordField: true,
          isSubmitting: false,
          isSuccess: false,
          errorMessage: 'Credenciais inválidas',
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'deve fazer registro com sucesso',
      build: () {
        when(() => mockRepository.register(any()))
            .thenAnswer((_) async => const Right(null));
        return AuthBloc(mockRepository);
      },
      seed: () => AuthState.initial().copyWith(
        mode: AuthFormMode.register,
        email: 'new@example.com',
        password: 'Password123!',
        confirmPassword: 'Password123!',
        isEmailValid: true,
        isPasswordValid: true,
        isConfirmPasswordValid: true,
      ),
      act: (bloc) => bloc.add(AuthSubmitRequested()),
      expect: () => [
        AuthState.initial().copyWith(
          mode: AuthFormMode.register,
          email: 'new@example.com',
          password: 'Password123!',
          confirmPassword: 'Password123!',
          isEmailValid: true,
          isPasswordValid: true,
          isConfirmPasswordValid: true,
          isSubmitting: true,
        ),
        AuthState.initial().copyWith(
          mode: AuthFormMode.register,
          email: 'new@example.com',
          password: 'Password123!',
          confirmPassword: 'Password123!',
          isEmailValid: true,
          isPasswordValid: true,
          isConfirmPasswordValid: true,
          isSubmitting: false,
          isSuccess: false,
          isRegistrationSuccess: true,
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'deve fazer logout com sucesso',
      build: () {
        when(() => mockRepository.logout())
            .thenAnswer((_) async => const Right(null));
        return AuthBloc(mockRepository);
      },
      act: (bloc) => bloc.add(AuthLogoutRequested()),
      expect: () => [
        AuthState.initial().copyWith(isSubmitting: true),
        AuthState.initial().copyWith(
          isSubmitting: false,
          isSuccess: false,
          isLogoutSuccess: true,
        ),
      ],
    );
  });
}
