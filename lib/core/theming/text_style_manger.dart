import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';

class AppTextStyles {
  // static TextStyle font60WhiteExtiraBold = TextStyle(
  //     fontSize: 40.sp,
  //     color: AppColors.whiteColor,
  //     fontWeight: FontWeight.w900,
  //   );

  // 100-300: Light weights
  // 400: Normal weight
  // 500: Medium weight
  // 600: Semi-bold (or Demi-bold)
  // 700: Bold
  // 800-900: Extra-bold or Black

  static TextStyle font28primaryColorBold = TextStyle(
    fontSize: 28.sp,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );

  static TextStyle font16GrayNormal = TextStyle(
    fontSize: 16.sp,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.normal,
    color: AppColors.greyColor,
  );

  static TextStyle font30primaryColorBold = TextStyle(
    fontSize: 30.sp,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );
  static TextStyle font16primaryColorBold = TextStyle(
    fontSize: 16.sp,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );

  static TextStyle font14PrimarySemiBold = TextStyle(
    fontSize: 14.sp,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
  );

  static TextStyle font14PrimaryBold = TextStyle(
    fontSize: 14.sp,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );

  static TextStyle font18PrimaryNormal = TextStyle(
    fontSize: 18.sp,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.normal,
    color: AppColors.primaryColor,
  );

  static TextStyle font18WhiteNormal = TextStyle(
    fontSize: 18.sp,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.normal,
    color: AppColors.whiteColor,
  );
  static TextStyle font16WhiteNormal = TextStyle(
    fontSize: 16.sp,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.w600,
    color: AppColors.whiteColor,
  );

  static TextStyle font24PrimarySemiBold = TextStyle(
    fontSize: 24.sp,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
  );

  static TextStyle font20PrimarySemiBold = TextStyle(
    fontSize: 20.sp,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
  );

  static TextStyle font24WhiteSemiBold = TextStyle(
    fontSize: 24.sp,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.w600,
    color: AppColors.whiteColor,
  );
  static TextStyle font14PrimaryBoldUnderline = TextStyle(
    fontSize: 14.sp,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
    decoration: TextDecoration.underline,
  );
}
