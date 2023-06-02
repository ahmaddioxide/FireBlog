import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireblog/views/bottom_navigation.dart';
import 'package:flutter/material.dart';

class SocialMediaData with ChangeNotifier {
  late TextEditingController linkedinController;
  late TextEditingController facebookController;
  late TextEditingController twitterController;
  late TextEditingController instagramController;
  bool loading = false;

  SocialMediaData() {
    linkedinController = TextEditingController();
    facebookController = TextEditingController();
    twitterController = TextEditingController();
    instagramController = TextEditingController();
  }

  @override
  void dispose() {
    linkedinController.dispose();
    facebookController.dispose();
    twitterController.dispose();
    instagramController.dispose();
    super.dispose();
  }

  Future<void> saveSocialMediaLinks(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final socialMediaLinks = <String, dynamic>{};

      if (linkedinController.text.trim().isNotEmpty) {
        socialMediaLinks['linkedin'] = linkedinController.text.trim();
      }
      if (facebookController.text.trim().isNotEmpty) {
        socialMediaLinks['facebook'] = facebookController.text.trim();
      }
      if (twitterController.text.trim().isNotEmpty) {
        socialMediaLinks['twitter'] = twitterController.text.trim();
      }
      if (instagramController.text.trim().isNotEmpty) {
        socialMediaLinks['instagram'] = instagramController.text.trim();
      }

      try {
        setLoading(true);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update(socialMediaLinks);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Social media links saved successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving social media links: $e')),
        );
      } finally {
        setLoading(false);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    }
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }
}
