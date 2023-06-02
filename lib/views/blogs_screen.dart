import 'package:fireblog/views/view_blog_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'create_blog_screen.dart';

class BlogProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getBlogPosts() {
    return _firestore.collection('blogPosts').snapshots();
  }

  Future<DocumentSnapshot?> getUser(String? authorId) {
    if (authorId == null || authorId.isEmpty) {
      return Future.value(null);
    }

    return _firestore.collection('users').doc(authorId).get();
  }
}

class BlogScreen extends StatelessWidget {
  const BlogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context);

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: blogProvider.getBlogPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final blogs = snapshot.data?.docs;

          return ListView.builder(
            itemCount: blogs?.length,
            itemBuilder: (context, index) {
              final blog = blogs?[index].data() as Map<String, dynamic>?;

              final blogId = blogs?[index].id;
              final title = blog?['title'];
              final authorId = blog?['authorUid'];
              final imageUrl = blog?['imageUrl'];
              final description = blog?['description'];
              print("Image: $imageUrl");
              return GestureDetector(
                onTap: () {
                  if (blogId != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ViewBlog(
                        blogId: blogId,
                        authorId: authorId,
                        title: title,
                        description: description,
                      ),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error'),
                      ),
                    );
                  }
                },
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      imageUrl == null
                          ? const SizedBox()
                          : CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        height: 200,
                        width: double.infinity,
                        placeholder: (context, url) =>
                        const SpinKitWave(
                          color: Colors.brown,
                          size: 50.0,
                        ),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              title ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8.0,
                        left: 8.0,
                        right: 8.0,
                        child: Text(
                          description ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              );

            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateBlog(),
            ),
          );
        },
        label: const Text('Create Blog'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
