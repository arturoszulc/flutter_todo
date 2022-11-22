import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/screens/loading_screen.dart';
import 'package:flutter_todo/screens/login_screen.dart';
import 'package:flutter_todo/screens/set_username_screen.dart';
import 'package:flutter_todo/screens/todo_screen.dart';

import '../controllers/user_controller.dart';
import '../models/user_model.dart';

class Wrapper extends ConsumerWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('WRAPPER REBUILT');
    //initializing userController
    final userController = ref.watch(UserController.provider);

    //resolving what screen to show
    final userStatus =
        ref.watch(UserState.provider.select((value) => value.status));
    switch (userStatus) {
      case UserStatus.signedOut:
        return const LoginScreen();
      case UserStatus.loading:
        return const LoadingScreen();
      case UserStatus.signedUp:
        return SetUsernameScreen();
      case UserStatus.signedIn:
        return const TodoScreen();
    }
  }
}
