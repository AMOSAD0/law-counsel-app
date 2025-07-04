import 'package:flutter/material.dart';

class RegisterClient extends StatefulWidget {
  const RegisterClient({super.key});

  @override
  State<RegisterClient> createState() => _RegisterClientState();
}

class _RegisterClientState extends State<RegisterClient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Client'),
      ),
      body: Center(
        child: Text(
          'This is the Register Client screen.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}