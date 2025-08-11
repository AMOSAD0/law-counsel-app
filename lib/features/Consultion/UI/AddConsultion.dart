import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
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
      child: _ConsultationButtonBody(lawyerId: lawyerId),
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
  bool isLoading = false;
  late String nameClient;
  late String nameLawyer;

  @override
  @override
  void initState() {
    super.initState();
    _loadNames();
  }

  Future<void> _loadNames() async {
    final nClientDoc =
        await FirebaseFirestore.instance
            .collection('clients')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

    final nLawyerDoc =
        await FirebaseFirestore.instance
            .collection('lawyers')
            .doc(widget.lawyerId)
            .get();

    final nClient = nClientDoc.data()?['name'] ?? 'عميل';
    final nLawyer = nLawyerDoc.data()?['name'] ?? 'محامي';

    if (mounted) {
      setState(() {
        nameClient = nClient;
        nameLawyer = nLawyer;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _showError(String error) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
          nameClient: nameClient,
          nameLawyer: nameLawyer,
        );

        context.read<ConsultationBloc>().add(
          SendConsultationEvent(consultation, docRef),
        );

        Navigator.pop(context);
        titleController.clear();
        descriptionController.clear();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConsultationBloc, ConsultationState>(
      listener: (context, state) {
        if (state is ConsultationSuccess) {
          _showMessage(state.message);
          setState(() => isLoading = false);
        } else if (state is ConsultationError) {
          _showError(state.error);
          setState(() => isLoading = false);
        } else if (state is ConsultationLoading) {
          setState(() => isLoading = true);
        }
      },
      builder: (context, state) {
        return ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(AppColors.btnColor),
            foregroundColor: WidgetStateProperty.all(Colors.white),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          onPressed: isLoading ? null : _showBottomSheet,
          child:
              isLoading
                  ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : Text("حجز استشارة", style: AppTextStyles.font14WhiteNormal),
        );
      },
    );
  }
}
