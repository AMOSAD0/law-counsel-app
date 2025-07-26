import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/features/lawyer/chats/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
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
        final chats =
            data.docs.map((doc) {
              return  {
                'id': doc.id,
                'clientId': doc['clientId'],
                'lawyerId': doc['lawyerId'],
                'lastMessage': doc['lastMessage']?? 'لا توجد رسائل',
                // 'lastMessageTime': doc['lastMessageTime']?? 'لا توجد رسائل',
              };
            }).toList();

        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) => InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ChatScreen(
                  chatId: chats[index]['id'],
                  currentUserId: lawyerId!,
                ),
              ));
            },
            child: _buildChatItem( chats[index])),
        );
      },
    );
  }
}

Widget _buildChatItem(Map<String, dynamic> chat ) {
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
        title: Text("أشرف طلعت", style: AppTextStyles.font16primaryColorBold),
        subtitle: Text(chat['lastMessage']??'lastMessage', style: AppTextStyles.font14GrayNormal),

        trailing: Text(chat['lastMessageTime']??'lastMessageTime', style: AppTextStyles.font14GrayNormal),
      ),
    ),
  );
}
