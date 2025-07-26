import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/helper/formatDateToArabic.dart';
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
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('consultations')
              .where('lawyerId', isEqualTo: lawyerId)
              .where('status', isEqualTo: 'pending')
              .orderBy('createdAt', descending: true)
              .snapshots(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("حدث خطأ: ${snapshot.error}"));
        }
        final data = snapshot.data;
        if (data == null || data.docs.isEmpty) {
          return const Center(child: Text("لا توجد طلبات حالياً"));
        }
        final consultations =
            data.docs.map((doc) {
              return ConsultationModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              );
            }).toList();

        return ListView.builder(
          itemCount: consultations.length,
          itemBuilder: (context, index) =>_buildConsultationItem(context,consultations[index]),
          
        );
      },
    );
  }
}

Widget _buildConsultationItem(BuildContext context, ConsultationModel consultation) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
          radius: 48,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(consultation.userName??"مستخدم", style: AppTextStyles.font16primaryColorBold),
        subtitle: Text(formatDateToArabic( consultation.createdAt.toString()), style: AppTextStyles.font14GrayNormal),

        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1C2331),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
          onPressed: () => showConsultationDialog(context, consultation),
          child: Text("عرض الطلب", style: AppTextStyles.font16WhiteNormal),
        ),
      ),
    ),
  );
}

//  Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // صورة البروفايل
//           const CircleAvatar(
//             radius: 24,
//             backgroundColor: Colors.grey,
//             child: Icon(Icons.person, color: Colors.white),
//           ),
//           const SizedBox(width: 12),

//           // النصوص
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 const Text(
//                   "أشرف طلعت",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 4),
//                 const Text(
//                   "ppppppppppppppppppppppppp...",
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   textAlign: TextAlign.right,
//                 ),
//                 const SizedBox(height: 8),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF1C2331),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 8,
//                       horizontal: 16,
//                     ),
//                   ),
//                   onPressed: () {},
//                   child: const Text(
//                     "عرض الطلب",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 8),

//           // الوقت
//           const Text(
//             "الآن",
//             style: TextStyle(fontSize: 12, color: Colors.grey),
//           ),
//         ],
//       ),
