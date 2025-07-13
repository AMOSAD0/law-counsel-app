import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/widgets/bottomNav.dart';
import 'package:law_counsel_app/features/Consultion/UI/AddConsultion.dart';

class Homeclient extends StatefulWidget {
  const Homeclient({super.key});

  @override
  State<Homeclient> createState() => _HomeclientState();
}

class _HomeclientState extends State<Homeclient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الصفحة الرئيسية")),
      body: Column(
        children: [

          Center(
            child: Text(
              "مرحبا بك في الصفحة الرئيسية",
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}
