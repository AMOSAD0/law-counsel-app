import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/helper/validators.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/minBackground.dart';
import 'package:law_counsel_app/core/widgets/public_button.dart';
import 'package:law_counsel_app/core/widgets/public_text_form_field.dart';
import 'package:law_counsel_app/features/forget%20password/bloc/forgetPasswordBloc.dart';
import 'package:law_counsel_app/features/forget%20password/bloc/forgetPasswordEvent.dart';
import 'package:law_counsel_app/features/forget%20password/bloc/forgetPasswordState.dart';

class Forgetpassword extends StatelessWidget {
  Forgetpassword({super.key});

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Forgetpasswordbloc(),
      child: Scaffold(
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
                    'استعادة كلمه المرور',
                    style: AppTextStyles.font24PrimarySemiBold,
                  ),
                  verticalSpace(15),
                  Text(
                    'قم بادخال البريد الالكتروني لاستعاده \nكلمه المرور الخاصه بيك',
                    style: AppTextStyles.font16GrayNormal,
                    textAlign: TextAlign.center,
                  ),
                  verticalSpace(55),
                  PublicTextFormField(
                    label: 'البريد الأكتروني',
                    controller: emailController,
                    validator: Validators.validateEmail,
                  ),
                  verticalSpace(25),
                  BlocConsumer<Forgetpasswordbloc, Forgetpasswordstate>(
                    listener: (context, state) {
                      if (state.status == Forgetpasswordstatus.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("تم إرسال الإيميل بنجاح")),
                        );
                      } else if (state.status == Forgetpasswordstatus.failure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("حصل خطأ: ${state.error ?? ''}"),
                          ),
                        );
                      }
                    },
                    builder:
                        (context, state) => PublicButton(
                          text: state.status == Forgetpasswordstatus.loading
                                ?'جاري تحقق ...'
                                :"نحقق",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<Forgetpasswordbloc>().add(
                                ForgetpasswordSubmitted(email: emailController.text)
                              );
                            }
                          },
                        ),
                  ),
                  verticalSpace(45),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    textDirection: TextDirection.rtl,
                    children: [
                      Text(
                        "تذكرت كلمه المرور؟ ",
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
      ),
    );
  }
}
