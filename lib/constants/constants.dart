import 'package:fireblog/views/bottom_navigation.dart';
import 'package:fireblog/views/create_blog_screen.dart';
import 'package:fireblog/views/login_screen.dart';
import 'package:fireblog/views/onboarding_screen.dart';
import 'package:fireblog/views/profile_screen.dart';
import 'package:fireblog/views/registration_screen.dart';
import 'package:fireblog/views/social_media_screen.dart';
import 'package:flutter/material.dart';

List<Map<String, String>> onboardData = [
  {
    "text":
    "Welcome to FireBlog, the talented development and community wing dedicated to the growth of the digital world. Join us on this exciting journey!",
    "image": "assets/images/onboard1.png",
    "heading": "Welcome to FireBlog"
  },
  {
    "text":
    "With FireBlog, you can unleash your creativity and express yourself through blogs. Create captivating content and share it with a vibrant community of passionate individuals. ",
    "image": "assets/images/onboard2.png",
    "heading": "Create and Share"
  },
  {
    "text":
    "Dive into a world of inspiration and knowledge. Explore blogs crafted by talented writers, connect with like-minded individuals, and foster meaningful conversations within the FireBlog community.",
    "image": "assets/images/onboard3.png",
    "heading": "Explore and Connect"
  },
];

Map<String, Widget Function(BuildContext)> appRoutes={
'/login': (context) => const Login(),
'/registration': (context) => const Registration(),
'/social_media_links': (context) => const SocialMediaInput(),
'/home': (context) => const HomeScreen(),
'/onboarding': (context) => const OnBoardingPage(),
'/view_profile': (context) => const ProfileScreen(),
'/create_blog': (context) => const CreateBlog(),
};

void showSnackBar(BuildContext context, String message, Color backgroundColor) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: backgroundColor,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}