import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/blog_info_controller.dart';

class BlogInfo extends StatelessWidget {
  final String? blogId;
  final String? authorId;
  final String? title;
  final String? description;

  const BlogInfo({
    Key? key,
    this.blogId,
    this.authorId,
    this.title,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blogInfoProvider = Provider.of<BlogInfoProvider>(context);

    return FutureBuilder<DocumentSnapshot?>(
      future: blogInfoProvider.getUser(authorId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: SpinKitWave(
                color: Colors.brown,
                size: 50.0,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        final userData = snapshot.data?.data() as Map<String, dynamic>?;

        return Scaffold(
          appBar: AppBar(
            title: Text(userData?['name'] ?? 'Unknown Author'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Title:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      title ?? 'Unknown Title',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Description:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      description ?? "No description found",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Author:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userData?['name'] ?? 'Unknown Author',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Social Links:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (userData != null)
                      Column(
                        children: [
                          if (userData['facebook'] != null)
                            GestureDetector(
                              onTap: () => launch(userData['facebook']),
                              child: Text(
                                'Facebook: ${userData['facebook']}',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          if (userData['instagram'] != null)
                            GestureDetector(
                              onTap: () => launch(userData['instagram']),
                              child: Text(
                                'Instagram: ${userData['instagram']}',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          if (userData['twitter'] != null)
                            GestureDetector(
                              onTap: () => launch(userData['twitter']),
                              child: Text(
                                'Twitter: ${userData['twitter']}',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          if (userData['linkedin'] != null)
                            GestureDetector(
                              onTap: () => launch(userData['linkedin']),
                              child: Text(
                                'LinkedIn: ${userData['linkedin']}',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Consumer<BlogInfoProvider>(
                      builder: (context, blogProvider, _) {
                        return Text(
                          'Likes: ${blogProvider.likeCount}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      onPressed: () =>
                          blogInfoProvider.updateLikeCount(blogId!),
                      icon: Consumer<BlogInfoProvider>(
                        builder: (context, blogProvider, _) {
                          return Icon(
                            blogProvider.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: blogProvider.isLiked ? Colors.red : null,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
