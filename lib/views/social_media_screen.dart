import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../controllers/socials_media_controller.dart';

class SocialMediaInput extends StatelessWidget {
  const SocialMediaInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socialMediaData = Provider.of<SocialMediaData>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Media Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: socialMediaData.linkedinController,
              decoration: const InputDecoration(
                labelText: 'LinkedIn',
                prefixIcon: Icon(Icons.link),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: socialMediaData.facebookController,
              decoration: const InputDecoration(
                labelText: 'Facebook',
                prefixIcon: Icon(Icons.facebook_rounded),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: socialMediaData.twitterController,
              decoration: const InputDecoration(
                labelText: 'Twitter',
                prefixIcon: Icon(Icons.link_rounded),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: socialMediaData.instagramController,
              decoration: const InputDecoration(
                labelText: 'Instagram',
                prefixIcon: Icon(Icons.link_rounded),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => socialMediaData.saveSocialMediaLinks(context),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (socialMediaData.loading)
                    const SizedBox(
                      width: 25.0,
                      height: 25.0,
                      child: SpinKitWave(
                        color: Colors.white,
                        size: 25.0,
                      ),
                    ),
                  if (!socialMediaData.loading) const Text("Save"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
