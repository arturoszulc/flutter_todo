import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/models/login_state_model.dart';
import 'package:flutter_todo/services/auth_service.dart';

class LoginState extends StateNotifier<LoginStateModel> {
  LoginState() : super(const LoginStateModel.initial());

  static final provider =
      StateNotifierProvider.autoDispose<LoginState, LoginStateModel>(
          (ref) => LoginState());

  _switchForm() {
    state = state.copyWith(
        type: state.type == LoginType.signIn
            ? LoginType.signUp
            : LoginType.signIn);
  }

  _setAuthError(String? error) {
    state = state.copyWith(authError: error);
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

  switchForm(LoginType type) {
    _ref.read(LoginState.provider.notifier)._switchForm();
  }

  void validateEmail(String input) {}
  void validatePassword(String input) {}

  authenticateEmail({required String email, required String password}) async {
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
