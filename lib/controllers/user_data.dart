import 'package:flutter/material.dart';

class UserData with ChangeNotifier {
  late String name;
  late String email;

  UserData({
     this.name='',
     this.email='',
  });

  void updateUserData(UserData newData) {
    name = newData.name;
    email = newData.email;
    notifyListeners();
  }
}
