import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/models/user_model.dart';

class DbService {
  static final provider = Provider<DbService>((ref) {
    return DbService();
  });

  final CollectionReference<AppUser> usersCollection =
      FirebaseFirestore.instance.collection('users').withConverter(
            fromFirestore: AppUser.fromFirestore,
            toFirestore: (AppUser appUser, _) => appUser.toFirestore(),
          );

  Future<AppUser?> getUser(String uid) async {
    debugPrint('/// DB: reading USER doc... ///');
    final doc = await usersCollection.doc(uid).get();
    final user = doc.data();
    if (user != null) {
      return user;
    } else {
      log('/// DB: User not found ///');
      return null;
    }
  }

  //UPDATE USER DATA
  // DO NOT USE ASYNC/AWAIT on SET function, because when device is offline, it won't return
  // anything and app will freeze

  ///Had to split below method into three separate, to disallow updateing whole user object
  ///This is because cloud functions can update some parts of user, so my frontend
  ///could erase those changes while updateing whole user doc.
  ///
  // Future<void> updateUser(AppUser user) {
  //   debugPrint('/// DB: writing USER doc... ///');
  //   return usersCollection
  //       .doc(user.id)
  //       .set(user, SetOptions(merge: true))
  //       .then((value) => debugPrint('/// DB: User updated ///'))
  //       .catchError((error) => debugPrint("DB: Failed to update user: $error"));
  // }

  Future<void> updateUser(AppUser user) {
    debugPrint('/// DB: creating USER doc... ///');
    return usersCollection
        .doc(user.id)
        .set(user)
        .then((value) => debugPrint('/// DB: User updated ///'))
        .catchError((error) => debugPrint("DB: Failed to update user: $error"));
  }
}
