import 'package:flutter/material.dart';

import '../models/user_data.dart';
import '../services/services.dart';

class LogoutController with ChangeNotifier {
  bool _loading = false;

  bool get loading => _loading;
  late final UserData userData;
  String errorMessage = 'An error occurred. Please try again.';

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      setLoading(true);

      await firebaseAuth.signOut();
    } catch (error) {
      debugPrint('Error during logout: $error');
      FirebaseAuthCustomException.handleAuthenticationError(error);
    } finally {
      setLoading(false);
    }
  }
}

