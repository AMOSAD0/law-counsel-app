import 'package:flutter/material.dart';

class Registerlawer extends StatefulWidget {
  const Registerlawer({super.key});

  @override
  State<Registerlawer> createState() => _RegisterlawerState();
}

class _RegisterlawerState extends State<Registerlawer> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Register Lawyer'),
      ),
      body: Center(
        child: Text(
          'This is the Register Lawyer screen.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}