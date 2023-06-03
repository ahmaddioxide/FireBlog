import 'package:fireblog/views/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:cloud_firestore/cloud_firestore.dart';

class ContentInput extends StatefulWidget {
  final String blogId;

  const ContentInput({
    Key? key,
    required this.blogId,
  }) : super(key: key);

  @override
  State<ContentInput> createState() => _ContentInputState();
}

class _ContentInputState extends State<ContentInput> {
  // final FocusNode _focusNode = FocusNode();
  quill.QuillController _controller = quill.QuillController.basic();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controller = quill.QuillController.basic();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveContent() async {
    final content = _controller.document.toDelta().toJson();
    try {
      await FirebaseFirestore.instance
          .collection('blogPosts')
          .doc(widget.blogId)
          .update({'content': content}).then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen(),),);
      });
      // Content saved successfully
      _showSnackBar('Content saved successfully');
    } catch (e) {
      // Error occurred while saving the content
      _showSnackBar('Error saving content');
      print('Error saving content: $e');
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    quill.QuillToolbar.basic(
                      controller: _controller,
                      fontSizeValues: const {
                        'Small': '7',
                        'Medium': '20.5',
                        'Large': '40'
                      },
                      showAlignmentButtons: false,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width,
                        child: quill.QuillEditor.basic(
                            controller: _controller, readOnly: false),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: _saveContent,
                        child: const Text('Save Content'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
