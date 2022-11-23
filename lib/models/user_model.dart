// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/consts/strings.dart';

enum UserStatus {
  signedOut,
  loading,
  signedUp,
  signedIn,
}

class AppUser {
  final UserStatus status;
  final String id;
  final String username;
  final int points;
  final List<String> todoList;

  const AppUser({
    this.status = UserStatus.loading,
    required this.id,
    required this.points,
    required this.username,
    required this.todoList,
  });

  factory AppUser.empty() =>
      const AppUser(id: '', username: '', points: 3, todoList: []);

  factory AppUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc, SnapshotOptions? options) {
    final data = doc.data();
    return AppUser(
      id: doc.id,
      points: data?[MyString.dbFieldPoints] ?? 0,
      username: data?[MyString.dbFieldUsername] ?? '',
      todoList: List<String>.from(data?[MyString.dbFieldTodoList] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      MyString.dbFieldUsername: username,
      MyString.dbFieldPoints: points,
      MyString.dbFieldTodoList: todoList,
    };
  }

  AppUser copyWith({
    UserStatus? status,
    String? id,
    String? username,
    int? points,
    List<String>? todoList,
  }) {
    return AppUser(
      status: status ?? this.status,
      id: id ?? this.id,
      username: username ?? this.username,
      points: points ?? this.points,
      todoList: todoList ?? this.todoList,
    );
  }

  @override
  String toString() {
    return 'AppUser(status: $status, id: $id, username: $username, points: $points, todoList: $todoList)';
  }
}
