import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/features/Chat/Chat_bloc/ChatBloc.dart';
import 'package:law_counsel_app/features/Chat/Chat_bloc/ChatEvent.dart';
import 'package:law_counsel_app/features/Chat/Chat_bloc/ChatState.dart';
import 'package:law_counsel_app/features/Chat/data/MessageModel.dart';
import 'package:law_counsel_app/features/Chat/r/repository.dart';

class ChatScreen extends StatelessWidget {
  final String currentUserId;
  final String currentUserEmail;
  final String receiverId;
  final String receiverEmail;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.currentUserEmail,
    required this.receiverId,
    required this.receiverEmail,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc(ChatRepository()),
      child: ChatScreenBody(
        currentUserId: currentUserId,
        currentUserEmail: currentUserEmail,
        receiverId: receiverId,
        receiverEmail: receiverEmail,
      ),
    );
  }
}

class ChatScreenBody extends StatefulWidget {
  final String currentUserId;
  final String currentUserEmail;
  final String receiverId;
  final String receiverEmail;

  const ChatScreenBody({
    super.key,
    required this.currentUserId,
    required this.currentUserEmail,
    required this.receiverId,
    required this.receiverEmail,
  });

  @override
  State<ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody> {
  late final String chatId;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final ids = [widget.currentUserId, widget.receiverId];
    ids.sort();
    chatId = ids.join('_');

    context.read<ChatBloc>().add(LoadChatEvent(chatId));
  }

  void sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final message = MessageModel(
      id: null,
      text: text,
      senderId: widget.currentUserId,
      senderEmail: widget.currentUserEmail,
      receiverId: widget.receiverId,
      receiverEmail: widget.receiverEmail,
      timestamp: Timestamp.now(),
    );

    context.read<ChatBloc>().add(SendMessageEvent(chatId, message));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.receiverEmail,
          style: AppTextStyles.font18WhiteNormal,
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatOnLoadedState) {
                  final messages = state.messages;
                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[messages.length - index - 1];
                      final isMe = msg.senderId == widget.currentUserId;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: isMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            if (!isMe)
                              CircleAvatar(
                                radius: 18,
                                backgroundImage: AssetImage(
                                  "assets/images/profile.png",
                                ),
                              ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6,
                              ),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? AppColors.primaryColor
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                msg.text,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isMe
                                      ? AppColors.whiteColor
                                      : const Color.fromARGB(255, 3, 3, 3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is ChatErrorState) {
                  return Center(child: Text("حصل خطأ: ${state.ErrorMassage}"));
                } else {
                  return const Center(child: Text("ابدأ المحادثة"));
                }
              },
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "اكتب رسالتك...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                horizontalSpace(10),
                IconButton(
                  icon: Image.asset(AppAssets.sendIcon),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
