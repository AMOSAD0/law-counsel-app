import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';

Widget minBackground() {
  return SizedBox(
    height: 250,
    width: double.infinity,
    child: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(AppAssets.background, fit: BoxFit.cover),
        Container(color: AppColors.primaryColor.withOpacity(0.6)),
        Center(child: Image.asset(AppAssets.logo2, width: 300)),
      ],
    ),
  );
}
