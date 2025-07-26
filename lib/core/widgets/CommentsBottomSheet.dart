import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';

class CommentsBottomSheet extends StatefulWidget {
  final String articleId;
  final String userId;

  const CommentsBottomSheet({
    super.key,
    required this.articleId,
    required this.userId,
  });

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();

  Future<void> _sendComment() async {
    if (_commentController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.articleId)
        .collection('comments')
        .add({
          'userName':
             await FirebaseFirestore.instance
                  .collection('lawyers')
                  .doc(widget.userId)
                  .get()
                  .then((doc) => doc.data()?['name'] ?? 'غير معروف')
                  , // Assuming userId is the username
          'content': _commentController.text.trim(),
          'userId': widget.userId,
          'createdAt': FieldValue.serverTimestamp(),
        });

    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              Text('التعليقات', style: AppTextStyles.font20PrimarySemiBold),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('articles')
                          .doc(widget.articleId)
                          .collection('comments')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final comments = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment =
                            comments[index].data() as Map<String, dynamic>;

                        return ListTile(
                          leading: const Icon(Icons.comment),
                          title: Text(comment['userName'] ?? ''),
                          subtitle: Text(
                            comment['content'] ?? '',
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'اكتب تعليقك...',
                        hintStyle: AppTextStyles.font14PrimarySemiBold,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _sendComment,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
