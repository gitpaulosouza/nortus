import 'package:equatable/equatable.dart';

abstract class AppError extends Equatable implements Exception {
  final String message;
  AppError(this.message);

  @override
  List<Object?> get props => [message];
}

class NetworkError extends AppError {
  NetworkError(super.message);
}

class ServerError extends AppError {
  ServerError(super.message);
}

class UnknownError extends AppError {
  UnknownError(super.message);
}

class ValidationError extends AppError {
  ValidationError(super.message);
}

class NotFoundError extends AppError {
  NotFoundError(super.message);
}
