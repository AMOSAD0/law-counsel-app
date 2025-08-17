import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/features/lawyer/chats/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class MessagesLawyer extends StatefulWidget {
  const MessagesLawyer({super.key});

  @override
  State<MessagesLawyer> createState() => _MessagesLawyerState();
}

class _MessagesLawyerState extends State<MessagesLawyer> {
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
    if (lawyerId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: AppColors.mainBackgroundColor,

      appBar: AppBar(
        title: Text("الرسائل", style: AppTextStyles.font18WhiteNormal),
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.btnColor),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('lawyerId', isEqualTo: lawyerId)
            // .orderBy('lastMessageTime', descending: true)
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
            return const Center(child: Text("لا توجد رسائل حالياً"));
          }
          final chats = data.docs.map((doc) {
            final chatData = doc.data() as Map<String, dynamic>;
            return {
              'id': doc.id,
              'clientId': chatData['clientId'],
              'lawyerId': chatData['lawyerId'],
              'nameClient': chatData['nameClient'] ?? 'عميل',
              'lastMessage': chatData['lastMessage'] ?? 'لا توجد رسائل',
              'lastMessageTime': chatData['lastMessageTime'],
            };
          }).toList();

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      
                      chatId: chats[index]['id'],
                      currentUserId: lawyerId!,
                      chats: chats,
                      index:index,
                      status: chats[index]['status'] ?? 'ongoing',
                      lawyerId: chats[index]['lawyerId'],
                      clientId: chats[index]['clientId'],
                    ),
                  ),
                );
              },
              child: _buildChatItem(chats[index]),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildChatItem(Map<String, dynamic> chat) {
  String formattedTime = '';
  if (chat['lastMessageTime'] != null) {
    final timestamp = chat['lastMessageTime'];
    if (timestamp is Timestamp) {
      final dateTime = timestamp.toDate();
      formattedTime = DateFormat('hh:mm a', 'ar').format(dateTime);
    }
  }

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
        title: Text(
          chat['nameClient'] ?? 'عميل',
          style: AppTextStyles.font16primaryColorBold,
        ),
        subtitle: Text(
          chat['lastMessage'] ?? 'لا توجد رسائل',
          style: AppTextStyles.font14GrayNormal,
        ),
        trailing: Text(formattedTime, style: AppTextStyles.font14GrayNormal),
      ),
    ),
  );
}
