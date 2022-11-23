import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/models/text_input_model.dart';
import 'package:flutter_todo/utils/consts/errors.dart';

const String emailPattern =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
const String passwordPattern = r'.{6,}';
const String usernamePattern = r'^.[A-Za-z0-9\s.-]{0,9}$';
const String todoPattern = r'^[\s.,!?a-zA-ZżźćńółęąśŻŹĆĄŚĘŁÓŃ0-9-]+$';

class ValidationService {
  static final provider = Provider.autoDispose<ValidationService>((ref) {
    return ValidationService();
  });

  TextInputModel validateEmail(String val) {
    bool emailValid = RegExp(emailPattern).hasMatch(val);
    if (!emailValid) {
      return const TextInputModel(valid: false, error: MyError.invalidEmail);
    }
    return const TextInputModel(valid: true, error: null);
  }

  TextInputModel validatePassword(String val) {
    bool passwordValidLength = RegExp(passwordPattern).hasMatch(val);
    if (!passwordValidLength) {
      return const TextInputModel(valid: false, error: MyError.invalidPassword);
    }
    return const TextInputModel(valid: true, error: null);
  }

  TextInputModel validateUsername(String val) {
    bool isValid = RegExp(usernamePattern).hasMatch(val);
    if (!isValid) {
      return const TextInputModel(valid: false, error: MyError.invalidUsername);
    }
    return const TextInputModel(valid: true, error: null);
  }

  TextInputModel validateTodo(String val) {
    bool isValid = RegExp(todoPattern).hasMatch(val);
    if (!isValid) {
      if (val.isEmpty) {
        return const TextInputModel(valid: false, error: null);
      } else {
        return const TextInputModel(valid: false, error: MyError.invalidTodo);
      }
    }
    return const TextInputModel(valid: true, error: null);
  }
}
