import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/cardArticale.dart';

class Homelawyer extends StatelessWidget {
  const Homelawyer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(backgroundColor: AppColors.whiteColor),
        drawer: Drawer(child: Icon(Icons.menu, color: AppColors.primaryColor)),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  // Search Bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'البحث',
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  verticalSpace(16),

                  // Section Title
                  Text(
                    'المقالات الاكثر انتشارا',
                    style: AppTextStyles.font20PrimarySemiBold,
                  ),
                  verticalSpace(16),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('articles')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('حدث خطأ أثناء تحميل المقالات'),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text('لا توجد مقالات حالياً'),
                          );
                        }
                        final articles = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final article = articles[index];
                            final data = article.data() as Map<String, dynamic>;
                            return Cardarticale(
                              uderId: data['userId'] ?? '',
                              userImage: data['userImage'] ?? '',
                              articleId: article.id,
                              userName: data['userName'] ?? '',
                              date: data['createdAt'] ?? '',
                              articleImage: data['imageUrl'] ?? '',
                              content: data['content'] ?? '',
                              likes: data['likes'] != null
                                  ? List<String>.from(data['likes'])
                                  : [],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
