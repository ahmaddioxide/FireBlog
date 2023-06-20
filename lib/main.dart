import 'package:fireblog/constants/constants.dart';
import 'package:fireblog/controllers/login_controller.dart';
import 'package:fireblog/controllers/logout_controller.dart';
import 'package:fireblog/services/services.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

import 'package:device_preview/device_preview.dart';
import 'package:fireblog/controllers/blog_info_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';
import 'controllers/socials_media_controller.dart';
import 'models/user_data.dart';

import 'package:fireblog/views/bottom_navigation.dart';
import 'package:fireblog/views/onboarding_screen.dart';
import 'views/blogs_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthController>(
            create: (context) => AuthController(),
          ),
          ChangeNotifierProvider<UserData>(
            create: (context) => UserData(),
          ),
          ChangeNotifierProvider<SocialMediaData>(
            create: (context) => SocialMediaData(),
          ),
          ChangeNotifierProvider<BlogProvider>(
            create: (context) => BlogProvider(),
          ),
          ChangeNotifierProvider<BlogInfoProvider>(
            create: (context) => BlogInfoProvider(),
          ),
          ChangeNotifierProvider<LoginController>(
            create: (context) => LoginController(),
          ),
          ChangeNotifierProvider<LogoutController>(
            create: (context) => LogoutController(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      title: 'FireBlog',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
      ),
      home: Consumer<AuthController>(
        builder: (context, authController, _) {
          if (currentUser != null) {
            return const HomeScreen();
          } else {
            return const OnBoardingPage();
          }
        },
      ),
      routes: appRoutes,
    );
  }
}
