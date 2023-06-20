import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@JsonSerializable()
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

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
