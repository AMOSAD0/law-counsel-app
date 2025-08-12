import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/cardArticale.dart';
import 'package:law_counsel_app/core/widgets/search.dart';
import 'package:law_counsel_app/features/lawyer/myArticals/widgets/createArticale.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Myarticals extends StatefulWidget {
  const Myarticals({super.key});

  @override
  State<Myarticals> createState() => _MyarticalsState();
}

class _MyarticalsState extends State<Myarticals> {
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('uid');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackgroundColor,

      appBar: AppBar(
        title: Text("مقالاتي", style: AppTextStyles.font18WhiteNormal),
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.btnColor),
      ),
      body: userId == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Search Bar
                    Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: TextField(
                        onTap: () {
                          showSearch(
                            context: context,
                            delegate: UniversalSearchDelegate(
                              collectionName: 'articles',
                              searchableFields: ['title', 'content'],
                              resultBuilder: (data) {
                                return ListTile(
                                  title: Text(data['title'] ?? ''),
                                  subtitle: Text(data['content'] ?? ''),
                                  onTap: () {},
                                );
                              },
                            ),
                          );
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'بحث...',
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    verticalSpace(16),
                    CreateArticleWidget(),
                    verticalSpace(16),
                    Text('مقالاتي', style: AppTextStyles.font20PrimarySemiBold),
                    verticalSpace(16),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('articles')
                          .where('userId', isEqualTo: userId)
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
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final article = articles[index];
                            final data = article.data() as Map<String, dynamic>;
                            return Cardarticale(
                              uderId: data['userId'],
                              articleId: article.id,
                              userName: data['userName'],
                              date: data['createdAt'],
                              articleImage: data['imageUrl'],
                              userImage: data['userImage'],
                              content: data['content'],
                              likes: data['likes'] != null
                                  ? List<String>.from(data['likes'])
                                  : [],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
