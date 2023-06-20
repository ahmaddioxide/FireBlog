import 'package:flutter/material.dart';
import 'package:fireblog/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_data.dart';

class AuthController with ChangeNotifier {
  bool _loading = false;

  bool get loading => _loading;
  late final UserData userData;
  String errorMessage = 'An error occurred. Please try again.';


  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      setLoading(true);

      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'email': email,
      });

      userData = UserData(name: name, email: email);
    } catch (error) {
      debugPrint('Error during sign up: $error');
      FirebaseAuthCustomException.handleAuthenticationError(error);
    } finally {
      setLoading(false);
    }
  }

}



