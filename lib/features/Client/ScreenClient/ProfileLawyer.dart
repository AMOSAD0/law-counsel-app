import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/widgets/FeedbackSheet.dart';
import 'package:law_counsel_app/core/widgets/FeedbackWidget.dart';
import 'package:law_counsel_app/features/Consultion/UI/AddConsultion.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileLawyer extends StatefulWidget {
  final String lawyerId;
  const ProfileLawyer({super.key, required this.lawyerId});

  @override
  State<ProfileLawyer> createState() => _ProfileLawyerState();
}

class _ProfileLawyerState extends State<ProfileLawyer> {
  Map<String, dynamic>? lawyerData;

  @override
  void initState() {
    super.initState();
    fetchLawyerData();
  }

  Future<void> fetchLawyerData() async {
    final doc = await FirebaseFirestore.instance
        .collection('lawyers')
        .doc(widget.lawyerId)
        .get();
    if (doc.exists) {
      setState(() {
        lawyerData = doc.data();
        lawyerData!['id'] = doc.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (lawyerData == null) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'جاري التحميل...',
                style: TextStyle(color: Colors.grey[600], fontSize: 16.sp),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "الملف الشخصي",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.btnColor),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- Modern Profile Header Card ---
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        children: [
                          // Profile Image with Modern Border
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primaryColor.withOpacity(0.2),
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 56,
                                backgroundImage:
                                    (lawyerData!['profileImageUrl'] != null &&
                                        lawyerData!['profileImageUrl']
                                            .toString()
                                            .isNotEmpty)
                                    ? NetworkImage(
                                        lawyerData!['profileImageUrl'],
                                      )
                                    : AssetImage(AppAssets.defaultImgProfile)
                                          as ImageProvider,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Name & Profession
                          Text(
                            lawyerData!['name'] ?? 'بدون اسم',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.btnColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.btnColor.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              "محامي",
                              style: TextStyle(
                                color: AppColors.btnColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  verticalSpace(24.h),

                  // --- About Section Card ---
                  _buildModernCard(
                    icon: Icons.info_outline,
                    title: "نبذة عن المحامي",
                    content: lawyerData!['aboutMe'] ?? 'لا توجد نبذة متاحة',
                  ),
                  verticalSpace(20.h),

                  // --- Specializations Card ---
                  _buildSpecializationsCard(),
                  verticalSpace(16.h),
                  _buildModernCard(
                    title: "الإنجازات",
                    content:
                        lawyerData!['achievements'] ?? 'لا توجد إنجازات متاحة',
                    icon: Icons.emoji_events_outlined,
                  ),
                  verticalSpace(16.h),
                  // --- Stats Card ---
                  _buildPriceConsultationCard(),
                  SizedBox(height: 20.h),
                  // _buildStatsCard(),
                  // SizedBox(height: 20.h),

                  // --- Price & Consultation Card ---

                  // --- Rating Card ---
                  _buildRatingCard(),
                  SizedBox(height: 20.h),

                  // --- Feedback Section Card ---
                  buildFeedbackCard(lawyerData!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernCard({
    required String title,
    required String content,
    IconData? icon,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                horizontalSpace(12.w),

                Icon(icon, color: AppColors.primaryColor, size: 24.sp),
              ],
            ),
            verticalSpace(16.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!, width: 1),
              ),
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecializationsCard() {
    final specializations = List<String>.from(
      lawyerData!['specializations'] ?? [],
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "التخصصات",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                horizontalSpace(12.w),
                Icon(
                  Icons.work_outline,
                  color: AppColors.primaryColor,
                  size: 24.sp,
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: specializations
                  .map(
                    (spec) => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.btnColor.withOpacity(0.1),
                            AppColors.btnColor.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: AppColors.btnColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        spec,
                        style: TextStyle(
                          color: AppColors.btnColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceConsultationCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "سعر الاستشارة",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${lawyerData!['price'] ?? 0} جنية',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ConsultationButton(lawyerId: lawyerData!['id']),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingCard() {
    final rating = (lawyerData!['rating'] ?? 5.0) as num;
    final stars = List.generate(5, (index) {
      if (index < rating.floor()) {
        return Icons.star;
      } else if (index == rating.floor() && rating % 1 > 0) {
        return Icons.star_half;
      } else {
        return Icons.star_border;
      }
    });

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 28.sp),
                SizedBox(width: 8.w),
                Text(
                  "التقييم العام",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: stars
                  .map(
                    (icon) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Icon(icon, color: Colors.amber, size: 32.sp),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 8.h),
            Text(
              '${rating.toStringAsFixed(1)} / 5.0',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
