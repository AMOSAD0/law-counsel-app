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
        backgroundColor: AppColors.greyColor.withOpacity(0.05),
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          title: Text(
            'الصفحة الرئيسية',
            style: AppTextStyles.font20PrimarySemiBold,
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.primaryColor),
        ),
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryColor.withOpacity(0.1),
                  AppColors.whiteColor,
                ],
              ),
            ),
            child: Icon(Icons.menu, color: AppColors.primaryColor),
          ),
        ),
        body: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                // Modern Header Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //   begin: Alignment.topRight,
                    //   end: Alignment.bottomLeft,
                    //   colors: [
                    //     AppColors.primaryColor.withOpacity(0.1),
                    //     AppColors.primaryColor.withOpacity(0.05),
                    //   ],
                    // ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Welcome Text
                      Text(
                        'مرحباً بك في منصة الاستشارات القانونية',
                        style: AppTextStyles.font20PrimarySemiBold.copyWith(
                          color: AppColors.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      verticalSpace(8),
                      Text(
                        'اكتشف أحدث المقالات والرؤى القانونية',
                        style: AppTextStyles.font16primaryColorNormal.copyWith(
                          color: AppColors.primaryColor.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      verticalSpace(20),
                      
                      
                    ],
                  ),
                ),
                
                verticalSpace(20),
                
                // Articles List
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection('articles')
                              .orderBy('createdAt', descending: true)
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                                verticalSpace(16),
                                Text(
                                  'جاري تحميل المقالات...',
                                  style: AppTextStyles.font16primaryColorNormal.copyWith(
                                    color: AppColors.primaryColor.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Container(
                              padding: const EdgeInsets.all(24.0),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 48,
                                    color: AppColors.primaryColor.withOpacity(0.7),
                                  ),
                                  verticalSpace(16),
                                  Text(
                                    'حدث خطأ أثناء تحميل المقالات',
                                    style: AppTextStyles.font16primaryColorNormal.copyWith(
                                      color: AppColors.primaryColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Container(
                              padding: const EdgeInsets.all(24.0),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.article_outlined,
                                    size: 48,
                                    color: AppColors.primaryColor.withOpacity(0.7),
                                  ),
                                  verticalSpace(16),
                                  Text(
                                    'لا توجد مقالات حالياً',
                                    style: AppTextStyles.font16primaryColorNormal.copyWith(
                                      color: AppColors.primaryColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  verticalSpace(8),
                                  Text(
                                    'كن أول من ينشر مقالاً قانونياً',
                                    style: AppTextStyles.font14PrimarySemiBold.copyWith(
                                      color: AppColors.primaryColor.withOpacity(0.6),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        
                        final articles = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final article = articles[index];
                            final data = article.data() as Map<String, dynamic>;
                            
                            // Add spacing between cards
                            if (index > 0) {
                              return Column(
                                
                                children: [
                                  verticalSpace(16),
                                  Cardarticale(
                                    uderId: data['userId'] ?? '',
                                    userImage: data['userImage'] ?? '',
                                    articleId: article.id,
                                    userName: data['userName'] ?? '',
                                    date: data['createdAt'] ?? '',
                                    articleImage: data['imageUrl'] ?? '',
                                    content: data['content'] ?? '',
                                    likes:
                                        data['likes'] != null
                                            ? List<String>.from(data['likes'])
                                            : [],
                                  ),
                                ],
                              );
                            }
                            
                            return Cardarticale(
                              uderId: data['userId'] ?? '',
                              userImage: data['userImage'] ?? '',
                              articleId: article.id,
                              userName: data['userName'] ?? '',
                              date: data['createdAt'] ?? '',
                              articleImage: data['imageUrl'] ?? '',
                              content: data['content'] ?? '',
                              likes:
                                  data['likes'] != null
                                      ? List<String>.from(data['likes'])
                                      : [],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
