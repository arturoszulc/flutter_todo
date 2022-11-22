import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/models/login_state_model.dart';
import 'package:flutter_todo/utils/consts/errors.dart';

const String emailPattern =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
const String passwordPatternLength = r'.{6,}';

class ValidationService {
  static final provider = Provider.autoDispose<ValidationService>((ref) {
    return ValidationService();
  });

  TextInputModel validateEmail(String val) {
    bool emailValid = RegExp(emailPattern).hasMatch(val);
    if (!emailValid) {
      return const TextInputModel(valid: false, error: MyError.invalidEmail);
    } else {
      return const TextInputModel(valid: true, error: null);
    }
  }

  TextInputModel validatePassword(String val) {
    bool passwordValidLength = RegExp(passwordPatternLength).hasMatch(val);
    if (!passwordValidLength) {
      return const TextInputModel(valid: false, error: MyError.invalidPassword);
    } else {
      return const TextInputModel(valid: true, error: null);
    }
  }
}
