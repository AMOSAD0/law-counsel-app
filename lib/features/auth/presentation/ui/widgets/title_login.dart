
import 'package:flutter/material.dart';
import 'package:weather_prediction_app/core/strings/strings_manger.dart';
import 'package:weather_prediction_app/core/theming/text_style_manger.dart';

class TitleLogin extends StatelessWidget {
  const TitleLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
          Text(
                  AppStrings.login,
                  style: AppStyles.font30BlueBold,
                ),
                Text(
                  AppStrings.loginSubTitle,
                  style: AppStyles.font14BlueNormal,
                ),
      ],
    );
  }
}