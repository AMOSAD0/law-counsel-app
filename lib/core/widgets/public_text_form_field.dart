import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';


class PublicTextFormField extends StatefulWidget {
  final String hint;
  final String? label;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final TextInputType keyboardtype;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final bool isPassword;
  final bool showprefixIcon;
  final bool showSuffixIcon;
  final int? maxlenght;
  final int? maxLines;
  final Function()? ontap;
  final Function()? ontapPrefixIcon;
  final Function()? ontapSuffixIcon;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  const PublicTextFormField({
    Key? key,
    required this.hint,
    required this.validator,
    this.label,
    this.controller,
    this.isPassword = false,
    this.showSuffixIcon = false,
    this.showprefixIcon = false,
    this.ontap,
    this.keyboardtype = TextInputType.text,
    this.maxlenght,
    this.maxLines,
    this.prefixIcon = Icons.person,
    this.suffixIcon = Icons.person,
    this.ontapPrefixIcon,
    this.ontapSuffixIcon,
    this.borderRadius = 25,
    this.contentPadding,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<PublicTextFormField> createState() => _PublicTextFormFieldState();
}

class _PublicTextFormFieldState extends State<PublicTextFormField> {
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.5.h),
      child: SizedBox(
        //width: 374.w,
        //height: 57.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              child: Text(
                widget.label ?? "",
                style: AppStyles.font16BlueBold,
              ),
            ),
            TextFormField(
              textCapitalization: TextCapitalization.none,
              maxLines: widget.maxLines ?? 1,
              maxLength: widget.maxlenght,
              obscureText: widget.isPassword ? showPassword : false,
              keyboardType: widget.keyboardtype,
              controller: widget.controller,
              autovalidateMode: AutovalidateMode.disabled,
              validator: widget.validator,
              decoration: InputDecoration(
                fillColor: AppColors.whiteColor,
                iconColor: AppColors.greyColor,
                filled: true,
                hintText: widget.hint,
                hintStyle: AppStyles.font14GreyNormal,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide:
                      const BorderSide(color: AppColors.greyColor, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide:
                      const BorderSide(color: AppColors.blueColor, width: 0.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: const BorderSide(color: Colors.red, width: 0.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: const BorderSide(color: Colors.red, width: 0.5),
                ),
                contentPadding: widget.contentPadding ??
                    EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                prefixIcon: widget.showprefixIcon
                    ? InkWell(
                        onTap: widget.ontapPrefixIcon,
                        child: Icon(
                          widget.prefixIcon,
                          size: 22.r,
                          color: AppColors.greyColor,
                        ),
                      )
                    : null,
                suffixIcon: getSuffixIcon(),
              ),
              onChanged: widget.onChanged,
              onFieldSubmitted: widget.onSubmitted,
            ),
          ],
        ),
      ),
    );
  }

  Widget? getSuffixIcon() {
    if (widget.showSuffixIcon) {
      if (!widget.isPassword) {
        return Icon(
          widget.suffixIcon,
          size: 22,
          color: AppColors.greyColor,
        );
      }
      return InkWell(
        onTap: (() {
          setState(() {
            showPassword = !showPassword;
          });
        }),
        child: !showPassword
            ? const Icon(
                Icons.visibility,
                color: AppColors.greyColor,
              )
            : const Icon(
                Icons.visibility_off,
                color: AppColors.greyColor,
              ),
      );
    }
    return null;
  }
}
