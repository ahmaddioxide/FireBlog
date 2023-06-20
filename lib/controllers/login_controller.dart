import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
          .collection('users').doc(uid).get();

      Map<String, dynamic> userData = userDataSnapshot.data() as Map<
          String,
          dynamic>;

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
