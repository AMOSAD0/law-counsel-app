import 'package:flutter/material.dart';
import 'package:weather_prediction_app/core/strings/strings_manger.dart';
import 'package:weather_prediction_app/core/theming/text_style_manger.dart';

class TitleSignup extends StatelessWidget {
  const TitleSignup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
          Text(
                  AppStrings.signup,
                  style: AppStyles.font30BlueBold,
                ),
                Text(
                  AppStrings.signupSubTitle,
                  style: AppStyles.font14BlueNormal,
                ),
      ],
    );
  }
}