import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_data.dart';
import '../views/bottom_navigation.dart';
import '../views/social_media_screen.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  User? get currentUser => _currentUser;
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

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'email': email,
      });

      final userData = UserData(name: name, email: email);

      Provider.of<UserData>(context, listen: false).updateUserData(userData);

      showSnackBar(context, 'Sign up successful!', Colors.green);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SocialMediaInput(),),
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

      DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      Map<String, dynamic> userData = userDataSnapshot.data() as Map<String, dynamic>;

      final userDataModel = UserData(
        name: userData['name'],
        email: userData['email'],
      );

      Provider.of<UserData>(context, listen: false).updateUserData(userDataModel);

      showSnackBar(context, 'Login successful!', Colors.green);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen(),),
      );
    } catch (error) {
print('Error during login: $error');

      String errorMessage = 'An error occurred. Please try again.';

      if (error is FirebaseAuthException) {
        switch (error.code) {
          case 'user-not-found':
            errorMessage = 'No user found with this email. Please try again.';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password. Please try again.';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email address. Please enter a valid email.';
            break;
          case 'user-disabled':
            errorMessage = 'This user has been disabled. Please contact support.';
            break;
        }
      }

      showSnackBar(context, errorMessage, Colors.red);

    } finally {
      setLoading(false);
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _firebaseAuth.signOut();

      Provider.of<UserData>(context, listen: false).updateUserData(UserData());

      Navigator.pushReplacementNamed(context, '/registration');
    } catch (error) {
      if(error is FirebaseAuthException)
        {
          showSnackBar(context, 'An error occurred. Please try again.', Colors.red);
        }

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

