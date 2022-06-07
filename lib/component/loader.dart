import 'package:flutter/material.dart';

class Progress extends StatelessWidget {
  static String id = "load";
  const Progress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
