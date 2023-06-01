import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
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
  final FocusNode _focusNode = FocusNode();
  QuillController _controller = QuillController.basic();
  @override
  void initState() {
    super.initState();
    _controller = QuillController.basic();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _saveContent() async {
    final content = _controller?.document.toDelta().toJson();
    if (content != null) {
      try {
        await FirebaseFirestore.instance
            .collection('blogPosts')
            .doc(widget.blogId)
            .update({'content': content});
        // Content saved successfully
        // You can navigate to another screen or perform other actions
      } catch (e) {
        // Error occurred while saving the content
        print('Error saving content: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20,left: 10,right: 10,bottom: 20),
              width: MediaQuery.of(context).size.width,
              height: 80,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage('https://user-images.githubusercontent.com/10923085/119221946-2de89000-baf2-11eb-8285-68168a78c658.png'),
                      fit: BoxFit.cover
                  )
              ),
            ),
            Padding(padding: const EdgeInsets.only(top: 0),
              child:
              QuillToolbar.basic(controller: _controller,
                fontSizeValues:  const {'Small': '7', 'Medium': '20.5', 'Large': '40'},
                showAlignmentButtons: false ,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    boxShadow: [BoxShadow(
                        color: Colors.lightBlueAccent,
                        offset: Offset(5.0, 5.0)    ,
                        blurRadius: 10.0,
                        spreadRadius: 2.0
                    ),
                      BoxShadow(
                          color: Colors.white,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 0.0,
                          spreadRadius: 0.0
                      )
                    ]
                ),
                child:
                QuillEditor.basic(controller: _controller, readOnly: false),),
            )
          ],
        ),
      ),
    );
  }
}
