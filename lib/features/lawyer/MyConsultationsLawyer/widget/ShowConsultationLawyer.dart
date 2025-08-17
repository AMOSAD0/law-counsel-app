import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/features/Consultion/data/consulation.dart';

void showConsultationDialog(
  BuildContext context,
  Consultation consultation,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            textDirection: TextDirection.rtl,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1C2331),
                      const Color(0xFF1C2331).withOpacity(0.9),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    // Close button
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Title
                    Text(
                      'تفاصيل الاستشارة',
                      style: AppTextStyles.font20PrimarySemiBold.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Subtitle
                    Text(
                      'مراجعة طلب العميل',
                      style: AppTextStyles.font16primaryColorNormal.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Consultation Title
                    _buildInfoSection(
                      icon: Icons.title,
                      label: 'عنوان الاستشارة',
                      value: consultation.title,
                      iconColor: Colors.blue,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Description
                    _buildInfoSection(
                      icon: Icons.description,
                      label: 'محتوى الطلب',
                      value: consultation.description,
                      iconColor: Colors.green,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Client Name
                    _buildInfoSection(
                      icon: Icons.person,
                      label: 'اسم العميل',
                      value: consultation.nameClient ?? 'مستخدم',
                      iconColor: Colors.orange,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Action Buttons
                    Row(
                      children: [
                        // Approve Button
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.green, Colors.green.shade600],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                // تحديث حالة الاستشارة
                                await FirebaseFirestore.instance
                                    .collection('consultations')
                                    .doc(consultation.id)
                                    .update({'status': 'approved'});

                                // إنشاء مستند محادثة جديد مع بيانات المحامي والعميل
                                final chatDoc = await FirebaseFirestore.instance
                                    .collection('chats')
                                    .add({
                                      'clientId': consultation.userId,
                                      'lawyerId': consultation.lawyerId,
                                      'nameClient': consultation.nameClient,
                                      'nameLawyer': consultation.nameLawyer,
                                      "status": "ongoing", // pending, ongoing, completed, disputed
                                      'createdAt': FieldValue.serverTimestamp(),
                                      'lastMessage': 'مرحبا بك، يمكنك البدء في المحادثة الآن.',
                                      'lastMessageTime': FieldValue.serverTimestamp(),
                                    });

                                await FirebaseFirestore.instance
                                    .collection('chats')
                                    .doc(chatDoc.id)
                                    .collection('messages')
                                    .add({
                                      'senderId': consultation.lawyerId,
                                      'message': 'مرحبا بك، يمكنك البدء في المحادثة الآن.',
                                      'timestamp': FieldValue.serverTimestamp(),
                                    });

                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 24,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'موافق',
                                    style: AppTextStyles.font16WhiteNormal.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Reject Button
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.red, Colors.red.shade600],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('consultations')
                                    .doc(consultation.id)
                                    .update({'status': 'rejected'});
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 24,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'رفض',
                                    style: AppTextStyles.font16WhiteNormal.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildInfoSection({
  required IconData icon,
  required String label,
  required String value,
  required Color iconColor,
}) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Colors.grey.shade200,
        width: 1,
      ),
    ),
    child: Column(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.font14PrimaryBold.copyWith(
                color: const Color(0xFF1C2331),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: AppTextStyles.font14GrayNormal.copyWith(
            color: const Color(0xFF1C2331).withOpacity(0.8),
            height: 1.4,
          ),
          textDirection: TextDirection.rtl,
        ),
      ],
    ),
  );
}
