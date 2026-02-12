import 'package:dio/dio.dart';
import 'package:nortus/src/core/http/http_client.dart';
import 'package:nortus/src/core/http/http_exception.dart';
import 'package:nortus/src/core/http/http_response.dart';

class DioHttpClient implements HttpClient {
  final Dio _dio;

  DioHttpClient(this._dio);

  @override
  Future<HttpResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );

      return _mapResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<HttpResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );

      return _mapResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<HttpResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );

      return _mapResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<HttpResponse> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );

      return _mapResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  HttpResponse _mapResponse(Response response) {
    return HttpResponse(
      statusCode: response.statusCode,
      data: response.data,
      headers: response.headers.map.map(
        (key, value) => MapEntry(key, value.join(', ')),
      ),
    );
  }

  HttpException _mapDioException(DioException e) {
    return HttpException(
      message: e.message ?? 'Unknown error',
      statusCode: e.response?.statusCode,
      data: e.response?.data,
    );
  }
}
