import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/routing/routes.dart';
import 'package:law_counsel_app/features/SelectUser/selectUser.dart';
import 'package:law_counsel_app/features/login-signUpLawyer/RegisterLawer.dart';
import 'package:law_counsel_app/features/login_or_signupClient/RegisterClient.dart';
import 'package:law_counsel_app/features/onbording/onbordingScreen.dart';
import 'package:law_counsel_app/features/splash/ui/splaah_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplaahScreen());
      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => const Onbordingscreen1());
      case Routes.selectUserType:
        return MaterialPageRoute(builder: (_) => const SelectUser());
      case Routes.registerClient:
        return MaterialPageRoute(
          builder: (_) => const RegisterClient(),
        );
      case Routes.registerLawyer:
        return MaterialPageRoute(
          builder: (_) => const Registerlawer(),
        );


      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("الصفحة غير موجودة")),
          ),
        );
    }
  }
}
