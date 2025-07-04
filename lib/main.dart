import 'package:flutter/material.dart';
import 'package:law_counsel_app/features/splash/ui/splaah_screen.dart';
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
      home: SplaahScreen(),
    );
  }
}