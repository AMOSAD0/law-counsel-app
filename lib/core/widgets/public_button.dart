// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';

class PublicButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;

  const PublicButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.primaryColor,
    this.textColor = AppColors.whiteColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 25),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style:AppTextStyles.font16WhiteNormal,
          ),
        ),
      ),
    );
  }
}

class OnboradingButton {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;

  OnboradingButton({
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.width,
    this.height,
  });

  Widget buildButtonBoarding() {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.primaryColor,
        minimumSize: Size(width ?? double.infinity, height ?? 56.0),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor ?? Colors.white, fontSize: 25),
      ),
    );
  }

}
class TextbuttonAuth extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final TextStyle? style;
  const TextbuttonAuth({super.key, this.onPressed, this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text ?? "تسجيل مستخدم جديد",
        style: style ??
            AppTextStyles.font16primaryColorBold
      ),
    );
  }
}