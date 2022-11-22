// ignore_for_file: public_member_api_docs, sort_constructors_first
enum LoginType {
  signIn,
  signUp,
}

class LoginStateModel {
  final bool isLoading;
  final LoginType type;
  final TextInputModel email;
  final TextInputModel password;
  final String? authError;
  LoginStateModel({
    required this.isLoading,
    required this.type,
    required this.email,
    required this.password,
    this.authError,
  });

  const LoginStateModel.initial({
    this.isLoading = false,
    this.type = LoginType.signIn,
    this.email = const TextInputModel(),
    this.password = const TextInputModel(),
    this.authError,
  });

  LoginStateModel copyWith({
    bool? isLoading,
    LoginType? type,
    TextInputModel? email,
    TextInputModel? password,
    String? authError,
  }) {
    return LoginStateModel(
      isLoading: isLoading ?? this.isLoading,
      type: type ?? this.type,
      email: email ?? this.email,
      password: password ?? this.password,
      authError: authError,
    );
  }
}

class TextInputModel {
  final bool valid;
  final String? error;
  const TextInputModel({
    this.valid = false,
    this.error,
  });
}
