import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views/bottom_navigation.dart';
import '../views/social_media_screen.dart';
import 'user_data.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  bool _loading = false;

  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> signUp(BuildContext context, String email, String password, String name) async {
    try {
      setLoading(true);

      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Save user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'email': email,
      });

      // Sign up successful
      final userData = UserData(name: name, email: email);
      Provider.of<UserData>(context, listen: false).updateUserData(userData);
      showSnackBar(context, 'Sign up successful!', Colors.green);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SocialMediaInput()),
      );
    } catch (error) {
      print('Error during sign up: $error');

      String errorMessage = 'An error occurred. Please try again.';

      if (error is FirebaseAuthException) {
        switch (error.code) {
          case 'email-already-in-use':
            errorMessage = 'Email already in use. Please use a different email.';
            break;
          case 'weak-password':
            errorMessage = 'Weak password. Please choose a stronger password.';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email address. Please enter a valid email.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Sign up is currently disabled. Please try again later.';
            break;
        }
      }

      showSnackBar(context, errorMessage, Colors.red);
    } finally {
      setLoading(false);
    }
  }

  Future<void> login(BuildContext context, String email, String password) async {
    try {
      setLoading(true);

      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Fetch user data from Firestore
      DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      Map<String, dynamic> userData = userDataSnapshot.data() as Map<String, dynamic>;

      // Update user data using provider
      final userDataModel = UserData(
        name: userData['name'],
        email: userData['email'],
      );
      Provider.of<UserData>(context, listen: false).updateUserData(userDataModel);

      showSnackBar(context, 'Login successful!', Colors.green);

      // Navigate to the home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (error) {
      // Error handling code remains the same
    } finally {
      setLoading(false);
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _firebaseAuth.signOut();
      Provider.of<UserData>(context, listen: false).updateUserData(UserData()); // Clear user data
      Navigator.pushReplacementNamed(context, '/registration'); // Navigate back to login screen
    } catch (error) {
      print('Error during logout: $error');
    }
  }

  void showSnackBar(BuildContext context, String message, Color backgroundColor) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

