import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/minBackground.dart';
import 'package:law_counsel_app/core/widgets/public_text_form_field.dart';
import 'package:law_counsel_app/features/lawyer/signUp/widgets/specialization_selector.dart';

class SignupForLawyer2 extends StatelessWidget {
  const SignupForLawyer2({super.key});

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
                Text('!سجّل الأن مجاناً', style: AppTextStyles.font24PrimarySemiBold),
                verticalSpace(15),
                Text(
                  '. ادخل البيانات التالية لانشاء حساب جديد',
                  style: AppTextStyles.font20gray600,
                ),
                verticalSpace(15),
                PublicTextFormField(label: 'تاريخ الميلاد'),
                PublicTextFormField(label: 'المدينة'),
                PublicTextFormField(label: 'ارفع صورة البطاقة الشخصية'),
                PublicTextFormField(label: 'ارفع بطاقة عضوية نقابة المحامين'),
                verticalSpace(25),
                SpecializationSelector(),
                
                verticalSpace(15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      "لديك حساب بالفعل ؟",
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.font20gray600,
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