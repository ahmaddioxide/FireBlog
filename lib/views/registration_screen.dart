import 'package:flutter/material.dart';


class Registration extends StatelessWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registration"),),
      body: const Center(
        child: Text("Registration"),
      ),
    );
  }
}
