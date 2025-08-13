import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/CardCatogray.dart';
import 'package:law_counsel_app/core/widgets/DerwerApp.dart';
import 'package:law_counsel_app/core/widgets/cardArticale.dart';
import 'package:law_counsel_app/core/widgets/search.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/LogicClient/Profile-block/ProfileClient_bloc.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/LogicClient/Profile-block/ProfileClient_event.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/ProfileLawyer.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/UI/AllArticlesScreen.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/UI/LawyersForClient/LawyersCatogries.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/UI/designHomeWidget.dart/slider.dart';

class Homeclient extends StatefulWidget {
  const Homeclient({super.key});

  @override
  State<Homeclient> createState() => _HomeclientState();
}

class _HomeclientState extends State<Homeclient> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileclientBloc()..add(ProfileClientLoadEvent()),
      child: Scaffold(
        backgroundColor: AppColors.mainBackgroundColor,
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("الصفحه الرئسيه", style: AppTextStyles.font18WhiteNormal),
          backgroundColor: AppColors.primaryColor,
          iconTheme: IconThemeData(color: AppColors.btnColor),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),

        drawer: const DrwerApp(),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: TextField(
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: UniversalSearchDelegate(
                      collectionName: 'lawyers',
                      searchableFields: ['name'],
                      resultBuilder: (data) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              data['profileImageUrl'] ?? '',
                            ),
                          ),
                          title: Text(data['name'] ?? ''),
                          subtitle: Text(data['specialization'] ?? ''),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfileLawyer(lawyerId: data['id']),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
                decoration: InputDecoration(
                  hintText: 'بحث...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 170.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  buildCardItem(
                    AppAssets.Slider1,
                    'تواصل مباشرة مع محاميين متخصصين\nفي مختلف المجالات القانونية',
                  ),
                  buildCardItem(
                    AppAssets.Slider2,
                    'اسأل الشات بوت\nوهو هيفهم مشكلتك ويوجهك للقسم المناسب',
                  ),
                  buildCardItem(
                    AppAssets.Slider3,
                    'خبراء القانون بجانبك دائمًا\nاستشارات قانونية موثوقة في متناول يدك',
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0.sp),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Lawyerscatogries(),
                        ),
                      );
                    },
                    child: Text(
                      "عرض المزيد",
                      style: AppTextStyles.font14PrimaryBoldUnderline,
                    ),
                  ),
                  Spacer(),
                  Text("المحامين ", style: AppTextStyles.font20PrimarySemiBold),
                ],
              ),
            ),
            SizedBox(height: 150.h, child: CardLawyerHome()),
            Padding(
              padding: EdgeInsets.all(15.0.sp),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllArticlesScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "عرض المزيد",
                      style: AppTextStyles.font14PrimaryBoldUnderline,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "مقالات المحامين",
                    style: AppTextStyles.font20PrimarySemiBold,
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('articles')
                  .orderBy('createdAt', descending: true)
                  .limit(3)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('لا توجد مقالات حالياً.'));
                }

                final articles = snapshot.data!.docs;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          final data =
                              articles[index].data() as Map<String, dynamic>;

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
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
