// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_todo/models/text_input_model.dart';

enum AuthType {
  signIn,
  signUp,
}

class AuthModel {
  final bool isLoading;
  final AuthType type;
  final TextInputModel email;
  final TextInputModel password;
  final String authError;
  AuthModel({
    required this.isLoading,
    required this.type,
    required this.email,
    required this.password,
    required this.authError,
  });

  const AuthModel.initial({
    this.isLoading = false,
    this.type = AuthType.signIn,
    this.email = const TextInputModel(),
    this.password = const TextInputModel(),
    this.authError = '',
  });

  AuthModel copyWith({
    bool? isLoading,
    AuthType? type,
    TextInputModel? email,
    TextInputModel? password,
    String? authError,
  }) {
    return AuthModel(
      isLoading: isLoading ?? this.isLoading,
      type: type ?? this.type,
      email: email ?? this.email,
      password: password ?? this.password,
      authError: authError ?? this.authError,
    );
  }
}
