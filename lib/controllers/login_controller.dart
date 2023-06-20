import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireblog/services/auth_services.dart';
import 'package:fireblog/services/firestore_services.dart';
import 'package:flutter/material.dart';

import '../services/services.dart';
import '../models/user_data.dart';

class LoginController with ChangeNotifier {
  bool _loading = false;

  bool get loading => _loading;
  late final UserData userData;
  String errorMessage = 'An error occurred. Please try again.';
  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      setLoading(true);

     await AuthServices().signIn(email, password).onError((error, stackTrace) {
        debugPrint('Error during login: $error');
        FirebaseAuthCustomException.handleAuthenticationError(error);
      });




      Map<String, dynamic> userData =await FirestoreServices().getCurrentUser();
      userData = UserData(
        name: userData['name'],
        email: userData['email'],
      ) as Map<String, dynamic>;

    } catch (error) {
      debugPrint('Error during login: $error');

      if (error is FirebaseAuthException) {
        FirebaseAuthCustomException.handleAuthenticationError(error);
      }
    } finally {
      setLoading(false);
    }
  }
}
