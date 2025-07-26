import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/features/lawyer/model/consulataionModel.dart';

void showConsultationDialog(
  BuildContext context,
  ConsultationModel consultation,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(16),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl,
            children: [
              Text(': عنوان الاستشارة', style: AppTextStyles.font14PrimaryBold),
              Text(
                consultation.title,
                style: AppTextStyles.font14GrayNormal,
                textDirection: TextDirection.rtl,
              ),

              verticalSpace(16),

              Text(': محتوى طلبك', style: AppTextStyles.font14PrimaryBold),
              verticalSpace(6),
              Text(
                consultation.description,
                style: AppTextStyles.font14GrayNormal,
                textDirection: TextDirection.rtl,
              ),
              verticalSpace(12),
              Text('العميل: ', style: AppTextStyles.font14PrimaryBold),
              Text(
                consultation.userName ?? 'مستخدم',
                style: AppTextStyles.font14GrayNormal,
              ),
              verticalSpace(20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('consultations')
                          .doc(consultation.id)
                          .update({'status': 'approved'});

                      final chatDoc = await FirebaseFirestore.instance
                          .collection('chats')
                          .add({
                            'clientId': consultation.userId,
                            'lawyerId': consultation.lawyerId,
                            'createdAt': FieldValue.serverTimestamp(),
                          });

                      await FirebaseFirestore.instance
                          .collection('chats')
                          .doc(chatDoc.id)
                          .collection('messages')
                          .add({
                            'senderId': consultation.lawyerId,
                            'message':
                                'مرحبا بك، يمكنك البدء في المحادثة الآن.',
                            'timestamp': FieldValue.serverTimestamp(),
                          });
                      await FirebaseFirestore.instance
                          .collection('chats')
                          .doc(chatDoc.id)
                          .update({
                            'lastMessage': 'مرحبا بك، يمكنك البدء في المحادثة الآن.',
                            'lastMessageTime': FieldValue.serverTimestamp(),
                          });

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'موافق',
                      style: AppTextStyles.font16WhiteNormal,
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('consultations')
                          .doc(consultation.id)
                          .update({'status': 'rejected'});
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Text('رفض', style: AppTextStyles.font16WhiteNormal),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
