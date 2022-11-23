import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/utils/consts/strings.dart';

import '../controllers/user_controller.dart';

class UpdateTodoScreen extends ConsumerWidget {
  const UpdateTodoScreen({super.key, this.todoIndex});
  final int? todoIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(todoIndex == null
              ? MyString.appBarAddingTodo
              : MyString.appBarEditingTodo),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
              child: TextFormField(
                  controller: ref.watch(todoTextController(todoIndex)),
                  textInputAction: TextInputAction.done,
                  maxLines: 6,
                  decoration: InputDecoration(
                    helperText: ' ',
                    hintText: MyString.todoTextFieldHint,
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(),
                    errorText: ref.watch(todoInputState).error,
                  ),
                  onChanged: (val) {
                    ref.read(UserController.provider).validateTodo(todoIndex);
                  }),
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: ref.watch(todoInputState).valid == true
                    ? () {
                        ref.read(UserController.provider).updateTodo(todoIndex);
                        Navigator.pop(context);
                      }
                    : null,
                child: Text(todoIndex == null
                    ? MyString.addTodoButton
                    : MyString.updateTodoButton),
              ),
            )
          ],
        )),
      ),
    );
  }
}
