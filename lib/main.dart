import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:law_counsel_app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:law_counsel_app/features/chatbot/bloc/chatbotBloc.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('ar', null);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ChatbotBloc()),
      ],
      child: MyApp(),
    ),
  );
}
