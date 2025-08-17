import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
          nameClient: consult.nameClient,
          nameLawyer: consult.nameLawyer,
          paid: consult.paid,
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

  void _onPayNowPressed(Consultation consult, DocumentReference docRef) {
    if (consult.paid) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم الدفع بالفعل')));
      return;
    }

    BlocProvider.of<ConsultationBloc>(
      context,
    ).add(UpdatePaymentStatusEvent(docRef, true));

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم الدفع بنجاح')));
  }

  void _showDeleteConfirmationDialog(DocumentReference docRef) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFC9B38C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFC9B38C),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'تأكيد الحذف',
                style: TextStyle(
                  color: Color(0xFF262B3E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'هل أنت متأكد من حذف هذه الاستشارة؟\nلا يمكن التراجع عن هذا الإجراء.',
            style: TextStyle(color: Color(0xFF6B7280), fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<ConsultationBloc>(
                  context,
                ).add(DeleteConsultationEvent(docRef));
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC9B38C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'حذف',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "استشاراتي",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF262B3E),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFC9B38C)),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<ConsultationBloc, ConsultationState>(
        listener: (context, state) {
          if (state is ConsultationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFFC9B38C),
              ),
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFFC9B38C),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'جاري التحميل...',
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC9B38C).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.description_outlined,
                        size: 64,
                        color: Color(0xFFC9B38C),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "لا توجد استشارات حتى الآن",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "ابدأ بإنشاء استشارتك الأولى",
                      style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              );
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
              padding: const EdgeInsets.all(16),
              itemCount: consultations.length,
              itemBuilder: (context, index) {
                final consult =
                    consultations[index]['consultation'] as Consultation;
                final docRef =
                    consultations[index]['docRef'] as DocumentReference;

                Color statusColor;
                IconData statusIcon;
                String statusText;
                Color statusBgColor;

                switch (consult.status) {
                  case "pending":
                    statusColor = const Color(0xFFF59E0B);
                    statusBgColor = const Color(0xFFFEF3C7);
                    statusIcon = Icons.hourglass_empty;
                    statusText = "قيد الانتظار";
                    break;
                  case "approved":
                    statusColor = const Color(0xFF10B981);
                    statusBgColor = const Color(0xFFD1FAE5);
                    statusIcon = Icons.check_circle_outline;
                    statusText = "تمت الموافقة";
                    break;
                  case "rejected":
                    statusColor = const Color(0xFFEF4444);
                    statusBgColor = const Color(0xFFFEE2E2);
                    statusIcon = Icons.cancel_outlined;
                    statusText = "مرفوضة";
                    break;
                  default:
                    statusColor = const Color(0xFF6B7280);
                    statusBgColor = const Color(0xFFF3F4F6);
                    statusIcon = Icons.help_outline;
                    statusText = "غير معروف";
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with Status and Title
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusBgColor,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: statusColor.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        statusIcon,
                                        color: statusColor,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        statusText,
                                        style: TextStyle(
                                          color: statusColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    consult.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF262B3E),
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Lawyer Info
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC9B38C).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(
                                    0xFFC9B38C,
                                  ).withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFC9B38C),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "المحامي:",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                        Text(
                                          lawyerName,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF262B3E),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Consultation Description
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "الاستشارة:",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    consult.description,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF374151),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Action Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (consult.status == "approved" &&
                                    !consult.paid)
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryColor,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                      onPressed: () =>
                                          _onPayNowPressed(consult, docRef),
                                      icon: const Icon(Icons.payment, size: 18),
                                      label: const Text(
                                        'ادفع الآن',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (consult.status == "pending")
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF3B82F6,
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Color(0xFF3B82F6),
                                          ),
                                          onPressed: () => _showEditBottomSheet(
                                            consult,
                                            docRef,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFFEF4444,
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Color(0xFFEF4444),
                                          ),
                                          onPressed: () =>
                                              _showDeleteConfirmationDialog(
                                                docRef,
                                              ),
                                        ),
                                      ),
                                    ],
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
