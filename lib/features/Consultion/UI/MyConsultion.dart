import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:law_counsel_app/features/Consultion/Consultion_block/ConsultionBloc.dart';
import 'package:law_counsel_app/features/Consultion/UI/bodyConcultion.dart';

class MyConsultation extends StatelessWidget {
  const MyConsultation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConsultationBloc(firestore: FirebaseFirestore.instance),
      child: const MyConsultationBody(),
    );
  }
}
