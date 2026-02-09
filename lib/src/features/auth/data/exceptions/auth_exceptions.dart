class AuthInvalidCredentialsException implements Exception {
  final String message;

  AuthInvalidCredentialsException(this.message);

  @override
  String toString() => message;
}

class AuthNetworkException implements Exception {
  final String message;

  AuthNetworkException(this.message);

  @override
  String toString() => message;
}
