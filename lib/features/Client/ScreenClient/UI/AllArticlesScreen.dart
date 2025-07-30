import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/Cardarticale.dart';

class AllArticlesScreen extends StatelessWidget {
  const AllArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.btnColor),

        backgroundColor: AppColors.primaryColor,
        title: Text("كل المقالات", style: AppTextStyles.font18WhiteNormal),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('articles')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('لا توجد مقالات حالياً.'));
          }

          final articles = snapshot.data!.docs;

          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final data = articles[index].data() as Map<String, dynamic>;

              return Cardarticale(
                uderId: data['userId'] ?? '',
                userImage: data['userImage'],
                articleId: articles[index].id,
                userName: data['userName'] ?? '',
                date: data['createdAt'] ?? '',
                articleImage: data['imageUrl'],
                content: data['content'] ?? '',
                likes: List<String>.from(data['likes'] ?? []),
              );
            },
          );
        },
      ),
    );
  }
}
