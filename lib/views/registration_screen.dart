import 'package:fireblog/views/social_media_screen.dart';
import 'package:flutter/material.dart';

import '../controllers/auth_controller..dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  AuthController _authController = AuthController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _linkTested = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      } else if (value.length < 3) {
                        return 'Name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      } else if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      } else if (!value.contains('.')) {
                        return 'Please enter a valid email';
                      } else if (value.length < 5) {
                        return 'Email must be at least 5 characters';
                      } else if (value.length > 50) {
                        return 'Email must be less than 50 characters';
                      } else if (value.contains(' ')) {
                        return 'Email cannot contain spaces';
                      } else if (value.contains('..')) {
                        return 'Email cannot contain consecutive periods';
                      } else if (value.contains('.@')) {
                        return 'Email cannot contain a period before the @ symbol';
                      } else if (value.contains('@.')) {
                        return 'Email cannot contain a period after the @ symbol';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      } else if (value.length > 50) {
                        return 'Password must be less than 50 characters';
                      } else if (value.contains(' ')) {
                        return 'Password cannot contain spaces';
                      } else if (!value.contains(RegExp(r'[A-Z]'))) {
                        return 'Password must contain at least one uppercase letter';
                      } else if (!value.contains(RegExp(r'[a-z]'))) {
                        return 'Password must contain at least one lowercase letter';
                      } else if (!value.contains(RegExp(r'[0-9]'))) {
                        return 'Password must contain at least one number';
                      } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                        return 'Password must contain at least one special character';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your password';
                      } else if (value != _passwordController.text.toString().trim()) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _linkTested = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SocialMediaInput()),
                          );
                          if (_linkTested) {
                            _authController.signUp(
                              context,
                              _emailController.text.toString().trim(),
                              _passwordController.text.toString().trim(),
                              _nameController.text.toString().trim(),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please test at least one link.'),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text("Register"),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      // Navigate to the login screen
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text("Already have an account? Log in"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
