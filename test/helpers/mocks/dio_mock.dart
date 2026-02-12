import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

class MockDio extends Mock implements Dio {}

class MockResponse<T> extends Mock implements Response<T> {
  MockResponse({
    required this.data,
    required this.statusCode,
    required this.requestOptions,
  });

  @override
  final T data;
  
  @override
  final int? statusCode;
  
  @override
  final RequestOptions requestOptions;
}
