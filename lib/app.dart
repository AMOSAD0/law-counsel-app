import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/theming/app_theme.dart';

import 'package:law_counsel_app/core/widgets/bottomNav.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/UI/Profile.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/UI/homeClient.dart';

import 'package:law_counsel_app/features/splash/ui/splaah_screen.dart';
// import 'package:law_counsel_app/features/lawyer/signUp/signUp.dart';
// import 'package:law_counsel_app/features/lawyer/signUp/signUp2.dart';
// import 'package:law_counsel_app/features/splash/ui/splaah_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Law Counsel App',
        theme: AppTheme.lightTheme,

        home:SplaahScreen
        ()

      ),
    );
  }
}
