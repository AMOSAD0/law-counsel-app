import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:law_counsel_app/features/Consultion/Consultion_block/ConsultionBloc.dart';
import 'package:law_counsel_app/features/Consultion/Consultion_block/ConsultionEvent.dart';
import 'package:law_counsel_app/features/Consultion/Consultion_block/ConsultionState.dart';
import 'package:law_counsel_app/features/Consultion/UI/bottomsheetApp.dart';
import 'package:law_counsel_app/features/Consultion/data/consulation.dart';

class ConsultationApp extends StatefulWidget {
  const ConsultationApp({super.key});

  @override
  State<ConsultationApp> createState() => _ConsultationAppState();
}

class _ConsultationAppState extends State<ConsultationApp> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _showSuccess(String message) {
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showError(String error) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الاستشارة')),
      body: BlocListener<ConsultationBloc, ConsultationState>(
        listener: (context, state) {
          if (state is ConsultationSuccess) {
            _showSuccess(state.message);
          } else if (state is ConsultationError) {
            _showError(state.error);
          }
        },
        child: Center(
          child: ElevatedButton(
            child: Text(
              "طلب استشاره"
            ),
            onPressed: () {
              showConsultationBottomSheet(
                context: context,
                titleController: titleController,
                descriptionController: descriptionController,
                buttonText: 'إرسال',
                onSubmit: () {
                  final title = titleController.text.trim();
                  final desc = descriptionController.text.trim();

                  if (title.isEmpty || desc.isEmpty) {
                    _showError("من فضلك املأ كل الحقول");
                    return;
                  }

                  final docRef = FirebaseFirestore.instance
                      .collection('consultations')
                      .doc();

                  final consultation = Consultation(
                    id: docRef.id,
                    title: title,
                    description: desc,
                    userId: FirebaseAuth.instance.currentUser!.uid,
                    lawyerId: "1LgdtODjbta0gnUVWaGNwFqmMTm2",
                    status: "pending",
                    createdAt: DateTime.now(),
                  );

                  BlocProvider.of<ConsultationBloc>(
                    context,
                  ).add(SendConsultationEvent(consultation, docRef));

                  Navigator.pop(context);
                },
              );
              
            },
          ),
        ),
      ),
    );
  }
}
