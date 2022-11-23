import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/controllers/ad_controller.dart';
import 'package:flutter_todo/models/user_model.dart';
import 'package:flutter_todo/services/db_service.dart';
import 'package:flutter_todo/services/validation_service.dart';

import '../models/text_input_model.dart';
import '../services/auth_service.dart';

final usernameTextController =
    Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  log('*** setUsernameController created ***');
  ref.onDispose(() {
    log('*** setUsernameController disposed ***');
    controller.dispose();
  });
  return controller;
});

final usernameInputState = StateProvider.autoDispose<TextInputModel>((ref) {
  return const TextInputModel();
});

final todoTextController =
    Provider.autoDispose.family<TextEditingController, int?>((ref, index) {
  final controller = TextEditingController(
      text:
          index == null ? null : ref.read(UserState.provider).todoList[index]);
  log('*** todoTextController created ***');
  ref.onDispose(() {
    log('*** todoTextController disposed ***');
    controller.dispose();
  });
  return controller;
});

final todoInputState = StateProvider.autoDispose<TextInputModel>((ref) {
  return const TextInputModel(valid: false, error: null);
});

class UserState extends StateNotifier<AppUser> {
  UserState() : super(AppUser.empty());

  static final provider = StateNotifierProvider.autoDispose<UserState, AppUser>(
      (ref) => UserState());

  _setStatus(UserStatus status) {
    state = state.copyWith(status: status);
  }

  _mergeUserFromDb(AppUser user) {
    /// when setting state based on Firebase data, always check if [user.username] was set
    /// If username.isEmpty, set status = UserStatus.signedUp,
    /// With this status, Wrapper() automatically shows SetUsernameScreen()
    state = state.copyWith(
      status: user.username.isEmpty ? UserStatus.signedUp : UserStatus.signedIn,
      id: user.id,
      points: user.points,
      username: user.username,
      todoList: user.todoList,
    );
  }

  _createUser(String uid) {
    /// when creating new user, status is always signedUp
    state = state.copyWith(
      status: UserStatus.signedUp,
      id: uid,
    );
  }

  _setUserName(String username) {
    /// after setting username, status can be changed to signedIn, so that
    /// Wrapper() will automatically show TodoListScreen()
    state = state.copyWith(status: UserStatus.signedIn, username: username);
  }

  _signOut() {
    state = state.copyWith(status: UserStatus.signedOut);
  }

  void _addTodo(String todo) {
    state = state.copyWith(
        points: state.points - 1, todoList: [...state.todoList, todo]);
  }

  void _editTodo(int index, String todo) {
    state = state.copyWith(todoList: [
      ...state.todoList
          .map((e) => state.todoList.indexOf(e) == index ? e = todo : e)
    ]);
  }

  void _deleteTodo(int index) {
    final List<String> newTodoList = state.todoList;
    newTodoList.removeAt(index);
    state = state.copyWith(todoList: newTodoList);
  }

  void _addPoints() {
    state = state.copyWith(points: 3);
  }
}

class UserController {
  UserController(this._ref) {
    _watchAuthUser();
  }

  static final provider = Provider.autoDispose((ref) => UserController(ref));
  final Ref _ref;

  /// USER SECTION ///

  _watchAuthUser() {
    log('/// watching authStateChange ///');
    final authState = _ref.watch(AuthService.provider).authStateChange;
    authState.listen((User? user) async {
      if (user != null) {
        log('/// User signed in ///');
        getUserFromDb(user.uid);
      }
      if (user == null) {
        log('/// User signed out ///');
        _ref.read(UserState.provider.notifier)._signOut();
      }
    });
  }

  void validateUsername() {
    final input = _ref.read(usernameTextController).text;
    final TextInputModel result =
        _ref.read(ValidationService.provider).validateUsername(input);
    _ref.read(usernameInputState.notifier).state = result;
  }

  setUserName() async {
    final username = _ref.read(usernameTextController).text;
    _ref.read(UserState.provider.notifier)._setUserName(username);
    await _ref
        .read(DbService.provider)
        .updateUser(_ref.read(UserState.provider));
  }

  getUserFromDb(String uid) async {
    //set status to Loading
    _ref.read(UserState.provider.notifier)._setStatus(UserStatus.loading);
    //try to fetch from db
    final response = await AsyncValue.guard(
        () => _ref.read(DbService.provider).getUser(uid));
    if (response.value is AppUser) {
      _ref.read(UserState.provider.notifier)._mergeUserFromDb(response.value!);
    } else {
      //if error, assume that user is new and wasn't yet created
      _ref.read(UserState.provider.notifier)._createUser(uid);
      updateUserToDb();
    }
    //prepare an Ad
    _ref.read(AdController.provider).createAd();
  }

  ///After modifying UserState, call this method to keep Firebase doc up-to-date
  updateUserToDb() {
    _ref.read(DbService.provider).updateUser(_ref.read(UserState.provider));
  }

  signOut() {
    //clear UserState before signing out
    _ref.invalidate(UserState.provider);
    _ref.read(AuthService.provider).signOut();
  }

  /// TODOS SECTION ///

  validateTodo(int? index) {
    final input = _ref.read(todoTextController(index)).text;
    final TextInputModel result =
        _ref.read(ValidationService.provider).validateTodo(input);

    _ref.read(todoInputState.notifier).state = result;
  }

  updateTodo(int? index) {
    final todo = _ref.read(todoTextController(index)).text;
    if (index is int) {
      _ref.read(UserState.provider.notifier)._editTodo(index, todo);
    } else {
      _ref.read(UserState.provider.notifier)._addTodo(todo);
    }
    updateUserToDb();
  }

  deleteTodo(int index) {
    _ref.read(UserState.provider.notifier)._deleteTodo(index);
    updateUserToDb();
  }

  /// ADS & POINTS SECTION ///

  showAd() {
    _ref.read(AdController.provider).showAd();
  }

  addPoints() {
    _ref.read(UserState.provider.notifier)._addPoints();
    updateUserToDb();
  }
}
