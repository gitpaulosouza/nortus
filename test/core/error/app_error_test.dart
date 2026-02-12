import 'package:flutter_test/flutter_test.dart';
import 'package:nortus/src/core/error/app_error.dart';

void main() {
  group('AppError', () {
    group('NetworkError', () {
      test('deve criar NetworkError com mensagem', () {
        final error = NetworkError('Erro de rede');

        expect(error, isA<AppError>());
        expect(error, isA<Exception>());
        expect(error.message, 'Erro de rede');
      });

      test('deve ser Exception', () {
        final error = NetworkError('Teste');
        expect(error, isA<Exception>());
      });
    });

    group('ServerError', () {
      test('deve criar ServerError com mensagem', () {
        final error = ServerError('Erro do servidor');

        expect(error, isA<AppError>());
        expect(error, isA<Exception>());
        expect(error.message, 'Erro do servidor');
      });
    });

    group('UnknownError', () {
      test('deve criar UnknownError com mensagem', () {
        final error = UnknownError('Erro desconhecido');

        expect(error, isA<AppError>());
        expect(error, isA<Exception>());
        expect(error.message, 'Erro desconhecido');
      });
    });

    group('ValidationError', () {
      test('deve criar ValidationError com mensagem', () {
        final error = ValidationError('Dados inválidos');

        expect(error, isA<AppError>());
        expect(error, isA<Exception>());
        expect(error.message, 'Dados inválidos');
      });
    });

    group('NotFoundError', () {
      test('deve criar NotFoundError com mensagem', () {
        final error = NotFoundError('Não encontrado');

        expect(error, isA<AppError>());
        expect(error, isA<Exception>());
        expect(error.message, 'Não encontrado');
      });
    });

    group('Herança', () {
      test('todos os erros devem estender AppError', () {
        expect(NetworkError('test'), isA<AppError>());
        expect(ServerError('test'), isA<AppError>());
        expect(UnknownError('test'), isA<AppError>());
        expect(ValidationError('test'), isA<AppError>());
        expect(NotFoundError('test'), isA<AppError>());
      });

      test('todos os erros devem ser Exception', () {
        expect(NetworkError('test'), isA<Exception>());
        expect(ServerError('test'), isA<Exception>());
        expect(UnknownError('test'), isA<Exception>());
        expect(ValidationError('test'), isA<Exception>());
        expect(NotFoundError('test'), isA<Exception>());
      });
    });
  });
}
