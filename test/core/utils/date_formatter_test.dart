import 'package:flutter_test/flutter_test.dart';
import 'package:nortus/src/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter', () {
    group('formatRelativeTime', () {
      test('deve retornar "Agora há pouco" para menos de 1 minuto', () {
        final dateTime = DateTime.now().subtract(const Duration(seconds: 30));
        final result = formatRelativeTime(dateTime);
        expect(result, 'Agora há pouco');
      });

      test('deve retornar minutos atrás para menos de 1 hora', () {
        final dateTime = DateTime.now().subtract(const Duration(minutes: 5));
        final result = formatRelativeTime(dateTime);
        expect(result, '5 minutos atrás');
      });

      test('deve usar singular para 1 minuto', () {
        final dateTime = DateTime.now().subtract(const Duration(minutes: 1));
        final result = formatRelativeTime(dateTime);
        expect(result, '1 minuto atrás');
      });

      test('deve retornar horas atrás para menos de 24 horas', () {
        final dateTime = DateTime.now().subtract(const Duration(hours: 3));
        final result = formatRelativeTime(dateTime);
        expect(result, '3 horas atrás');
      });

      test('deve usar singular para 1 hora', () {
        final dateTime = DateTime.now().subtract(const Duration(hours: 1));
        final result = formatRelativeTime(dateTime);
        expect(result, '1 hora atrás');
      });

      test('deve retornar dias atrás para menos de 1 semana', () {
        final dateTime = DateTime.now().subtract(const Duration(days: 3));
        final result = formatRelativeTime(dateTime);
        expect(result, '3 dias atrás');
      });

      test('deve usar singular para 1 dia', () {
        final dateTime = DateTime.now().subtract(const Duration(days: 1));
        final result = formatRelativeTime(dateTime);
        expect(result, '1 dia atrás');
      });

      test('deve retornar semanas atrás para menos de 1 mês', () {
        final dateTime = DateTime.now().subtract(const Duration(days: 14));
        final result = formatRelativeTime(dateTime);
        expect(result, '2 semanas atrás');
      });

      test('deve usar singular para 1 semana', () {
        final dateTime = DateTime.now().subtract(const Duration(days: 7));
        final result = formatRelativeTime(dateTime);
        expect(result, '1 semana atrás');
      });

      test('deve retornar meses atrás para menos de 1 ano', () {
        final dateTime = DateTime.now().subtract(const Duration(days: 60));
        final result = formatRelativeTime(dateTime);
        expect(result, '2 meses atrás');
      });

      test('deve usar singular para 1 mês', () {
        final dateTime = DateTime.now().subtract(const Duration(days: 30));
        final result = formatRelativeTime(dateTime);
        expect(result, '1 mês atrás');
      });

      test('deve retornar anos atrás para mais de 1 ano', () {
        final dateTime = DateTime.now().subtract(const Duration(days: 730));
        final result = formatRelativeTime(dateTime);
        expect(result, '2 anos atrás');
      });

      test('deve usar singular para 1 ano', () {
        final dateTime = DateTime.now().subtract(const Duration(days: 365));
        final result = formatRelativeTime(dateTime);
        expect(result, '1 ano atrás');
      });
    });
  });
}
