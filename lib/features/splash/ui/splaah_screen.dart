import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/core/routing/routes.dart';
import 'package:law_counsel_app/core/widgets/bottomNav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplaahScreen extends StatefulWidget {
  const SplaahScreen({super.key});

  @override
  State<SplaahScreen> createState() => _SplaahScreenState();
}

class _SplaahScreenState extends State<SplaahScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4), () async {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('uid');
      final userType = prefs.getString('userType');
      if (uid == null) {
        Navigator.pushReplacementNamed(context, Routes.onboarding);
      } else {
        if (userType == 'lawyer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavBarApp(isLawyer: true)),
          );
        } else if (userType == 'client') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBarApp(),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(child: Image.asset(AppAssets.logo, fit: BoxFit.cover)),
      ),
    );
  }
}
