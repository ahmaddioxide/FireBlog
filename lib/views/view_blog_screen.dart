import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'blog_info_screen.dart';

class ViewBlog extends StatefulWidget {
  final String blogId;
  final String authorId;
  final String title;
  final String description;

  const ViewBlog({
    Key? key,
    required this.blogId,
    required this.authorId,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  State<ViewBlog> createState() => _ViewBlogState();
}

class _ViewBlogState extends State<ViewBlog> {
  quill.QuillController _controller = quill.QuillController.basic();

  Future<String> getAuthorName() async {
    String? name;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.authorId)
        .get()
        .then((value) {
      name = value.data()?['name'].toString();
    });
    return name!;
  }

  @override
  void initState() {
    super.initState();
    _controller = quill.QuillController.basic();

    _fetchContent();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchContent() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('blogPosts')
          .doc(widget.blogId)
          .get();

      final content = snapshot.data()?['content'];

      if (content != null) {
        setState(
          () {
            _controller = quill.QuillController(
              document: quill.Document.fromJson(content),
              selection: const TextSelection.collapsed(
                offset: 0,
                affinity: TextAffinity.upstream,
              ),
            );
          },
        );
      }
    } catch (e) {
      debugPrint('Error fetching content: $e');
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Blog'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.info_outline_rounded, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlogInfo(
                      blogId: widget.blogId,
                      authorId: widget.authorId,
                      title: widget.title,
                      description: widget.description,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(
                    'By ${snapshot.data}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
              future: getAuthorName(),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: quill.QuillEditor.basic(
                controller: _controller,
                readOnly: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
