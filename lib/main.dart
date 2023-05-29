import 'package:fireblog/views/registration_screen.dart';
import 'package:fireblog/views/onboarding_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller..dart';
import 'controllers/user_data.dart';
import 'firebase_options.dart';
import 'package:device_preview/device_preview.dart';

import 'views/login_screen.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => ChangeNotifierProvider(
        create: (context) => AuthController(),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserData>(
      create: (_) => UserData(),
      child: MaterialApp(
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        title: 'FireBlog',
        theme: ThemeData(
          primarySwatch: Colors.brown,
          textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        ),
        home: Consumer<AuthController>(
          builder: (context, authController, _) {
            if (authController.currentUser != null) {
              return const Registration();
            } else {
              return const OnBoardingPage();
            }
          },
        ),
        routes: {
          '/login': (context) => const Login(), // Replace LoginScreen with your login screen widget
        },
      ),
    );
  }
}

