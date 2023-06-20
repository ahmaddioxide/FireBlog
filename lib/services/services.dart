import 'package:firebase_auth/firebase_auth.dart';

final User? currentUser = FirebaseAuth.instance.currentUser;

class FirebaseAuthCustomException implements Exception {
  final String code;
  final String message;

  FirebaseAuthCustomException(this.code, this.message);

  static void handleAuthenticationError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          throw FirebaseAuthCustomException('email-already-in-use',
              'Email already in use. Please use a different email.');
        case 'weak-password':
          throw FirebaseAuthCustomException('weak-password',
              'Weak password. Please choose a stronger password.');
        case 'invalid-email':
          throw FirebaseAuthCustomException('invalid-email',
              'Invalid email address. Please enter a valid email.');
        case 'operation-not-allowed':
          throw FirebaseAuthCustomException('operation-not-allowed',
              'Sign up is currently disabled. Please try again later.');
        case 'user-not-found':
          throw FirebaseAuthCustomException('user-not-found',
              'No user found with this email. Please try again.');
        case 'wrong-password':
          throw FirebaseAuthCustomException(
              'wrong-password', 'Incorrect password. Please try again.');
        case 'user-disabled':
          throw FirebaseAuthCustomException('user-disabled',
              'This user has been disabled. Please contact support.');
      }
    } else {
      throw FirebaseAuthCustomException(
          'unknown-error', 'An unknown error occurred. Please try again.');
    }
  }
}
