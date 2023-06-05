import 'package:flutter/material.dart';

class UserData with ChangeNotifier {
  String name;
  String email;
  String? _userId;

  UserData({
    this.name = '',
    this.email = '',
  });

  String? get userId => _userId;

  void setUserId(String? userId) {
    _userId = userId;
    notifyListeners();
  }

  void updateUserData(UserData newData) {
    name = newData.name;
    email = newData.email;
    notifyListeners();
  }
}
