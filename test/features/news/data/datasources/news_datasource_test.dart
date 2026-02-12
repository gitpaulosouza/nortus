import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/core/http/http_client.dart';
import 'package:nortus/src/core/http/http_exception.dart';
import 'package:nortus/src/core/http/http_response.dart';
import 'package:nortus/src/features/news/data/datasources/news_datasource_impl.dart';
import 'package:nortus/src/features/news/data/models/news_list_response_model.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late MockHttpClient mockHttpClient;
  late NewsDatasourceImpl datasource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = NewsDatasourceImpl(mockHttpClient);
  });

  group('NewsDataSource', () {
    group('fetchNews', () {
      test('deve retornar Right com NewsListResponseModel quando sucesso', () async {
        final responseData = <String, dynamic>{
          'data': [
            <String, dynamic>{
              'id': 1,
              'title': 'Test News',
              'image': <String, dynamic>{'src': 'test.jpg', 'alt': 'Test'},
              'categories': [],
              'publishedAt': '2024-01-01T12:00:00Z',
              'summary': 'Test',
              'authors': [],
            },
          ],
          'page': 1,
          'totalPages': 10,
        };

        when(() => mockHttpClient.get('/news',
                queryParameters: any(named: 'queryParameters')))
            .thenAnswer((_) async => HttpResponse(
                  data: responseData,
                  statusCode: 200,
                ));

        final result = await datasource.fetchNews(page: 1);

        expect(result.isRight, true);
        result.fold(
          (error) => fail('Should not return error'),
          (data) {
            expect(data, isA<NewsListResponseModel>());
            expect(data.data.length, 1);
          },
        );
      });

      test('deve retornar Left com ValidationError quando page <= 0', () async {
        final result = await datasource.fetchNews(page: 0);

        expect(result.isLeft, true);
        result.fold(
          (error) {
            expect(error, isA<ValidationError>());
            expect(error.message, 'A página deve ser maior que 0.');
          },
          (data) => fail('Should not return data'),
        );
      });

      test('deve retornar Left com NetworkError quando DioException', () async {
        when(() => mockHttpClient.get('/news',
                queryParameters: any(named: 'queryParameters')))
            .thenThrow(const HttpException(
          message: 'Network error',
          statusCode: 500,
          data: 'Network error',
        ));

        final result = await datasource.fetchNews(page: 1);

        expect(result.isLeft, true);
        result.fold(
          (error) {
            expect(error, isA<NetworkError>());
          },
          (data) => fail('Should not return data'),
        );
      });

      test('deve extrair mensagem de erro do servidor quando disponível', () async {
        when(() => mockHttpClient.get('/news',
                queryParameters: any(named: 'queryParameters')))
            .thenThrow(const HttpException(
          message: 'Custom error message',
          statusCode: 400,
          data: <String, dynamic>{
            'errors': ['Custom error message'],
          },
        ));

        final result = await datasource.fetchNews(page: 1);

        result.fold(
          (error) {
            expect(error.message, 'Custom error message');
          },
          (data) => fail('Should not return data'),
        );
      });

      test('deve retornar UnknownError quando exceção desconhecida', () async {
        when(() => mockHttpClient.get('/news',
                queryParameters: any(named: 'queryParameters')))
            .thenThrow(Exception('Unknown'));

        final result = await datasource.fetchNews(page: 1);

        expect(result.isLeft, true);
        result.fold(
          (error) {
            expect(error, isA<UnknownError>());
            expect(error.message, 'Ops! Aconteceu alguma coisa, tente novamente.');
          },
          (data) => fail('Should not return data'),
        );
      });
    });
  });
}
