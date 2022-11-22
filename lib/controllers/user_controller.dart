import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/controllers/ad_controller.dart';
import 'package:flutter_todo/models/user_model.dart';
import 'package:flutter_todo/services/db_service.dart';

import '../services/auth_service.dart';

// final userInitialized = StateProvider<bool>((ref) {
//   return false;
// });

class UserState extends StateNotifier<AppUser> {
  UserState() : super(AppUser.empty());

  static final provider = StateNotifierProvider.autoDispose<UserState, AppUser>(
      (ref) => UserState());

  _setStatus(UserStatus status) {
    state = state.copyWith(status: status);
  }

  _mergeUserFromDb(AppUser user) {
    state = state.copyWith(
      status: UserStatus.signedIn,
      id: user.id,
      points: user.points,
      username: user.username,
      todoList: user.todoList,
    );
  }

  _createUser(String uid) {
    state = state.copyWith(
      status: UserStatus.signedUp,
      id: uid,
    );
  }

  _setUserName(String username) {
    state = state.copyWith(status: UserStatus.signedIn, username: username);
  }

  _signOut() {
    state = state.copyWith(status: UserStatus.signedOut);
  }

  String? todoByIndex(int? index) {
    if (index is int) return state.todoList.elementAt(index);
    return null;
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
    debugPrint('POINTS ADDED');
    state = state.copyWith(points: 3);
  }
}

class UserController {
  UserController(this._ref) {
    watchAuthUser();
  }

  static final provider = Provider.autoDispose((ref) => UserController(ref));
  final Ref _ref;

  watchAuthUser() {
    debugPrint('Watching user change');
    final _authState = _ref.watch(AuthService.provider).authStateChange;

    _authState.listen((User? user) async {
      if (user != null) {
        debugPrint('/// AuthService: User signed in ///');
        getUserFromDb(user.uid);
      }
      if (user == null) {
        debugPrint('/// AuthService: User signed out ///');
        _ref.read(UserState.provider.notifier)._signOut();
      }
    });
  }

  setUserName(String username) async {
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
      //if error, assume that user is new and wasn't created yet
      _ref.read(UserState.provider.notifier)._createUser(uid);
      updateUser();
    }
    //prepare Ad
    _ref.read(AdController.provider).createAd();
  }

  signOut() {
    _ref.read(AuthService.provider).signOut();
  }

  updateTodo(int? index, String todo) {
    if (index is int) {
      _ref.read(UserState.provider.notifier)._editTodo(index, todo);
    } else {
      _ref.read(UserState.provider.notifier)._addTodo(todo);
    }
    updateUser();
  }

  deleteTodo(int index) {
    _ref.read(UserState.provider.notifier)._deleteTodo(index);
    updateUser();
  }

  showAd() {
    _ref.read(AdController.provider).showAd();
  }

  addPoints() {
    _ref.read(UserState.provider.notifier)._addPoints();
    updateUser();
  }

  updateUser() {
    _ref.read(DbService.provider).updateUser(_ref.read(UserState.provider));
  }
}
