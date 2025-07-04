import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/features/onbording/onbordingScreen1.dart';

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
      appBar: AppBar(title: const Text("Test SVG")),
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          color: Colors.grey[300],
          child: SvgPicture.asset(
            'assets/images/logo.svg',
            width: 100,
            height: 100,
            placeholderBuilder: (context) => const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
