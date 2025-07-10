import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:law_counsel_app/features/Chat/Chat_bloc/ChatBloc.dart';
import 'package:law_counsel_app/features/Chat/Chat_bloc/ChatEvent.dart';
import 'package:law_counsel_app/features/Chat/Chat_bloc/ChatState.dart';
import 'package:law_counsel_app/features/Chat/data/MessageModel.dart';

class ChatScreen extends StatefulWidget {
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
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
        title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ChatOnLoadedState) {
                  final messages = state.messages;
                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[messages.length - index - 1];
                      final isMe = msg.senderId == widget.currentUserId;
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 14),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[200] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            msg.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ChatErrorState) {
                  return Center(child: Text("حصل خطأ: ${state.ErrorMassage}"));
                } else {
                  return Center(child: Text("ابدأ المحادثة"));
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
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
