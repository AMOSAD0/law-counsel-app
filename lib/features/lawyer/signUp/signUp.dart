import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/helper/validators.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/minBackground.dart';
import 'package:law_counsel_app/core/widgets/public_text_form_field.dart';
import 'package:law_counsel_app/features/Client/auth/login_or_signupClient/ui/loginClient.dart';
import 'package:law_counsel_app/features/lawyer/model/lawyerModel.dart';
import 'package:law_counsel_app/features/lawyer/signUp/signUp2.dart';

class SignupForLawyer extends StatelessWidget {
  SignupForLawyer({super.key});

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                PublicTextFormField(
                  label: 'الأسم الكامل',
                  controller: nameController,
                  validator: Validators.validateName,
                ),
                PublicTextFormField(
                  label: 'البريد الأكتروني',
                  controller: emailController,
                  validator: Validators.validateEmail,
                ),
                PublicTextFormField(
                  label: 'رقم الهاتف',
                  controller: phoneController,
                  validator: Validators.validatePhone,
                ),
                PublicTextFormField(
                  label: 'كلمه المرور',
                  controller: passwordController,
                  obscureText: true,
                  validator: Validators.validatePassword,
                ),
                PublicTextFormField(
                  label: 'تأكيد كلمه المرور',
                  controller: confirmPasswordController,
                  obscureText: true,
                  validator: (value) => Validators.validateConfirmPassword(
                    value,
                    passwordController.text,
                  ),
                ),
                verticalSpace(25),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      final lawyer = Lawyer(
                        name: nameController.text,
                        email: emailController.text,
                        phoneNumber: phoneController.text,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupForLawyer2(
                            lawyer: lawyer,
                            password: passwordController.text,
                          ),
                        ),
                      );
                    }
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Loginclient(),
                          ),
                        );
                      },
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
