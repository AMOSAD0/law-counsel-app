import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.whiteColor,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      // secondary: Colors.amber,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.primaryColor),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightGreyColor,
      titleTextStyle: TextStyle(color: AppColors.primaryColor, fontSize: 20),
      iconTheme: IconThemeData(color: AppColors.primaryColor),
    ),
  );
  }