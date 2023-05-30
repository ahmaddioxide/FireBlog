import 'package:flutter/material.dart';


class ContentInput extends StatefulWidget {
  final String blogId;
  const ContentInput({Key? key,
    required this.blogId,
  }) : super(key: key);

  @override
  State<ContentInput> createState() => _ContentInputState();
}

class _ContentInputState extends State<ContentInput> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
