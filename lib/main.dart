import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/routing/app_router.dart';
import 'package:law_counsel_app/core/routing/routes.dart';
import 'package:law_counsel_app/features/splash/ui/splaah_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splash,
      onGenerateRoute: (settings) => AppRouter.generateRoute(settings),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplaahScreen(),
    );
  }
}