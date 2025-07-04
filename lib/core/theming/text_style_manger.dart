import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';

class AppTextStyles {

// static TextStyle font60WhiteExtiraBold = TextStyle(
//     fontSize: 40.sp,
//     color: AppColors.whiteColor,
//     fontWeight: FontWeight.w900,
//   );
  
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

