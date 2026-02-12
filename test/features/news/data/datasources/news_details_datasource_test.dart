import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nortus/src/core/error/app_error.dart';
import 'package:nortus/src/core/http/http_client.dart';
import 'package:nortus/src/core/http/http_exception.dart';
import 'package:nortus/src/core/http/http_response.dart';
import 'package:nortus/src/features/news/data/datasources/news_details_datasource_impl.dart';
import 'package:nortus/src/features/news/data/models/news_details_model.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late MockHttpClient mockHttpClient;
  late NewsDetailsDatasourceImpl datasource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = NewsDetailsDatasourceImpl(mockHttpClient);
  });

  group('NewsDetailsDataSource', () {
    group('fetchNewsDetails', () {
      test('deve retornar Right com NewsDetailsModel quando sucesso', () async {
        final responseData = <String, dynamic>{
          'id': 1,
          'title': 'Test News',
          'image': <String, dynamic>{'src': 'test.jpg', 'alt': 'Test'},
          'imageCaption': 'Caption',
          'categories': ['Tech'],
          'publishedAt': '2024-01-01T12:00:00Z',
          'newsResume': 'Resume',
          'estimatedReadingTime': '5 min',
          'authors': [],
          'description': 'Description',
          'relatedNews': [],
        };

        when(() => mockHttpClient.get('/news/1')).thenAnswer((_) async => HttpResponse(
              data: responseData,
              statusCode: 200,
            ));

        final result = await datasource.fetchNewsDetails(1);

        expect(result.isRight, true);
        result.fold(
          (error) => fail('Should not return error'),
          (data) {
            expect(data, isA<NewsDetailsModel>());
            expect(data.id, 1);
            expect(data.title, 'Test News');
          },
        );
      });

      test('deve retornar Left com ValidationError quando newsId <= 0', () async {
        final result = await datasource.fetchNewsDetails(0);

        expect(result.isLeft, true);
        result.fold(
          (error) {
            expect(error, isA<ValidationError>());
            expect(error.message, 'O ID da notícia deve ser maior que 0.');
          },
          (data) => fail('Should not return data'),
        );
      });

      test('deve retornar mock quando quota exceeded', () async {
        when(() => mockHttpClient.get('/news/1')).thenThrow(const HttpException(
          message: 'quota exceeded',
          statusCode: 429,
          data: 'quota exceeded',
        ));

        final result = await datasource.fetchNewsDetails(1);

        expect(result.isRight, true);
        result.fold(
          (error) => fail('Should return mock data'),
          (data) {
            expect(data, isA<NewsDetailsModel>());
            expect(data.id, 1);
          },
        );
      });

      test('deve retornar NetworkError quando status code não é 200 e não usa mock', () async {
        when(() => mockHttpClient.get('/news/1')).thenAnswer((_) async => const HttpResponse(
              data: null,
              statusCode: 500,
            ));

        final result = await datasource.fetchNewsDetails(1);

        expect(result.isLeft, true);
        result.fold(
          (error) {
            expect(error, isA<NetworkError>());
            expect(error.message, 'Erro de rede. Tente novamente.');
          },
          (data) => fail('Should not return data'),
        );
      });

      test('deve retornar UnknownError quando resposta inválida e não usa mock', () async {
        when(() => mockHttpClient.get('/news/1')).thenAnswer((_) async => const HttpResponse(
              data: 'invalid data',
              statusCode: 200,
            ));

        final result = await datasource.fetchNewsDetails(1);

        expect(result.isLeft, true);
        result.fold(
          (error) {
            expect(error, isA<UnknownError>());
            expect(error.message, 'Resposta inválida do servidor.');
          },
          (data) => fail('Should not return data'),
        );
      });

      test('deve usar mock quando wiremock no erro', () async {
        when(() => mockHttpClient.get('/news/1')).thenThrow(const HttpException(
          message: 'wiremock error',
        ));

        final result = await datasource.fetchNewsDetails(1);

        expect(result.isRight, true);
        result.fold(
          (error) => fail('Should return mock data'),
          (data) => expect(data, isA<NewsDetailsModel>()),
        );
      });

      test('deve retornar UnknownError quando exceção desconhecida', () async {
        when(() => mockHttpClient.get('/news/1')).thenThrow(Exception('Unknown'));

        final result = await datasource.fetchNewsDetails(1);

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
