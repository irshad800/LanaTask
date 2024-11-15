import 'package:email_validator/email_validator.dart';

class InputValidation {
  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is required';
    }
    if (!EmailValidator.validate(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  static String? validatePhone(String value) {
    if (value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length < 10) {
      return 'Invalid phone number';
    }
    return null;
  }
}
