import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/controllers/ad_controller.dart';
import 'package:flutter_todo/controllers/user_controller.dart';
import 'package:flutter_todo/screens/todo_update_screen.dart';
import 'package:flutter_todo/utils/consts/strings.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String username =
        ref.watch(UserState.provider.select((value) => value.username));
    final bool isAdLoaded =
        ref.watch(AdState.provider.select((value) => value.isAdLoaded));
    return Scaffold(
      appBar: AppBar(
        title: Text(MyString.appBarWelcome + username),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () => ref.read(UserController.provider).signOut(),
              child: const Text(
                MyString.signOut,
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
      body: Column(
        children: const [
          PointsLeft(),
          Expanded(child: TodoList()),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ref.watch(UserState.provider).points > 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpdateTodoScreen()),
                );
              },
              child: const Icon(Icons.add),
            )
          : SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                onPressed: isAdLoaded
                    ? () {
                        ref.read(UserController.provider).showAd();
                      }
                    : null,
                label: const Text(MyString.getPoints),
                icon: const Icon(Icons.smart_display_outlined),
              ),
            ),
    );
  }
}

class PointsLeft extends ConsumerWidget {
  const PointsLeft({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int userPoints = ref.watch(UserState.provider).points;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Text(
            userPoints == 1
                ? userPoints.toString() + MyString.todosOneLeft
                : userPoints.toString() + MyString.todosLeft,
            style: Theme.of(context).textTheme.headline6),
      ),
    );
  }
}

class TodoList extends ConsumerWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> todos = ref.watch(UserState.provider).todoList;
    return todos.isEmpty
        ? const Center(
            child: Text(
              MyString.todoListEmpty,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        : ListView(
            children: todos
                .map((e) => TodoSingle(
                      todo: e,
                      onEditPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateTodoScreen(
                                    todoIndex: todos.indexOf(e))));
                      },
                      onDeletePressed: () {
                        ref
                            .read(UserController.provider)
                            .deleteTodo(todos.indexOf(e));
                      },
                    ))
                .toList(),
          );
  }
}

class TodoSingle extends StatelessWidget {
  const TodoSingle(
      {super.key,
      required this.todo,
      required this.onEditPressed,
      required this.onDeletePressed});

  final String todo;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 15.0),
        title: Text(todo),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEditPressed,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDeletePressed,
            ),
          ],
        ),
      ),
    );
  }
}
