import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/features/lawyer/MyConsultationsLawyer/widget/ShowConsultationLawyer.dart';
import 'package:law_counsel_app/features/lawyer/model/consulataionModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestsLawyer extends StatefulWidget {
  const RequestsLawyer({super.key});

  @override
  State<RequestsLawyer> createState() => _RequestsLawyerState();
}

class _RequestsLawyerState extends State<RequestsLawyer> {
  String? lawyerId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lawyerId = prefs.getString('uid');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header
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
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Title
                  Text(
                    'طلبات الاستشارات',
                    style: AppTextStyles.font20PrimarySemiBold.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'مراجعة الطلبات الجديدة من العملاء',
                    style: AppTextStyles.font16primaryColorNormal.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  
                  // Stats Card
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          icon: Icons.pending_actions,
                          label: 'في الانتظار',
                          color: Colors.orange,
                        ),
                        _buildStatItem(
                          icon: Icons.check_circle,
                          label: 'مقبولة',
                          color: Colors.green,
                        ),
                        _buildStatItem(
                          icon: Icons.cancel,
                          label: 'مرفوضة',
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Requests List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('consultations')
                    .where('lawyerId', isEqualTo: lawyerId)
                    .where('status', isEqualTo: 'pending')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                   
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            color: Color(0xFF1C2331),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'جاري تحميل الطلبات...',
                            style: AppTextStyles.font16primaryColorNormal.copyWith(
                              color: const Color(0xFF1C2331).withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  if (snapshot.hasError) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.all(24.0),
                        margin: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red.withOpacity(0.7),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'حدث خطأ أثناء التحميل',
                              style: AppTextStyles.font16primaryColorNormal.copyWith(
                                color: const Color(0xFF1C2331),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              snapshot.error.toString(),
                              style: AppTextStyles.font14GrayNormal,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  
                  final data = snapshot.data;
                  if (data == null || data.docs.isEmpty) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.all(32.0),
                        margin: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1C2331).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(
                                Icons.inbox_outlined,
                                size: 48,
                                color: const Color(0xFF1C2331).withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'لا توجد طلبات حالياً',
                              style: AppTextStyles.font18PrimaryNormal.copyWith(
                                color: const Color(0xFF1C2331),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'ستظهر هنا الطلبات الجديدة من العملاء',
                              style: AppTextStyles.font16primaryColorNormal.copyWith(
                                color: const Color(0xFF1C2331).withOpacity(0.6),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  
                  final consultations = data.docs.map((doc) {
                    return ConsultationModel.fromJson(
                      doc.data() as Map<String, dynamic>,
                      doc.id,
                    );
                  }).toList();

                  return ListView.builder(
    
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: consultations.length,
                    itemBuilder: (context, index) => _buildConsultationItem(
                      context,
                      consultations[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.font14PrimarySemiBold.copyWith(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

Widget _buildConsultationItem(BuildContext context, ConsultationModel consultation) {
  final formatDay= DateFormat('d MMMM y', 'ar');
  return Container(
    margin: const EdgeInsets.only(bottom: 16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
      //  textDirection:TextDirection.rtl,
        children: [
          // Profile Avatar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF1C2331).withOpacity(0.2),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xFF1C2331).withOpacity(0.1),
              child: Icon(
                Icons.person,
                color: const Color(0xFF1C2331),
                size: 30,
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // consultation.userName ??
                   "مستخدم",
                  style: AppTextStyles.font16primaryColorBold.copyWith(
                    color: const Color(0xFF1C2331),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: const Color(0xFF1C2331).withOpacity(0.6),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        // formatDateToArabic(consultation.createdAt.toString()),
                        formatDay.format(consultation.createdAt),
                        style: AppTextStyles.font12PrimaryNoemal.copyWith(
                          color: const Color(0xFF1C2331).withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Action Button
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1C2331), Color(0xFF1C2331)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1C2331).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
              ),
              onPressed: () => showConsultationDialog(context, consultation),
              child: Text(
                "عرض الطلب",
                style: AppTextStyles.font14WhiteNormal.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
