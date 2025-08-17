import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/features/lawyer/chats/statesChat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final List<Map<String, dynamic>> chats;
  final int index;
  final String status; // ongoing, pending, completed, disputed
  final String lawyerId;
  final String clientId;
  const ChatScreen({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.chats,
    required this.index,
    required this.lawyerId,
    required this.clientId,
    required this.status,

  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  
   String userType ='';

  @override
  void initState() {
    super.initState();
    _loadUserType();
  }
  Future<void> _loadUserType() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userType = prefs.getString("userType")!;
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add({
          'senderId': widget.currentUserId,
          'message': text,
          'timestamp': FieldValue.serverTimestamp(),
        });

    _messageController.clear();

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .update({
          'lastMessage': text,
          'lastMessageTime': FieldValue.serverTimestamp(),
        });
  }

Future<void> handleEndConsultation() async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("تأكيد"),
        content: const Text("هل أنت متأكد أنك تريد إنهاء الاستشارة؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // إلغاء
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true), // تأكيد
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("إنهاء"),
          ),
        ],
      );
    },
  );


  if (confirm == true) {
    try {
      final chatDocRef =
          FirebaseFirestore.instance.collection("chats").doc(widget.chatId);

      await chatDocRef.update({
        "status": "pending",
        "endRequestBy": userType,
      });

      print("Consultation ended");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم إنهاء الاستشارة بنجاح")),
      );
    } catch (e) {
      print("Error ending consultation: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("حصل خطأ أثناء إنهاء الاستشارة")),
      );
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text("المحادثة", style: AppTextStyles.font18WhiteNormal),
        iconTheme: IconThemeData(color: AppColors.btnColor),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('لا توجد رسائل بعد.'));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg['senderId'] == widget.currentUserId;
                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isMe
                              ? AppColors.primaryColor
                              : AppColors.lightGreyColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          msg['message'],
                          style: isMe
                              ? AppTextStyles.font14WhiteNormal
                              : AppTextStyles.font14PrimaryNormal,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          StatusChatRenderer(
            chatId: widget.chatId,
            userType: userType,
            status: widget.status,
            messageController: _messageController,
            chats: widget.chats,
            index: widget.index,
            sendMessage: _sendMessage,
            lawyerId: widget.lawyerId,
            clientId: widget.clientId,
            

            
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 16.sp),
          //   child: Row(
          //     children: [
          //       Container(
          //         decoration: BoxDecoration(
          //           color: AppColors.errorColor,
                    
          //         ),
          //         child: IconButton(
          //           onPressed: handleEndConsultation,
          //           icon:Icon(Icons.logout_outlined,
          //             color: Colors.white,
          //             size: 26.sp,
          //           ),
          //         ),
          //       ),
          //       SizedBox(width: 10.sp),
          //       Expanded(
          //         child: Container(
          //           decoration: BoxDecoration(
          //             // color: const Color.fromARGB(255, 255, 255, 255),
          //             borderRadius: BorderRadius.circular(25),
          //             boxShadow: [
          //               BoxShadow(
          //                 color: Colors.grey.withOpacity(0.2),
          //                 spreadRadius: 1,
          //                 blurRadius: 6,
          //                 offset: const Offset(0, 3),
          //               ),
          //             ],
          //           ),
          //           child: TextField(
          //             controller: _messageController,
          //             decoration: InputDecoration(
          //               filled: true,
          //               fillColor: Colors.white,
          //               hintText: "اكتب رسالتك...",
          //               hintStyle: TextStyle(
          //                 color: const Color.fromARGB(255, 43, 43, 43),
          //               ),
          //               border: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(25),
          //                 // borderSide: BorderSide.none,
          //               ),
          //               contentPadding: const EdgeInsets.symmetric(
          //                 horizontal: 20,
          //                 vertical: 14,
          //               ),
          //             ),
          //             onSubmitted: (_) => _sendMessage(),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(width: 10),
          //       Container(
          //         decoration: BoxDecoration(
          //           color: AppColors.primaryColor,
          //           shape: BoxShape.circle,
          //         ),
          //         child: IconButton(
          //           onPressed: _sendMessage,
          //           icon: Image.asset(
          //             AppAssets.sendIcon,
          //             width: 26,
          //             height: 26,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
