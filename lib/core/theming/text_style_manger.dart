import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';

class TextStyleManger {
  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.bold,
    color: ColorsManager.primaryColor,
  );

  static const TextStyle subHeading = TextStyle(
    fontSize: 20,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.w600,
    color: ColorsManager.textColorParagraph,
  );
  static const TextStyle selectText = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: ColorsManager.primaryColor,
  );
}
