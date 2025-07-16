import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/CardCatogray.dart';
import 'package:law_counsel_app/core/widgets/DerwerApp.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/LogicClient/Profile-block/ProfileClient_bloc.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/LogicClient/Profile-block/ProfileClient_event.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/UI/LawyersForClient/LawyersCatogries.dart';
import 'package:law_counsel_app/features/Consultion/UI/AddConsultion.dart';

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
        key: _scaffoldKey,
        appBar: AppBar(
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
          ],
        ),
      ),
    );
  }
}
