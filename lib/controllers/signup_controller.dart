
import 'package:fireblog/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:fireblog/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireblog/services/auth_services.dart';
import 'package:fireblog/services/firestore_services.dart';


class SignUpController with ChangeNotifier {
  bool _loading = false;
   late UserData userData;
  bool get loading => _loading;
  String errorMessage = 'An error occurred. Please try again.';


  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  Future<void> signUp(String email, String password, String name) async {
    try {
      setLoading(true);

     await AuthServices().signUp(email, password, name).onError((error, stackTrace) {
       if(error is FirebaseAuthException) {

         FirebaseAuthCustomException.handleAuthenticationError(error);
         debugPrint('Error during sign up: $errorMessage');       }
     });


      await FirestoreServices().setUserData(name, email).onError((error, stackTrace){
        if(error is FirebaseException) {
          debugPrint('Error during sign up: $errorMessage');
        }
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



