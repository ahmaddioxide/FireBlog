import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        title: const Text('Social Media Links'),
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
                prefixIcon: Icon(FontAwesomeIcons.linkedin),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: socialMediaData.facebookController,
              decoration:  const InputDecoration(
                labelText: 'Facebook',
                prefixIcon: Icon(FontAwesomeIcons.facebook),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: socialMediaData.twitterController,
              decoration: const InputDecoration(
                labelText: 'Twitter',
                prefixIcon: Icon(FontAwesomeIcons.twitter),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: socialMediaData.instagramController,
              decoration: const InputDecoration(
                labelText: 'Instagram',
                prefixIcon: Icon(FontAwesomeIcons.instagram),
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
