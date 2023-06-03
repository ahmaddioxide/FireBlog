import 'package:fireblog/controllers/blog_info_controller.dart';
import 'package:fireblog/views/bottom_navigation.dart';
import 'package:fireblog/views/profile_screen.dart';
import 'package:fireblog/views/registration_screen.dart';
import 'package:fireblog/views/onboarding_screen.dart';
import 'package:fireblog/views/social_media_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller..dart';

import 'controllers/socials_media_controller.dart';
import 'controllers/user_data.dart';
import 'firebase_options.dart';
import 'package:device_preview/device_preview.dart';

import 'views/blogs_screen.dart';
import 'views/create_blog_screen.dart';
import 'views/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
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
          ChangeNotifierProvider<BlogInfoProvider>(create: (context) => BlogInfoProvider()),
        ],
        child: const MyApp(),
      ),

    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      title: 'FireBlog',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
      ),
      home: Consumer<AuthController>(
        builder: (context, authController, _) {
          if (authController.currentUser != null) {
            return const HomeScreen();
          } else {
            return const OnBoardingPage();
          }
        },
      ),
      routes: {
        '/login': (context) => const Login(),
        '/registration': (context) => const Registration(),
        '/social_media_links': (context) => const SocialMediaInput(),
        '/home': (context) => const HomeScreen(),
        '/onboarding': (context) => const OnBoardingPage(),
        '/view_profile': (context) => const ProfileScreen(),
        '/create_blog': (context) => const CreateBlog(),

      },
    );
  }
}
