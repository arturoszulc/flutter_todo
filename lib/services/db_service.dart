import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/models/user_model.dart';

class DbService {
  static final provider = Provider.autoDispose<DbService>((ref) {
    return DbService();
  });

  final CollectionReference<AppUser> usersCollection =
      FirebaseFirestore.instance.collection('users').withConverter(
            fromFirestore: AppUser.fromFirestore,
            toFirestore: (AppUser appUser, _) => appUser.toFirestore(),
          );

  Future<AppUser?> getUser(String uid) async {
    log('/// DB: reading USER doc... ///');
    final doc = await usersCollection.doc(uid).get();
    final user = doc.data();
    if (user != null) {
      return user;
    } else {
      log('/// DB: User not found ///');
      return null;
    }
  }

  Future<void> updateUser(AppUser user) {
    return usersCollection
        .doc(user.id)
        .set(user)
        .then((value) => log('/// DB: User updated ///'))
        .catchError(
            (error) => log("/// DB: Failed to update user: $error ///"));
  }
}
