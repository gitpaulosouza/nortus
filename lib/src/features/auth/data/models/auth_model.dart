class AuthModel {
  final String login;
  final String password;

  const AuthModel({required this.login, required this.password});

  Map<String, dynamic> toJson() {
    return {'login': login, 'password': password};
  }
}
