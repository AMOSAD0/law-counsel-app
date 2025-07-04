import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/theming/app_theme.dart';
import 'package:law_counsel_app/features/splash/ui/splaah_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Law Counsel App',
      theme:AppTheme.lightTheme,
      home: SplaahScreen(),
    );
  }
}