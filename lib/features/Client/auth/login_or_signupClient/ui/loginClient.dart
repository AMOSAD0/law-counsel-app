import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/helper/validators.dart';
import 'package:law_counsel_app/core/routing/routes.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/bottomNav.dart';
import 'package:law_counsel_app/core/widgets/customAlertPopup.dart';
import 'package:law_counsel_app/core/widgets/minBackground.dart';
import 'package:law_counsel_app/core/widgets/public_button.dart';
import 'package:law_counsel_app/core/widgets/public_text_form_field.dart';
import 'package:law_counsel_app/features/Client/auth/client_bloc/client_bloc.dart';
import 'package:law_counsel_app/features/Client/auth/client_bloc/client_event.dart';
import 'package:law_counsel_app/features/Client/auth/client_bloc/client_state.dart';

class Loginclient extends StatelessWidget {
  const Loginclient({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClientBloc(),
      child: const LoginClientBody(),
    );
  }
}

class LoginClientBody extends StatefulWidget {
  const LoginClientBody({super.key});

  @override
  State<LoginClientBody> createState() => _LoginClientBodyState();
}

class _LoginClientBodyState extends State<LoginClientBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientBloc, ClientState>(
      listener: (context, state) {
        if (state is ClientError) {
          AlertPopup.show(context,
           message: state.message);
        } else if (state is IsClient) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavBarApp()),
          );
        }else if(state is IsLawyer){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavBarApp(isLawyer: true,)),
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
                  // padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      verticalSpace(20),
                      Text(
                        "! أهلا بعودتك",
                        style: AppTextStyles.font28primaryColorBold,
                      ),
                      verticalSpace(15),
                      Text(
                        "ادخل البيانات التالية لتتمكن من الوصول\nإلى حسابك",
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
                              onPressed: () {
                              },
                              child: Text(
                                "نسيت كلمة المرور؟",
                                style: AppTextStyles.font16primaryColorBold,
                              ),
                            ),
                            verticalSpace(20),
                            PublicButton(
                              text: state is ClientLoading
                                  ? "جاري تسجيل الدخول..."
                                  : "تسجيل الدخول",
                              onPressed: () {
                                if (state is! ClientLoading &&
                                    _formKey.currentState!.validate()) {
                                  context.read<ClientBloc>().add(
                                        ClientLoginEvent(
                                          email: _emailController.text.trim(),
                                          password:
                                              _passwordController.text.trim(),
                                        ),
                                      );
                                }
                              },
                            ),
                            verticalSpace(20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "لم تقم بإنشاء حساب؟",
                                  style: AppTextStyles.font16GrayNormal,
                                ),
                                horizontalSpace(10),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context,Routes.selectUserType); // أو روح لشاشة التسجيل
                                  },
                                  child: Text(
                                    "إنشاء حساب",
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


// class Loginclient extends StatefulWidget {
//   const Loginclient({super.key});

//   @override
//   State<Loginclient> createState() => _LoginclientState();
// }

// class _LoginclientState extends State<Loginclient> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<ClientBloc, ClientState>(
//       listener: (context, state) {
//         if (state is ClientError) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(state.message)));
//         } else if (state is ClientLoaded) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => BottomNavBarApp()),
//           );
//         }
//       },
//       builder: (context, state) {
//         return Scaffold(
//           body: Column(
//             children: [
//               minBackground(),
//               if (state is ClientLoading) const LinearProgressIndicator(),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       verticalSpace(20),
//                       Text(
//                         "! أهلا بعودتك",
//                         style: AppTextStyles.font28primaryColorBold,
//                       ),
//                       verticalSpace(15),
//                       Text(
//                         "ادخل البيانات التاليه لتتمكن من الوصول \nالي حسابك",
//                         style: AppTextStyles.font16GrayNormal,
//                         textAlign: TextAlign.center,
//                       ),
//                       verticalSpace(30),
//                       Form(
//                         key: _formKey,
//                         child: Column(
//                           children: [
//                             PublicTextFormField(
//                               controller: _emailController,
//                               label: "البريد الإلكتروني",
//                               keyboardType: TextInputType.emailAddress,
//                               validator: Validators.validateEmail,
//                             ),

//                             PublicTextFormField(
//                               controller: _passwordController,
//                               label: "كلمة المرور",
//                               obscureText: true,
//                               validator: Validators.validatePassword,
//                             ),
//                             TextButton(
//                               onPressed: () {},
//                               child: Text(
//                                 "نسيت كلمة المرور؟",
//                                 style: AppTextStyles.font16primaryColorBold,
//                               ),
//                             ),
//                             verticalSpace(20),
//                             PublicButton(
//                               text: "تسجيل الدخول",
//                               onPressed: () {
//                                 if (_formKey.currentState!.validate()) {
//                                   BlocProvider.of<ClientBloc>(context).add(
//                                     ClientLoginEvent(
//                                       email: _emailController.text,
//                                       password: _passwordController.text,
//                                     ),
//                                   );
//                                 }
//                               },
//                             ),
//                             verticalSpace(20),
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               textDirection: TextDirection.rtl,
//                               children: [
//                                 Text(
//                                   "لم تقم بإنشاء حساب؟",
//                                   textDirection: TextDirection.rtl,
//                                   style: AppTextStyles.font16GrayNormal,
//                                 ),
//                                 horizontalSpace(10),
//                                 TextButton(
//                                   onPressed: () {},
//                                   child: Text(
//                                     "انشائي حساب",
//                                     textDirection: TextDirection.rtl,
//                                     style: AppTextStyles.font14PrimaryBold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             verticalSpace(20),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
