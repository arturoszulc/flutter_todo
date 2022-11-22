import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/controllers/user_controller.dart';

class SetUsernameScreen extends ConsumerWidget {
  SetUsernameScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _setUsernameKey = GlobalKey<FormState>();
  String username = '';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Hi, what\'s your name?',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _setUsernameKey,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  // onTap: () => usernameChanged = true,
                  onChanged: (val) {
                    username = val;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(UserController.provider).setUserName(username);
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
