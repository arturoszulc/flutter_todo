import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/utils/consts/strings.dart';

import '../controllers/user_controller.dart';

class UpdateTodoScreen extends ConsumerStatefulWidget {
  const UpdateTodoScreen({super.key, this.todoIndex});
  final int? todoIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateTodoScreenState();
}

class _UpdateTodoScreenState extends ConsumerState<UpdateTodoScreen> {
  final _todoController = TextEditingController();

  String? originalText;
  @override
  void initState() {
    super.initState();

    //[originalText] disables unnecessary updates when user didn't change todo
    originalText =
        ref.read(UserState.provider.notifier).todoByIndex(widget.todoIndex) ??
            '';
    _todoController.text = originalText ?? '';
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.todoIndex == null
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
                // initialValue: todo,
                controller: _todoController,
                textInputAction: TextInputAction.done,
                // expands: true,
                maxLines: 6,
                decoration: const InputDecoration(
                  helperText: ' ',
                  hintText: 'Remeber to...',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  // errorText: _remark.error,
                ),
                //   onTap: () =>
                //       ref.read(remarkController).setRemarkError(null),
                // ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text(
              //         error,
              //         style: const TextStyle(color: Colors.red),
              //         textAlign: TextAlign.center,
              //       ),
              //     ],
              //   ),
              // ),
            ),
            Align(
              alignment: Alignment.center,
              child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _todoController,
                  builder: (context, value, child) {
                    return ElevatedButton(
                      onPressed:
                          value.text.isEmpty || value.text == originalText
                              ? null
                              : () {
                                  ref.read(UserController.provider).updateTodo(
                                      widget.todoIndex, _todoController.text);
                                  Navigator.pop(context);
                                },
                      child: Text(widget.todoIndex == null
                          ? MyString.addTodo
                          : MyString.updateTodo),
                    );
                  }),
            )
          ],
        )),
      ),
    );
  }
}
