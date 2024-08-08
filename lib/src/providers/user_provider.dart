import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    fname: '',
    lname: '',
    department: '',
    phonenumber: '',
    token: '',
    email: '',
    password: '',
    role: '',
  );

  User get user => _user;
  String get userRole => _user.role;

  void setUser(Map<String, dynamic>? json) {
    if (json != null) {
      _user = User.fromJson(json);
    } else {
      _user = User(
        id: '',
        fname: '',
        lname: '',
        department: '',
        phonenumber: '',
        token: '',
        email: '',
        password: '',
        role: '',
      );
    }
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
