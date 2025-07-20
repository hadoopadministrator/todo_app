// ========= FormValidators =============
class FormValidators {
  // User ID: starts with a letter, allows letters, digits, and underscore, min 4 chars
  static final RegExp _userIdRegex = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]{3,}$');

  // Name: only letters and spaces, min 3 characters
  static final RegExp _nameRegex = RegExp(r'^[a-zA-Z\s]{3,}$');

  // Email: standard format
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Password: min 6 characters, must include upper, lower, number, special character
  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{6,}$',
  );

  // User ID Validator
  static String? validateUserId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter User ID';
    }

    final trimmedValue = value.trim();

    if (!_userIdRegex.hasMatch(trimmedValue)) {
      return 'User ID must start with a letter and\ncontain letters, digits, or underscore\n(min 4 characters)';
    }

    return null;
  }

  // Name Validator
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }

    final trimmedValue = value.trim();

    if (!_nameRegex.hasMatch(trimmedValue)) {
      return 'Name must contain only letters and spaces\n(min 3 characters)';
    }

    return null;
  }

  // Email Validator
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    final trimmedValue = value.trim();

    if (!_emailRegex.hasMatch(trimmedValue)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  // Password Validator
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your password';
    }

    final trimmedValue = value.trim();

    if (!_passwordRegex.hasMatch(trimmedValue)) {
      return 'Password must be at least 6 characters\nand include upper, lower, number, and special character';
    }

    return null;
  }
}
