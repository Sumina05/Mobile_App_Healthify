/// Form validators shared by every feature.
abstract final class Validators {
  static final RegExp _emailPattern =
      RegExp(r'^[\w.+-]+@[a-zA-Z\d-]+(\.[a-zA-Z\d-]+)+$');

  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? email(String? value) {
    final requiredError = required(value, field: 'Email');
    if (requiredError != null) return requiredError;
    if (!_emailPattern.hasMatch(value!.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    final requiredError = required(value, field: 'Password');
    if (requiredError != null) return requiredError;
    if (value!.length < 8) return 'Password must be at least 8 characters';
    if (!value.contains(RegExp(r'[A-Za-z]')) ||
        !value.contains(RegExp(r'\d'))) {
      return 'Password must contain letters and numbers';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    final requiredError = required(value, field: 'Confirm password');
    if (requiredError != null) return requiredError;
    if (value != original) return 'Passwords do not match';
    return null;
  }

  static String? name(String? value) {
    final requiredError = required(value, field: 'Name');
    if (requiredError != null) return requiredError;
    if (value!.trim().length < 2) return 'Name is too short';
    return null;
  }
}
