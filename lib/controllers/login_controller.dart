import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/models/login_state_model.dart';
import 'package:flutter_todo/services/auth_service.dart';
import 'package:flutter_todo/services/validation_service.dart';

class LoginState extends StateNotifier<LoginStateModel> {
  LoginState() : super(const LoginStateModel.initial());

  static final provider =
      StateNotifierProvider.autoDispose<LoginState, LoginStateModel>(
          (ref) => LoginState());

  bool get areInputsValid => state.email.valid && state.password.valid;

  _setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  _switchForm(LoginType currentType) {
    state = state.copyWith(
        type: currentType == LoginType.signIn
            ? LoginType.signUp
            : LoginType.signIn);
  }

  _setAuthError(String? error) {
    state = state.copyWith(authError: error);
  }

  _updateEmail(TextInputModel email) {
    state = state.copyWith(email: email);
  }

  _updatePassword(TextInputModel password) {
    state = state.copyWith(password: password);
  }
}

class LoginController {
  LoginController(this._ref);

  static final provider = Provider.autoDispose((ref) => LoginController(ref));
  final Ref _ref;

  //method used to clear auth error when login succeeds or user taps input
  clearAuthError() {
    _ref.read(LoginState.provider.notifier)._setAuthError(null);
  }

  switchForm(LoginType currentType) {
    _ref.invalidate(LoginState.provider);
    _ref.read(LoginState.provider.notifier)._switchForm(currentType);
  }

  void validateEmail(String input) {
    final TextInputModel result =
        _ref.read(ValidationService.provider).validateEmail(input);
    _ref.read(LoginState.provider.notifier)._updateEmail(result);
  }

  void validatePassword(String input) {
    final TextInputModel result =
        _ref.read(ValidationService.provider).validatePassword(input);
    _ref.read(LoginState.provider.notifier)._updatePassword(result);
  }

  authenticateEmail({required String email, required String password}) async {
    //start loading
    _ref.read(LoginState.provider.notifier)._setLoading(true);
    debugPrint('email: $email');
    debugPrint('pass: $password');
    final String? authResult;
    switch (_ref.read(LoginState.provider).type) {
      case LoginType.signIn:
        authResult = await _ref
            .read(AuthService.provider)
            .signInEmail(email.toLowerCase(), password);
        break;
      case LoginType.signUp:
        authResult = await _ref
            .read(AuthService.provider)
            .signUpEmail(email.toLowerCase(), password);
        break;
    }
    if (authResult != null) {
      _ref.read(LoginState.provider.notifier)._setAuthError(authResult);
      //stop loading
      _ref.read(LoginState.provider.notifier)._setLoading(false);
    }
  }

  authenticateGoogle() async {
    final String? authResult =
        await _ref.read(AuthService.provider).signInGoogle();
    if (authResult != null) {
      _ref.read(LoginState.provider.notifier)._setAuthError(authResult);
    }
    _ref.read(LoginState.provider.notifier)._setAuthError(null);
  }
}
