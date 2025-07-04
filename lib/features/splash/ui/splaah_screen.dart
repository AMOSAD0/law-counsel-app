import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/features/onbording/onbordingScreen.dart';

class SplaahScreen extends StatefulWidget {
  const SplaahScreen({super.key});

  @override
  State<SplaahScreen> createState() => _SplaahScreenState();
}

class _SplaahScreenState extends State<SplaahScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 7), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Onbordingscreen1()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          child: Image.asset(AppAssets.logo, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
