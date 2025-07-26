import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/routing/routes.dart';
import 'package:law_counsel_app/features/Client/auth/login_or_signupClient/ui/loginClient.dart';
import 'package:law_counsel_app/features/SelectUser/selectUser.dart';
import 'package:law_counsel_app/features/Client/auth/login_or_signupClient/ui/RegisterClient.dart';
import 'package:law_counsel_app/features/lawyer/profileLawer/editProfileLawyer.dart';
import 'package:law_counsel_app/features/lawyer/profileLawer/profileLawyer.dart';
import 'package:law_counsel_app/features/lawyer/signUp/signUp.dart';
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
        return MaterialPageRoute(builder: (_) => const RegisterClient());
      case Routes.registerLawyer:
        return MaterialPageRoute(builder: (_) => SignupForLawyer());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => Loginclient());

      case Routes.profileLawyer:
        return MaterialPageRoute(builder: (_) => const LawyerProfilePage());
      case Routes.editProfileLawyer:
        return MaterialPageRoute(builder: (_) => Editprofilelawyer());

      default:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text("الصفحة غير موجودة")),
              ),
        );
    }
  }
}
