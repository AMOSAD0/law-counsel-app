import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_prediction_app/core/assets/assets_manger.dart';
import 'package:weather_prediction_app/core/routing/routes.dart';
import 'package:weather_prediction_app/core/strings/strings_manger.dart';
import 'package:weather_prediction_app/core/theming/text_style_manger.dart';
import 'package:weather_prediction_app/core/widgets/public_button.dart';

class LoginOrSignupScreen extends StatelessWidget {
  const LoginOrSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //verticalSpace(20.h),
              SvgPicture.asset(
                              AppAssets.logo,
                              width: 200.w,
                            ),
              //verticalSpace(40.h),
              Column(
                spacing: 20.h,
                children: [
                  PublicButton(
                    title: AppStrings.signup,
                    style: AppStyles.font20WhiteBold,
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.signup);
                    },
                  ),
                  PublicButton(
                    title: AppStrings.login,
                    style: AppStyles.font20WhiteBold,
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.login);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
