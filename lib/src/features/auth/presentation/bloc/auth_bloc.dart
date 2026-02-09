import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nortus/src/core/utils/validators.dart';
import 'package:nortus/src/features/auth/data/models/auth_model.dart';
import 'package:nortus/src/features/auth/data/repositories/auth_repository.dart';
import 'package:nortus/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:nortus/src/features/auth/presentation/bloc/auth_form_mode.dart';
import 'package:nortus/src/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthState.initial()) {
    on<AuthModeChanged>(_onModeChanged);
    on<AuthEmailChanged>(_onEmailChanged);
    on<AuthPasswordChanged>(_onPasswordChanged);
    on<AuthConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<AuthTogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<AuthToggleConfirmPasswordVisibility>(_onToggleConfirmPasswordVisibility);
    on<AuthToggleKeepLoggedIn>(_onToggleKeepLoggedIn);
    on<AuthSubmitRequested>(_onSubmitRequested);
  }

  void _onModeChanged(AuthModeChanged event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        mode: event.mode,
        password: '',
        confirmPassword: '',
        isPasswordValid: false,
        isConfirmPasswordValid: false,
        showPasswordField: false,
        isRegistrationSuccess: false,
        clearError: true,
      ),
    );
  }

  void _onEmailChanged(AuthEmailChanged event, Emitter<AuthState> emit) {
    final isValid = Validators.hasMinimumEmailLength(event.email);

    emit(
      state.copyWith(
        email: event.email,
        isEmailValid: isValid,
        clearError: true,
      ),
    );
  }

  void _onPasswordChanged(AuthPasswordChanged event, Emitter<AuthState> emit) {
    final isValid = Validators.isValidPassword(event.password);
    final isConfirmValid =
        state.mode == AuthFormMode.register
            ? Validators.passwordsMatch(event.password, state.confirmPassword)
            : state.isConfirmPasswordValid;

    emit(
      state.copyWith(
        password: event.password,
        isPasswordValid: isValid,
        isConfirmPasswordValid: isConfirmValid,
        clearError: true,
      ),
    );
  }

  void _onConfirmPasswordChanged(
    AuthConfirmPasswordChanged event,
    Emitter<AuthState> emit,
  ) {
    final isValid = Validators.passwordsMatch(state.password, event.password);
    emit(
      state.copyWith(
        confirmPassword: event.password,
        isConfirmPasswordValid: isValid,
        clearError: true,
      ),
    );
  }

  void _onTogglePasswordVisibility(
    AuthTogglePasswordVisibility event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void _onToggleConfirmPasswordVisibility(
    AuthToggleConfirmPasswordVisibility event,
    Emitter<AuthState> emit,
  ) {
    emit(
      state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible),
    );
  }

  void _onToggleKeepLoggedIn(
    AuthToggleKeepLoggedIn event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(keepLoggedIn: !state.keepLoggedIn));
  }

  Future<void> _onSubmitRequested(
    AuthSubmitRequested event,
    Emitter<AuthState> emit,
  ) async {
    // If in login mode and password field not shown yet, just show it
    if (state.mode == AuthFormMode.login && !state.showPasswordField) {
      emit(state.copyWith(showPasswordField: true));
      return;
    }

    if (!state.canSubmit) return;

    emit(state.copyWith(isSubmitting: true, clearError: true));

    final model = AuthModel(login: state.email, password: state.password);

    final result =
        state.mode == AuthFormMode.login
            ? await repository.login(model, keepLoggedIn: state.keepLoggedIn)
            : await repository.register(model);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isSubmitting: false,
            errorMessage: failure.message,
            isSuccess: false,
          ),
        );
      },
      (_) {
        if (state.mode == AuthFormMode.login) {
          // Login successful - authenticate user
          emit(state.copyWith(isSubmitting: false, isSuccess: true));
        } else {
          // Registration successful - do NOT authenticate, return to login
          emit(
            state.copyWith(
              isSubmitting: false,
              isRegistrationSuccess: true,
              isSuccess: false,
            ),
          );
        }
      },
    );
  }
}
