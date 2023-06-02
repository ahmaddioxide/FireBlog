import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String _authorName;

  Future<String> getAuthorName() async {
    String? name;
      await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.authorId)
        .get().then((value) {
          name=value.data()?['name'].toString();
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
              child: Column(
                children: [
                  Text(
                    widget.title!,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder(builder: (context, snapshot) {
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
                        child: SpinKitWave(
                          color: Colors.brown,
                          size: 20.0,
                        ),
                      );
                    }
                  }, future: getAuthorName()),
                  const SizedBox(height: 10),
                  quill.QuillEditor.basic(
                      controller: _controller, readOnly: true),
                ],
              ),
            )
          : const Center(
              child: SpinKitWave(
                color: Colors.brown,
                size: 50.0,
              ),
            ),
    );
  }
}
