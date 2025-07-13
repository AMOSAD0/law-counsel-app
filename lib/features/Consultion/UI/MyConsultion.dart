import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:law_counsel_app/features/Consultion/Consultion_block/ConsultionBloc.dart';
import 'package:law_counsel_app/features/Consultion/Consultion_block/ConsultionEvent.dart';
import 'package:law_counsel_app/features/Consultion/Consultion_block/ConsultionState.dart';
import 'package:law_counsel_app/features/Consultion/UI/bottomsheetApp.dart';
import 'package:law_counsel_app/features/Consultion/data/consulation.dart';
import 'package:law_counsel_app/features/Consultion/utils/getLweyerdata.dart';

class MyConsultation extends StatefulWidget {
  const MyConsultation({super.key});

  @override
  State<MyConsultation> createState() => _MyConsultationState();
}

class _MyConsultationState extends State<MyConsultation> {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  void _showEditBottomSheet(Consultation consult, DocumentReference docRef) {
    _titleController.text = consult.title;
    _descController.text = consult.description;

    showConsultationBottomSheet(
      context: context,
      titleController: _titleController,
      descriptionController: _descController,
      buttonText: 'حفظ التعديل',
      onSubmit: () {
        final newTitle = _titleController.text.trim();
        final newDesc = _descController.text.trim();

        if (newTitle.isEmpty || newDesc.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('من فضلك املأ كل الحقول')),
          );
          return;
        }

        final updatedConsultation = Consultation(
          id: consult.id,
          title: newTitle,
          description: newDesc,
          userId: consult.userId,
          lawyerId: consult.lawyerId,
          status: consult.status,
          createdAt: consult.createdAt,
          updatedAt: DateTime.now(),
        );

        BlocProvider.of<ConsultationBloc>(context).add(
          UpdateConsultationEvent(updatedConsultation, docRef),
        );

        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("استشاراتي")),
      body: BlocListener<ConsultationBloc, ConsultationState>(
        listener: (context, state) {
          if (state is ConsultationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ConsultationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("consultations")
              .where("userId", isEqualTo: currentUserId)
              .orderBy("createdAt", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("لا توجد استشارات حتى الآن."));
            }

            final consultations = snapshot.data!.docs.map((doc) {
              return {
                'consultation': Consultation.fromMap(doc.data() as Map<String, dynamic>),
                'docRef': doc.reference,
              };
            }).toList();

            return ListView.builder(
              itemCount: consultations.length,
              itemBuilder: (context, index) {
                final consult = consultations[index]['consultation'] as Consultation;
                final docRef = consultations[index]['docRef'] as DocumentReference;

                Color statusColor;
                String statusText;

                switch (consult.status) {
                  case "pending":
                    statusColor = Colors.amber;
                    statusText = "قيد الانتظار";
                    break;
                  case "accepted":
                    statusColor = Colors.green;
                    statusText = "تمت الموافقة";
                    break;
                  case "rejected":
                    statusColor = Colors.red;
                    statusText = "مرفوضة";
                    break;
                  default:
                    statusColor = Colors.grey;
                    statusText = "غير معروف";
                }

                return Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FutureBuilder<String?>(
                    future: LawyerService.getLawyerNameById(consult.lawyerId),
                    builder: (context, snapshot) {
                      final lawyerName = snapshot.connectionState == ConnectionState.waiting
                          ? "جاري تحميل اسم المحامي..."
                          : snapshot.data ?? "غير معروف";

                      return ListTile(
                        title: Text(consult.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(consult.description),
                            const SizedBox(height: 4),
                            Text(
                              "المحامي: $lawyerName",
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: statusColor),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (consult.status == "pending") ...[
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showEditBottomSheet(consult, docRef),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  BlocProvider.of<ConsultationBloc>(context).add(
                                    DeleteConsultationEvent(consult.id),
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
