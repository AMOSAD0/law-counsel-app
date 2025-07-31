import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/features/lawyer/chats/chat.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  final defaultImage = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';

  Future<Map<String, String>> getLawyerInfo(String lawyerId) async {
    final doc = await FirebaseFirestore.instance
        .collection('lawyers')
        .doc(lawyerId)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      return {
        'name': data['name'] ?? 'غير معروف',
        'image': data['profileImageUrl'] ?? defaultImage,
      };
    }
    return {'name': 'غير معروف', 'image': defaultImage};
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColors.mainBackgroundColor,
      appBar: AppBar(
        title: Text("الرسائل", style: AppTextStyles.font18WhiteNormal),
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.btnColor),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('clientId', isEqualTo: currentUserId)
            .orderBy('lastMessageTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "لا توجد محادثات حالياً",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final chatDocs = snapshot.data!.docs;

          return Padding(
            padding: EdgeInsets.all(15.0.sp),
            child: ListView.separated(
              itemCount: chatDocs.length,
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.grey.shade300, height: 10.h),
              itemBuilder: (context, index) {
                final chat = chatDocs[index].data() as Map<String, dynamic>;
                final chatId = chatDocs[index].id;
                final lawyerId = chat['lawyerId'];

                return FutureBuilder<Map<String, String>>(
                  future: getLawyerInfo(lawyerId),
                  builder: (context, lawyerSnapshot) {
                    if (!lawyerSnapshot.hasData) {
                      return const ListTile(
                        title: Text("جارٍ تحميل بيانات المحامي..."),
                      );
                    }

                    final lawyerName = lawyerSnapshot.data!['name']!;
                    final imageUrl = lawyerSnapshot.data!['image']!;

                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                          color: const Color.fromARGB(255, 104, 107, 118),
                          width: .7,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(imageUrl),
                        backgroundColor: Colors.grey.shade200,
                      ),
                      title: Text(
                        lawyerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        chat['lastMessage'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: Text(
                        _formatTimestamp(chat['lastMessageTime']),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              chatId: chatId,
                              currentUserId: currentUserId,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return "${date.year}/${date.month}/${date.day} $hour:$minute";
  }
}
