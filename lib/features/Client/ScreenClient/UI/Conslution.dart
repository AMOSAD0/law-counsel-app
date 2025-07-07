import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/widgets/bottomNav.dart';

class Consolation extends StatefulWidget {
  const Consolation({super.key});

  @override
  State<Consolation> createState() => _ConsolationState();
}

class _ConsolationState extends State<Consolation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: const Text("استشارتي")),
      body: Center(
        child: Text("مرحبا بك في استشارتي", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
