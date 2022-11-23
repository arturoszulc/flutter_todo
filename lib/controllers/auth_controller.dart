import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/models/auth_model.dart';
import 'package:flutter_todo/services/auth_service.dart';
import 'package:flutter_todo/services/validation_service.dart';

import '../models/text_input_model.dart';

final emailController = Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  log('*** emailController created ***');
  ref.onDispose(() {
    log('*** emailController disposed ***');
    controller.dispose();
  });
  return controller;
});

final passwordController = Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  log('*** passwordController created ***');
  ref.onDispose(() {
    log('*** passwordController disposed ***');
    controller.dispose();
  });
  return controller;
});

class AuthState extends StateNotifier<AuthModel> {
  AuthState() : super(const AuthModel.initial());

  static final provider =
      StateNotifierProvider.autoDispose<AuthState, AuthModel>(
          (ref) => AuthState());

  bool get areInputsValid => state.email.valid && state.password.valid;

  _setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  _switchForm(AuthType currentType) {
    state = state.copyWith(
        type:
            currentType == AuthType.signIn ? AuthType.signUp : AuthType.signIn);
  }

  _setAuthError(String? error) {
    state = state.copyWith(authError: error ?? '');
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
    _ref.read(AuthState.provider.notifier)._setAuthError(null);
  }

  switchForm() {
    _ref.invalidate(emailController);
    _ref.invalidate(passwordController);
    final currentType = _ref.read(AuthState.provider).type;
    _ref.invalidate(AuthState.provider);
    _ref.read(AuthState.provider.notifier)._switchForm(currentType);
  }

  validateEmail() {
    final input = _ref.read(emailController).text;
    final TextInputModel result =
        _ref.read(ValidationService.provider).validateEmail(input);
    _ref.read(AuthState.provider.notifier)._updateEmail(result);
  }

  validatePassword(String input) {
    final TextInputModel result =
        _ref.read(ValidationService.provider).validatePassword(input);
    _ref.read(AuthState.provider.notifier)._updatePassword(result);
  }

  authenticateEmail() async {
    //start loading
    _ref.read(AuthState.provider.notifier)._setLoading(true);

    //get input texts
    final email = _ref.read(emailController).text.toLowerCase();
    final password = _ref.read(passwordController).text;
    final String? authResult;
    switch (_ref.read(AuthState.provider).type) {
      case AuthType.signIn:
        authResult =
            await _ref.read(AuthService.provider).signInEmail(email, password);
        break;
      case AuthType.signUp:
        authResult =
            await _ref.read(AuthService.provider).signUpEmail(email, password);
        break;
    }
    if (authResult != null) {
      _ref.read(AuthState.provider.notifier)._setAuthError(authResult);
      //if error, stop loading
      _ref.read(AuthState.provider.notifier)._setLoading(false);
    }
  }

  authenticateGoogle() async {
    final String? authResult =
        await _ref.read(AuthService.provider).signInGoogle();
    if (authResult != null) {
      _ref.read(AuthState.provider.notifier)._setAuthError(authResult);
      return;
    }
    _ref.read(AuthState.provider.notifier)._setAuthError(null);
  }
}
