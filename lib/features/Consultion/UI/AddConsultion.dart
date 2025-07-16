import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:law_counsel_app/features/Consultion/Consultion_block/ConsultionBloc.dart';
import 'package:law_counsel_app/features/Consultion/Consultion_block/ConsultionEvent.dart';
import 'package:law_counsel_app/features/Consultion/Consultion_block/ConsultionState.dart';
import 'package:law_counsel_app/features/Consultion/data/consulation.dart';
import 'package:law_counsel_app/features/Consultion/UI/bottomsheetApp.dart';

class ConsultationButton extends StatelessWidget {
    final String lawyerId; 
  const ConsultationButton({super.key, required this.lawyerId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConsultationBloc(firestore: FirebaseFirestore.instance),
      child:  _ConsultationButtonBody(lawyerId: lawyerId),
    );
  }
}

class _ConsultationButtonBody extends StatefulWidget {
    final String lawyerId; 
  const _ConsultationButtonBody({super.key, required this.lawyerId});

  @override
  State<_ConsultationButtonBody> createState() =>
      _ConsultationButtonBodyState();
}

class _ConsultationButtonBodyState extends State<_ConsultationButtonBody> {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error), backgroundColor: Colors.red),
    );
  }

  void _showBottomSheet() {
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

        final docRef =
            FirebaseFirestore.instance.collection('consultations').doc();
        final consultation = Consultation(
          id: docRef.id,
          title: title,
          description: desc,
          userId: FirebaseAuth.instance.currentUser!.uid,
          lawyerId: widget.lawyerId,
          status: "pending",
          createdAt: DateTime.now(),
        );

        context.read<ConsultationBloc>().add(
              SendConsultationEvent(consultation, docRef),
            );

        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConsultationBloc, ConsultationState>(
      listener: (context, state) {
        if (state is ConsultationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is ConsultationError) {
          _showError(state.error);
        }
      },
      child: ElevatedButton(
        onPressed: _showBottomSheet,
        child: const Text("حجز استشارة"),
      ),
    );
  }
}
