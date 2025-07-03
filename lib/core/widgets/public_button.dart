import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';




class PublicButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  final double? width;
  final double borderRadius;
  final double? titleSize;
  final Color titleColor;
  final Color backgroundColor;
  final String icon;
  final TextStyle style;
  final double? verticalpadding;

  const PublicButton({
    Key? key,
    required this.onPressed,
    this.titleSize,
    required this.title,
    this.width,
    this.borderRadius=30,
    this.titleColor = Colors.white,
    this.backgroundColor = AppColors.blueColor,
    this.icon = "",
    this.verticalpadding,
    required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 331.w,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: verticalpadding ?? 12.h),
          child: icon == ""
              ? Text(
            title,
            style: style,
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: style,
              ),
              SvgPicture.asset(icon)
            ],
          ),
        ),
      ),
    );
  }
}