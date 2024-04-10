import 'package:course_app/src/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  LocalUser? _user;

  LocalUser? get user => _user;

  void initUser(LocalUser? user) {
    if (user != _user) {
      _user = user;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }

  set user(LocalUser? user) {
    if (user != _user) {
      _user = user;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }
}
