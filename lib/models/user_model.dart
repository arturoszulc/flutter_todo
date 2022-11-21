import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/consts/strings.dart';

class AppUser {
  final String id;
  final String username;

  const AppUser({
    required this.id,
    required this.username,
  });

  factory AppUser.empty() => const AppUser(id: '', username: '');

  factory AppUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc, SnapshotOptions? options) {
    final data = doc.data();
    return AppUser(
      id: doc.id,
      username: data?[MyString.dbFieldUsername] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      MyString.dbFieldUsername: username,
    };
  }
}
