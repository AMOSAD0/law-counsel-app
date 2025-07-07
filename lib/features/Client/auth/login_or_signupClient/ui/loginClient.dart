import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/helper/validators.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/minBackground.dart';
import 'package:law_counsel_app/core/widgets/public_button.dart';
import 'package:law_counsel_app/core/widgets/public_text_form_field.dart';
import 'package:law_counsel_app/features/Client/auth/client_bloc/client_bloc.dart';
import 'package:law_counsel_app/features/Client/auth/client_bloc/client_event.dart';
import 'package:law_counsel_app/features/Client/auth/client_bloc/client_state.dart';
import 'package:law_counsel_app/features/Client/auth/login_or_signupClient/RegisterClient.dart';
import 'package:law_counsel_app/features/SelectUser/selectUser.dart';

class Loginclient extends StatefulWidget {
  const Loginclient({super.key});

  @override
  State<Loginclient> createState() => _LoginclientState();
}

class _LoginclientState extends State<Loginclient> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientBloc, ClientState>(
      listener: (context, state) {
        if (state is ClientError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is ClientLoaded) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SelectUser()),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              minBackground(),
              if (state is ClientLoading) const LinearProgressIndicator(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      verticalSpace(20),
                      Text(
                        "! أهلا بعودتك",
                        style: AppTextStyles.font28primaryColorBold,
                      ),
                      verticalSpace(15),
                      Text(
                        "ادخل البيانات التاليه لتتمكن من الوصول \nالي حسابك",
                        style: AppTextStyles.font16GrayNormal,
                        textAlign: TextAlign.center,
                      ),
                      verticalSpace(30),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            PublicTextFormField(
                              controller: _emailController,
                              label: "البريد الإلكتروني",
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.validateEmail,
                            ),

                            PublicTextFormField(
                              controller: _passwordController,
                              label: "كلمة المرور",
                              obscureText: true,
                              validator: Validators.validatePassword,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "نسيت كلمة المرور؟",
                                style: AppTextStyles.font16primaryColorBold,
                              ),
                            ),
                            verticalSpace(20),
                            PublicButton(
                              text: "تسجيل الدخول",
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<ClientBloc>(context).add(
                                    ClientLoginEvent(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                                }
                              },
                            ),
                            verticalSpace(20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              textDirection: TextDirection.rtl,
                              children: [
                                Text(
                                  "لم تقم بإنشاء حساب؟",
                                  textDirection: TextDirection.rtl,
                                  style: AppTextStyles.font16GrayNormal,
                                ),
                                horizontalSpace(10),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "انشائي حساب",
                                    textDirection: TextDirection.rtl,
                                    style: AppTextStyles.font14PrimaryBold,
                                  ),
                                ),
                              ],
                            ),
                            verticalSpace(20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
