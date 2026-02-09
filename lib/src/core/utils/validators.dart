class Validators {
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static bool hasMinimumEmailLength(String email) {
    return email.length >= 5;
  }

  static bool isValidPassword(String password) {
    if (password.length < 8) return false;

    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);

    final hasNumber = RegExp(r'[0-9]').hasMatch(password);

    return hasLetter && hasNumber;
  }

  static bool passwordsMatch(String password, String confirmPassword) {
    return password.isNotEmpty && password == confirmPassword;
  }
}
