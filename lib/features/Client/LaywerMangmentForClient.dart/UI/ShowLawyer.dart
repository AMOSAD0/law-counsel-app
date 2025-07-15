import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:law_counsel_app/features/Client/LaywerMangmentForClient.dart/LawyerMangment_bloc.dart';
import 'package:law_counsel_app/features/Client/LaywerMangmentForClient.dart/LawyerMangment_bloc/LawyerMangment_Event.dart';
import 'package:law_counsel_app/features/Client/LaywerMangmentForClient.dart/UI/LawyersShow.dart';

class ShowLawyer extends StatelessWidget {
    final String category;
  const ShowLawyer({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LawyerManagementBloc(FirebaseFirestore.instance)..add(LawyerLoadByCategoryEvent(category.trim())),
      child: LawyersShow(),
    );
  }
}
