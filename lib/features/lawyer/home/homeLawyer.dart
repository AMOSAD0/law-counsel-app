import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/DerwerApp.dart';
import 'package:law_counsel_app/core/widgets/cardArticale.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/UI/designHomeWidget.dart/slider.dart';

class Homelawyer extends StatefulWidget {
  const Homelawyer({super.key});

  @override
  State<Homelawyer> createState() => _HomelawyerState();
}

class _HomelawyerState extends State<Homelawyer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackgroundColor,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("الصفحة الرئيسية", style: AppTextStyles.font18WhiteNormal),
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.btnColor),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        elevation: 2,
      ),
      drawer: const DrwerApp(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==== Header Section ====
              SizedBox(
                height: 170.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(right: 0),
                  children: [
                    buildCardItem(
                      AppAssets.Slider1,
                      'تواصل مباشرة مع عملاءك \nاحصل على استشارات قانونية',
                    ),
                    buildCardItem(
                      AppAssets.Slider2,
                      'انشر مقالك\nشارك أفكارك القانونية',
                    ),
                    buildCardItem(
                      AppAssets.Slider3,
                      'القانون بجانبك دائمًا\nاستشارات موثوقة في متناول يدك',
                    ),
                  ],
                ),
              ),

              verticalSpace(20),

              // ==== Articles Section ====
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('articles')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                          verticalSpace(12),
                          Text(
                            'جاري تحميل المقالات...',
                            style: AppTextStyles.font16primaryColorNormal
                                .copyWith(color: AppColors.primaryColor),
                          ),
                        ],
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return _buildEmptyState(
                      icon: Icons.error_outline,
                      message: 'حدث خطأ أثناء تحميل المقالات',
                      subMessage: 'يرجى المحاولة مرة أخرى لاحقاً',
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildEmptyState(
                      icon: Icons.article_outlined,
                      message: 'لا توجد مقالات حالياً',
                      subMessage: 'كن أول من ينشر مقالاً قانونياً',
                    );
                  }

                  final articles = snapshot.data!.docs;

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: articles.length,
                    separatorBuilder: (_, __) => verticalSpace(16),
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

              verticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    String? subMessage,
  }) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: AppColors.primaryColor.withOpacity(0.8),
            ),
            verticalSpace(12),
            Text(
              message,
              style: AppTextStyles.font16primaryColorNormal.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (subMessage != null) ...[
              verticalSpace(6),
              Text(
                subMessage,
                style: AppTextStyles.font14PrimarySemiBold.copyWith(
                  color: AppColors.primaryColor.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
