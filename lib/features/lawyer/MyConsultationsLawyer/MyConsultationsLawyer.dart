import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/features/lawyer/MyConsultationsLawyer/Messages.dart';
import 'package:law_counsel_app/features/lawyer/MyConsultationsLawyer/Requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyConsultationsLawyer extends StatefulWidget {
  const MyConsultationsLawyer({Key? key}) : super(key: key);

  @override
  State<MyConsultationsLawyer> createState() => _MyConsultationsLawyerState();
}

class _MyConsultationsLawyerState extends State<MyConsultationsLawyer>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  

  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

 

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        appBar: AppBar(
          automaticallyImplyLeading: false,
           backgroundColor: AppColors.whiteColor,
          elevation: 0,
          title: Text(
            'استشاراتي',
            style: AppTextStyles.font20PrimarySemiBold,
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.primaryColor),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                child: SizedBox(
                  width: double.infinity,
                  child: Center(child: Text('الطلبات')),
                ),
              ),
              Tab(
                child: SizedBox(
                  width: double.infinity,
                  child: Center(child: Text('الرسائل')),
                ),
              ),
            ],

            labelColor: Colors.white,
            labelStyle: AppTextStyles.font16WhiteNormal,
            unselectedLabelStyle: AppTextStyles.font14PrimarySemiBold,
            unselectedLabelColor: AppColors.primaryColor,
            indicator: BoxDecoration(
              color: AppColors.primaryColor,

              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
          ),
        ),
        backgroundColor: const Color(0xFFF5F5F5),
        body: TabBarView(
          controller: _tabController,
          children: [
        
            RequestsLawyer(),
            
            MessagesLawyer(),
          ],
        ),
      ),
    );
  }
}
