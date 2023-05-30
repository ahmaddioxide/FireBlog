import 'package:fireblog/views/create_blog_screen.dart';
import 'package:flutter/material.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: const Text('Blog Screen'),
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

