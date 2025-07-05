import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/AlertDialogApp.dart';
import 'package:law_counsel_app/core/widgets/minBackground.dart';
import 'package:law_counsel_app/core/widgets/public_button.dart';
import 'package:law_counsel_app/core/widgets/public_text_form_field.dart';
import 'package:law_counsel_app/features/Client/auth/client_bloc/client_bloc.dart';
import 'package:law_counsel_app/features/Client/auth/client_bloc/client_event.dart';
import 'package:law_counsel_app/features/Client/auth/client_bloc/client_state.dart';
import 'package:law_counsel_app/features/Client/auth/login_or_signupClient/ui/loginClient.dart';

class RegisterClient extends StatefulWidget {
  const RegisterClient({super.key});

  @override
  State<RegisterClient> createState() => _RegisterClientState();
}

class _RegisterClientState extends State<RegisterClient> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
            MaterialPageRoute(builder: (context) => Loginclient()),
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
                        "سجل الان مجانا",
                        style: AppTextStyles.font28primaryColorBold,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "ادخل البيانات التالية لانشاء حساب جديد.",
                        style: AppTextStyles.font20gray600,
                      ),
                      verticalSpace(20),
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              PublicTextFormField(
                                label: "الاسم الكامل",
                                controller: _nameController,
                              ),
                              verticalSpace(20),
                              PublicTextFormField(
                                label: "البريد الإلكتروني",
                                controller: _emailController,
                              ),
                              verticalSpace(20),
                              PublicTextFormField(
                                label: "رقم الهاتف",
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                              ),
                              verticalSpace(20),
                              PublicTextFormField(
                                label: "كلمة المرور",
                                controller: _passwordController,
                                obscureText: true,
                              ),
                              verticalSpace(20),
                              PublicTextFormField(
                                label: "تأكيد كلمة المرور",
                                controller: _confirmPasswordController,
                                obscureText: true,
                              ),
                              verticalSpace(20),

                              PublicButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (_passwordController.text !=
                                        _confirmPasswordController.text) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlrtDialogApp(
                                          title: "خطأ",
                                          content: "كلمتا المرور غير متطابقتين",
                                          buttonText: "حسنًا",
                                        ),
                                      );
                                      return;
                                    }
                                    context.read<ClientBloc>().add(
                                      ClientRegisterEvent(
                                        _nameController.text.trim(),
                                        email: _emailController.text.trim(),
                                        _phoneController.text.trim(),
                                        password: _passwordController.text
                                            .trim(),
                                      ),
                                    );
                                  }
                                },

                                text: "تسجيل مستخدم جديد",
                              ),
                              verticalSpace(20),
                              Row(
                                children: [
                                  Text(
                                    "لديك حساب بالفعل؟",
                                    style: AppTextStyles.font16primaryColorBold,
                                  ),
                                  TextbuttonAuth(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Loginclient(),
                                        ),
                                      );
                                    },
                                    text: "تسجيل الدخول",
                                    style: AppTextStyles.font16primaryColorBold,
                                  ),
                                ],
                              ),
                            ],
                          ),
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
