import 'package:flutter/material.dart';
import 'package:helloflutter/main_container.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "Poppins"),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[700],
          centerTitle: true,
          title: const Text(
            "Hello flutter",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: MainContainer()
      ),
    );
  }
}
