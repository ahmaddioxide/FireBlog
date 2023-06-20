import 'package:fireblog/services/firestore_services.dart';
import 'package:fireblog/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> saveSocialMediaLinks() async {
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

        await FirestoreServices()
            .uploadSocialMediaLinks(
          socialMediaLinks,
        )
            .onError((error, stackTrace) {
          debugPrint('Error during uploadSocialMediaLinks: $error');
        });
      } finally {
        setLoading(false);
      }
    }
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }
}
