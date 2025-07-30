import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';

Widget buildCardItem(String imagePath, String title) {
  return Container(
    width: 250,
    margin: const EdgeInsets.only(right: 5, top: 10),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppColors.primaryColor),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imagePath, width: 50.w),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    ),
  );
}
