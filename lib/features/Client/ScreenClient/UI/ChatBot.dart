import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/widgets/bottomNav.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
 
      appBar: AppBar(title: const Text("شات بوت")),
      body: Center(
        child: Text("مرحبا بك في شات بوت", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
