class HttpResponse {
  final int? statusCode;
  final dynamic data;
  final Map<String, dynamic>? headers;

  const HttpResponse({this.statusCode, this.data, this.headers});
}
