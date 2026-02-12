class HttpException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const HttpException({required this.message, this.statusCode, this.data});

  @override
  String toString() => 'HttpException: $message (statusCode: $statusCode)';
}
