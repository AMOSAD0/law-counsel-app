import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';

Widget minBackground() {
  return SizedBox(
    height: 185.h,
    width: double.infinity,
    child: Image.asset(AppAssets.topImg, fit: BoxFit.cover),

   
  );
}
