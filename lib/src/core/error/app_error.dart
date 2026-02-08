abstract class AppError implements Exception {
  final String message;
  AppError(this.message);
}

class NetworkError extends AppError {
  NetworkError(String message) : super(message);
}

class ServerError extends AppError {
  ServerError(String message) : super(message);
}

class UnknownError extends AppError {
  UnknownError(String message) : super(message);
}

class ValidationError extends AppError {
  ValidationError(String message) : super(message);
}

class NotFoundError extends AppError {
  NotFoundError(String message) : super(message);
}
