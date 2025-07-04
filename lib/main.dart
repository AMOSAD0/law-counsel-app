import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Law Counsel App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Law Counsel Home'),
        ),
        body: Center(
          child: Text('Welcome to Law Counsel App!'),
        ),
      ),
    );
  }
}