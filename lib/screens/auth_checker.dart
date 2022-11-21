import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/screens/login_screen.dart';
import 'package:flutter_todo/screens/todo_screen.dart';
import 'package:flutter_todo/services/auth_service.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);

  //  Notice here we aren't using stateless/statefull widget. Instead we are using
  //  a custom widget that is a consumer of the state.
  //  So if any data changes in the state, the widget will be updated.

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //  now the build method takes a new paramaeter ScopeReader.
    //  this object will be used to access the provider.

    //  now the following variable contains an asyncValue so now we can use .when method
    //  to imply the condition
    final _authState = ref.watch(authStateProvider);
    if (_authState.hasValue && _authState.value != null) {
      return const TodoScreen();
    }
    return const LoginScreen();

    // return _authState.when(
    //     data: (data) {
    //       if (data != null) return const TodoScreen();
    //       return const LoginScreen();
    //     },
    //     // loading: () => const LoadingScreen(),
    //     error: (e, trace) => null);
  }
}
