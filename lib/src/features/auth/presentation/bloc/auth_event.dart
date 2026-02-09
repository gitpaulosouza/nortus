import 'package:nortus/src/features/auth/presentation/bloc/auth_form_mode.dart';

abstract class AuthEvent {}

class AuthModeChanged extends AuthEvent {
  final AuthFormMode mode;
  AuthModeChanged(this.mode);
}

class AuthEmailChanged extends AuthEvent {
  final String email;
  AuthEmailChanged(this.email);
}

class AuthPasswordChanged extends AuthEvent {
  final String password;
  AuthPasswordChanged(this.password);
}

class AuthConfirmPasswordChanged extends AuthEvent {
  final String password;
  AuthConfirmPasswordChanged(this.password);
}

class AuthTogglePasswordVisibility extends AuthEvent {}

class AuthToggleConfirmPasswordVisibility extends AuthEvent {}

class AuthToggleKeepLoggedIn extends AuthEvent {}

class AuthSubmitRequested extends AuthEvent {}
