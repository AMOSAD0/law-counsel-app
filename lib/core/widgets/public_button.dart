import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';

class PublicButton {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;

  PublicButton({
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.width,
    this.height,
  });

  Widget buildButtonBoarding() {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? ColorsManager.primaryColor,
        minimumSize: Size(width ?? double.infinity, height ?? 56.0),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor ?? Colors.white, fontSize: 25),
      ),
    );
  }
}
