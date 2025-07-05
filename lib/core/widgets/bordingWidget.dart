import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';

Widget bordingWidget({
  required String image,
  required String title,
  required String subTitle,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(image, height: 500, fit: BoxFit.contain),
        ),
        const SizedBox(height: 30),
        Text(
          title,
          style: AppTextStyles.font28primaryColorBold,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          subTitle,
          style: AppTextStyles.font20gray600,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
