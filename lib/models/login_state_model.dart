// ignore_for_file: public_member_api_docs, sort_constructors_first
enum LoginType {
  signIn,
  signUp,
}

class LoginStateModel {
  final bool isLoading;
  final LoginType type;
  final String? authError;
  final String? emailError;
  final String? passwordError;
  const LoginStateModel({
    required this.isLoading,
    required this.type,
    this.authError,
    this.emailError,
    this.passwordError,
  });

  const LoginStateModel.initial({
    this.isLoading = false,
    this.type = LoginType.signIn,
    this.authError,
    this.emailError,
    this.passwordError,
  });

  LoginStateModel copyWith({
    bool? isLoading,
    LoginType? type,
    String? authError,
    String? emailError,
    String? passwordError,
  }) {
    return LoginStateModel(
      isLoading: isLoading ?? this.isLoading,
      type: type ?? this.type,
      authError: authError,
      emailError: emailError,
      passwordError: passwordError,
    );
  }
}
