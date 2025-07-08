import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:law_counsel_app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/LogicClient/Profile-block/ProfileClient_bloc.dart';
import 'package:law_counsel_app/features/Client/auth/client_bloc/client_bloc.dart';
import 'package:law_counsel_app/features/chatbot/bloc/chatbotBloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ClientBloc()),
        BlocProvider(create: (_) => ProfileclientBloc()),
        BlocProvider(create: (_) => ChatbotBloc()),
      ],
      child: MyApp(),
    ),
  );
}
