import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SocialMediaInput extends StatefulWidget {
  const SocialMediaInput({Key? key}) : super(key: key);

  @override
  State<SocialMediaInput> createState() => _SocialMediaInputState();
}

class _SocialMediaInputState extends State<SocialMediaInput> {
  late TextEditingController _linkedinController;
  late TextEditingController _facebookController;
  late TextEditingController _twitterController;
  late TextEditingController _instagramController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _linkedinController = TextEditingController();
    _facebookController = TextEditingController();
    _twitterController = TextEditingController();
    _instagramController = TextEditingController();
  }

  @override
  void dispose() {
    _linkedinController.dispose();
    _facebookController.dispose();
    _twitterController.dispose();
    _instagramController.dispose();
    super.dispose();
  }

  Future<void> _saveSocialMediaLinks() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _formKey.currentState!.validate()) {
      final socialMediaLinks = <String, dynamic>{};

      if (_linkedinController.text.trim().isNotEmpty) {
        socialMediaLinks['linkedin'] = _linkedinController.text.trim();
      }
      if (_facebookController.text.trim().isNotEmpty) {
        socialMediaLinks['facebook'] = _facebookController.text.trim();
      }
      if (_twitterController.text.trim().isNotEmpty) {
        socialMediaLinks['twitter'] = _twitterController.text.trim();
      }
      if (_instagramController.text.trim().isNotEmpty) {
        socialMediaLinks['instagram'] = _instagramController.text.trim();
      }

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update(socialMediaLinks);
        // Social media links saved successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Social media links saved successfully')),
        );
      } catch (e) {
        // Error occurred while saving social media links
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving social media links: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Media Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _linkedinController,
                decoration: InputDecoration(
                  labelText: 'LinkedIn',
                  prefixIcon: const Icon(Icons.link),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _facebookController,
                decoration: InputDecoration(
                  labelText: 'Facebook',
                  prefixIcon: const Icon(Icons.link),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _twitterController,
                decoration: InputDecoration(
                  labelText: 'Twitter',
                  prefixIcon: const Icon(Icons.link),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _instagramController,
                decoration: InputDecoration(
                  labelText: 'Instagram',
                  prefixIcon: const Icon(Icons.link),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _saveSocialMediaLinks,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
