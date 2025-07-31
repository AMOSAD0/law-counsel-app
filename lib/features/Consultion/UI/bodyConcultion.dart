import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/features/Consultion/Consultion_block/ConsultionBloc.dart';
import 'package:law_counsel_app/features/Consultion/Consultion_block/ConsultionEvent.dart';
import 'package:law_counsel_app/features/Consultion/Consultion_block/ConsultionState.dart';
import 'package:law_counsel_app/features/Consultion/UI/bottomsheetApp.dart';
import 'package:law_counsel_app/features/Consultion/data/consulation.dart';
import 'package:law_counsel_app/features/Consultion/utils/getLweyerdata.dart';

class MyConsultationBody extends StatefulWidget {
  const MyConsultationBody({super.key});

  @override
  State<MyConsultationBody> createState() => _MyConsultationBodyState();
}

class _MyConsultationBodyState extends State<MyConsultationBody> {
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

        BlocProvider.of<ConsultationBloc>(
          context,
        ).add(UpdateConsultationEvent(updatedConsultation, docRef));

        _titleController.clear();
        _descController.clear();

        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackgroundColor,
      appBar: AppBar(
        title: Text("استشاراتي", style: AppTextStyles.font18WhiteNormal),
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.btnColor),
      ),
      body: BlocListener<ConsultationBloc, ConsultationState>(
        listener: (context, state) {
          if (state is ConsultationSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
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
              final data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              return {
                'consultation': Consultation.fromMap(data),
                'docRef': doc.reference,
              };
            }).toList();

            return ListView.builder(
              itemCount: consultations.length,
              itemBuilder: (context, index) {
                final consult =
                    consultations[index]['consultation'] as Consultation;
                final docRef =
                    consultations[index]['docRef'] as DocumentReference;

                Color statusColor;
                String statusText;

                switch (consult.status) {
                  case "pending":
                    statusColor = const Color.fromARGB(255, 198, 159, 43);
                    statusText = "قيد الانتظار";
                    break;
                  case "approved":
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
                  margin: EdgeInsets.symmetric(
                    horizontal: 20.sp,
                    vertical: 10.sp,
                  ),
                  elevation: 2.sp,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: AppColors.primaryColor,
                      width: 0.8.sp,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: FutureBuilder<String?>(
                      future: consult.lawyerId.isNotEmpty
                          ? LawyerService.getLawyerNameById(consult.lawyerId)
                          : Future.value("غير معروف"),
                      builder: (context, snapshot) {
                        final lawyerName =
                            snapshot.connectionState == ConnectionState.waiting
                            ? "جاري تحميل اسم المحامي..."
                            : snapshot.data ?? "غير معروف";

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            /// العنوان
                            Text(
                              "عنوان الاستشارة",
                              style: AppTextStyles.font16primaryColorBold,
                            ),
                            verticalSpace(6),
                            Text(
                              consult.title,
                              style: AppTextStyles.font18PrimaryNormal,
                            ),

                            verticalSpace(16),

                            /// الوصف
                            Text(
                              "الوصف",
                              style: AppTextStyles.font16primaryColorBold,
                            ),
                            verticalSpace(6),
                            Text(
                              consult.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),

                            verticalSpace(16),

                            /// المحامي
                            Text(
                              "المحامي: $lawyerName",
                              style: AppTextStyles.font16primaryColorBold,
                            ),

                            verticalSpace(12),

                            /// الحالة والإجراءات
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// الحالة
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.2),
                                    border: Border.all(color: statusColor),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    statusText,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                /// الإجراءات حسب الحالة
                                if (consult.status == "pending")
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit_note,
                                          color: Colors.orange,
                                        ),
                                        onPressed: () => _showEditBottomSheet(
                                          consult,
                                          docRef,
                                        ),
                                      ),
                                    ],
                                  )
                                else if (consult.status == "rejected")
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_forever,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () {
                                      BlocProvider.of<ConsultationBloc>(
                                        context,
                                      ).add(DeleteConsultationEvent(docRef));
                                    },
                                  ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
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
