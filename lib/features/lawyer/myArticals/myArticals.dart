import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/cardArticale.dart';
import 'package:law_counsel_app/features/lawyer/myArticals/widgets/createArticale.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Myarticals extends StatefulWidget {
  const Myarticals({super.key});

  @override
  State<Myarticals> createState() => _MyarticalsState();
}

class _MyarticalsState extends State<Myarticals> {
   String ?userId;

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(backgroundColor: AppColors.whiteColor),
        drawer: Drawer(),
        body: userId == null?
        const Center(child: CircularProgressIndicator())
         :SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                CreateArticleWidget(),
                verticalSpace(16),
                Text(
                  'مقالاتي',
                  style: AppTextStyles.font20PrimarySemiBold,
                ),
                verticalSpace(16),
                StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
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
                          uderId: data['userId'] ,
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
      ),
    );
  }
}
