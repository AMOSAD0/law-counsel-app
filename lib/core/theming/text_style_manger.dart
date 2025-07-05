import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';

class AppTextStyles {

// static TextStyle font60WhiteExtiraBold = TextStyle(
//     fontSize: 40.sp,
//     color: AppColors.whiteColor,
//     fontWeight: FontWeight.w900,
//   );
  
    static  TextStyle font28primaryColorBold = TextStyle(
    fontSize: 28.sp,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );

  static  TextStyle  font20gray600= TextStyle(
    fontSize: 20.sp,
    fontFamily: 'Cairo',
    fontWeight: FontWeight.w600,
    color: AppColors.greyColor,
  );
  static  TextStyle  font30primaryColorBold = TextStyle(
    fontSize: 30.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );
static TextStyle font16primaryColorBold = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryColor,
  );

 
}

