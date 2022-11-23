import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/controllers/user_controller.dart';
import 'package:flutter_todo/utils/consts/strings.dart';

class SetUsernameScreen extends ConsumerWidget {
  const SetUsernameScreen({Key? key}) : super(key: key);
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
                MyString.whatsYourName,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //USERNAME field
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: TextFormField(
                  controller: ref.watch(usernameTextController),
                  decoration: InputDecoration(
                    labelText: MyString.usernameTextFieldLabel,
                    errorText: ref.watch(usernameInputState).error,
                    helperText: ' ',
                    errorMaxLines: 2,
                  ),
                  onChanged: (val) {
                    ref.read(UserController.provider).validateUsername();
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: ref.watch(usernameInputState).valid &&
                        ref.watch(usernameTextController).text.isNotEmpty
                    ? () {
                        ref.read(UserController.provider).setUserName();
                      }
                    : null,
                child: const Text(MyString.confirmButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
