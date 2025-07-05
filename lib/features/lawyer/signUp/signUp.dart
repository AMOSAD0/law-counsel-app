import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/minBackground.dart';
import 'package:law_counsel_app/core/widgets/public_text_form_field.dart';
import 'package:law_counsel_app/features/lawyer/signUp/signUp2.dart';

class SignupForLawyer extends StatelessWidget {
  const SignupForLawyer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                minBackground(),
                verticalSpace(10),
                Text(
                  '!سجّل الأن مجاناً',
                  style: AppTextStyles.font24PrimarySemiBold,
                ),
                verticalSpace(15),
                Text(
                  '. ادخل البيانات التالية لانشاء حساب جديد',
                  style: AppTextStyles.font16GrayNormal,
                ),
                verticalSpace(15),
                PublicTextFormField(label: 'الأسم الكامل'),
                PublicTextFormField(label: 'البريد الأكتروني'),
                PublicTextFormField(label: 'رقم الهاتف'),
                PublicTextFormField(label: 'كلمه المرور'),
                PublicTextFormField(label: 'تأكيد كلمه المرور'),
                verticalSpace(25),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupForLawyer2(),
                      ),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    textDirection: TextDirection.rtl,
                    children: [
                      Text(
                        "اكمل بياناتك",
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.font24PrimarySemiBold,
                      ),
                      horizontalSpace(10),
                      Image(
                        image: AssetImage(AppAssets.iconDoubleRight),
                        height: 25.h,
                        width: 25.w,
                      ),
                    ],
                  ),
                ),
                verticalSpace(15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      "لديك حساب بالفعل ؟",
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.font16GrayNormal,
                    ),
                    horizontalSpace(10),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "سجل الدخول",
                        textDirection: TextDirection.rtl,
                        style: AppTextStyles.font14PrimaryBold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
