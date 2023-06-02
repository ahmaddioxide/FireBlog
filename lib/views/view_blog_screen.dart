import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewBlog extends StatefulWidget {
  final String blogId;

  const ViewBlog({
    Key? key,
    required this.blogId,
  }) : super(key: key);

  @override
  State<ViewBlog> createState() => _ViewBlogState();
}

class _ViewBlogState extends State<ViewBlog> {
  quill.QuillController _controller = quill.QuillController.basic();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controller = quill.QuillController.basic();

    _fetchContent();
  }

  @override
  void dispose() {
    _controller?.dispose();
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
        setState(() {
          _controller = quill.QuillController(
              document: quill.Document.fromJson(content),
              selection: const TextSelection.collapsed(
                  offset: 0, affinity: TextAffinity.upstream));
        });
      }
    } catch (e) {
      print('Error fetching content: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Blog'),
      ),
      body: _controller != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: quill.QuillEditor.basic(
                  controller: _controller, readOnly: true),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
