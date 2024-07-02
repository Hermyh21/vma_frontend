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
      role: '');
  User get user => _user;
  String get userRole => _user.role;
  void setUser(Map<String, dynamic> json) {
    _user = User.fromJson(json);
    notifyListeners();
  }

  void setUserFromMode(User user) {
    _user = user;
    notifyListeners();
  }
}
