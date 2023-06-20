import 'package:flutter/material.dart';
import 'package:fireblog/services/services.dart';

class AuthServices {
  final currentUser = firebaseAuth.currentUser;
  currentUserUid() {
    return currentUser!.uid;
  }

  Future<void> signOut() async {

      await firebaseAuth.signOut();
  }
  Future<void> signIn(String email, String password) async {

    await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp(String email, String password, String name) async {

    await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

}

class SignInService {



}


