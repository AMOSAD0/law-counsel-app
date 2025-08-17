import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/features/lawyer/chats/chat.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  final defaultImage = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';

  Future<Map<String, String>> getLawyerInfo(String lawyerId) async {
    final doc =
        await FirebaseFirestore.instance
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
        backgroundColor: AppColors.primaryColor,
        title: Text(" المحادثات", style: AppTextStyles.font18WhiteNormal),
        iconTheme: IconThemeData(color: AppColors.btnColor),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('chats')
                .where('clientId', isEqualTo: currentUserId)
                .orderBy('lastMessageTime', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("لا توجد محادثات حالياً"));
          }

          final chatDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chatDocs.length,
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                    title: Text(
                      lawyerName,
                      style: const TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(
                      chat['lastMessage'] ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      _formatTimestamp(chat['lastMessageTime']),
                      style: const TextStyle(fontSize: 12),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ChatScreen(
                                chatId: chatId,
                                currentUserId: currentUserId,
                                chats:
                                    chatDocs.map((doc) {
                                      final data =
                                          doc.data() as Map<String, dynamic>;
                                      return {
                                        'id': doc.id,
                                        'clientId': data['clientId'],
                                        'lawyerId': data['lawyerId'],
                                        'nameClient':
                                            data['nameClient'] ?? 'عميل',
                                        'lastMessage':
                                            data['lastMessage'] ??
                                            'لا توجد رسائل',
                                        'lastMessageTime':
                                            data['lastMessageTime'],
                                      };
                                    }).toList(),
                                index: index,
                                status: chat['status'] ?? 'ongoing',
                                lawyerId: chat['lawyerId'],
                                clientId: chat['clientId'],
                              ),
                        ),
                      );
                    },
                  );
                },
              );
            },
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
