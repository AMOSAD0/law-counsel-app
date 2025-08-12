import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/features/lawyer/MyConsultationsLawyer/Messages.dart';
import 'package:law_counsel_app/features/lawyer/MyConsultationsLawyer/Requests.dart';

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
    return Scaffold(
      backgroundColor: AppColors.mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "استشاراتي",
          style: AppTextStyles.font18WhiteNormal.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'الطلبات'),
                Tab(text: 'الرسائل'),
              ],
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.primaryColor,
              labelStyle: AppTextStyles.font16WhiteNormal,
              unselectedLabelStyle: AppTextStyles.font14PrimarySemiBold,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.btnColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [RequestsLawyer(), MessagesLawyer()],
      ),
    );
  }
}
