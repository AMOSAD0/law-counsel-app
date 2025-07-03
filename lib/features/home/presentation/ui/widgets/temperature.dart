import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_prediction_app/core/theming/color_manger.dart';
import 'package:weather_prediction_app/core/theming/text_style_manger.dart';

class Temperature extends StatelessWidget {
  final String temp;
  const Temperature({super.key,required this.temp});

  @override
  Widget build(BuildContext context) {
    return  CircleAvatar(
                radius: 70.r,
                backgroundColor: AppColors.blueColor,
                child: Stack(
                  children: [
                    Positioned(
                      top: 20.h,
                      right: 10.w,
                      child: Text(" \u2103",
                      style: AppStyles.font40WhiteBold,
                      ),
                    ),
                    Positioned(
                     top: 40.h,
                      left: 20.w,
                      child: Text(temp,
                      style: AppStyles.font60WhiteExtiraBold,
                      ),
                    ),
                   
                  ],
                ),
              );
  }
}