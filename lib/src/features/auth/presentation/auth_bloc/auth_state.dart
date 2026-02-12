import 'package:nortus/src/features/auth/presentation/auth_bloc/auth_form_mode.dart';

class AuthState {
  final AuthFormMode mode;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool keepLoggedIn;
  final bool isSubmitting;
  final String? errorMessage;
  final bool isSuccess;
  final bool isRegistrationSuccess;
  final bool isLogoutSuccess;
  final bool showPasswordField;

  AuthState({
    required this.mode,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.isConfirmPasswordValid,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.keepLoggedIn,
    required this.isSubmitting,
    this.errorMessage,
    this.isSuccess = false,
    this.isRegistrationSuccess = false,
    this.isLogoutSuccess = false,
    this.showPasswordField = false,
  });

  factory AuthState.initial() {
    return AuthState(
      mode: AuthFormMode.login,
      email: '',
      password: '',
      confirmPassword: '',
      isEmailValid: false,
      isPasswordValid: false,
      isConfirmPasswordValid: false,
      isPasswordVisible: false,
      isConfirmPasswordVisible: false,
      keepLoggedIn: false,
      isSubmitting: false,
      errorMessage: null,
      isSuccess: false,
      isRegistrationSuccess: false,
      isLogoutSuccess: false,
      showPasswordField: false,
    );
  }

  AuthState copyWith({
    AuthFormMode? mode,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isConfirmPasswordValid,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? keepLoggedIn,
    bool? isSubmitting,
    String? errorMessage,
    bool? isSuccess,
    bool? isRegistrationSuccess,
    bool? isLogoutSuccess,
    bool? showPasswordField,
    bool clearError = false,
  }) {
    return AuthState(
      mode: mode ?? this.mode,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isConfirmPasswordValid:
          isConfirmPasswordValid ?? this.isConfirmPasswordValid,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      keepLoggedIn: keepLoggedIn ?? this.keepLoggedIn,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSuccess: isSuccess ?? this.isSuccess,
      isRegistrationSuccess:
          isRegistrationSuccess ?? this.isRegistrationSuccess,
      isLogoutSuccess: isLogoutSuccess ?? this.isLogoutSuccess,
      showPasswordField: showPasswordField ?? this.showPasswordField,
    );
  }

  bool get canSubmit {
    if (mode == AuthFormMode.login) {
      return isEmailValid && isPasswordValid;
    } else {
      return isEmailValid && isPasswordValid && isConfirmPasswordValid;
    }
  }
}
