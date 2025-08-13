import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/routing/routes.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/public_button.dart';
import 'package:law_counsel_app/features/lawyer/model/lawyerModel.dart';
import 'package:law_counsel_app/features/lawyer/profileLawer/bloc/profileLawyerBloc.dart';
import 'package:law_counsel_app/features/lawyer/profileLawer/bloc/profileLawyerEvent.dart';
import 'package:law_counsel_app/features/lawyer/profileLawer/bloc/profileLawyerState.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LawyerProfilePage extends StatefulWidget {
  const LawyerProfilePage({super.key});

  @override
  State<LawyerProfilePage> createState() => _LawyerProfilePageState();
}

class _LawyerProfilePageState extends State<LawyerProfilePage> {
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
    if (userId == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return BlocProvider(
      create: (_) {
        return LawyerProfileBloc(firestore: FirebaseFirestore.instance)
          ..add(GetLawyerProfile(userId!));
      },
      child: BlocBuilder<LawyerProfileBloc, LawyerProfileState>(
        builder: (context, state) {
          if (state.isLoading) {
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
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state.error != null) {
            return Center(child: Text(state.error!));
          }
          if (state.lawyerData == null) {
            return const Center(child: Text('لم يتم العثور على بيانات'));
          }

          final lawyer = Lawyer.fromJson(state.lawyerData!);

          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              title: Text(
                "الملف الشخصي",
                style: AppTextStyles.font16WhiteNormal,
              ),
              centerTitle: true,
              backgroundColor: AppColors.primaryColor,

              elevation: 0,
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 24.h,
                    ),
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
                                      color: AppColors.primaryColor.withOpacity(
                                        0.2,
                                      ),
                                      width: 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryColor
                                            .withOpacity(0.3),
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
                                      backgroundImage: NetworkImage(
                                        (lawyer.profileImageUrl?.isEmpty ??
                                                true)
                                            ? 'https://i.pravatar.cc/300'
                                            : lawyer.profileImageUrl!,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h),

                                // Name & Profession
                                Text(
                                  lawyer.name,
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
                                      color: AppColors.btnColor.withOpacity(
                                        0.3,
                                      ),
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
                                SizedBox(height: 20.h),

                                // Edit Profile Button
                                Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.editProfileLawyer,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.btnColor,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.edit, size: 20.sp),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'تعديل الملف الشخصي',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
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
                          title: "نبذة عني",
                          content: lawyer.aboutMe ?? 'لا توجد معلومات متاحة',
                        ),
                        verticalSpace(20.h),

                        // --- Specializations Card ---
                        _buildSpecializationsCard(lawyer.specializations),
                        verticalSpace(16.h),

                        // --- Achievements Card ---
                        _buildModernCard(
                          title: "الإنجازات",
                          content:
                              lawyer.achievements ?? 'لا توجد معلومات متاحة',
                          icon: Icons.emoji_events_outlined,
                        ),
                        verticalSpace(16.h),

                        // --- Price & Balance Card ---
                        _buildPriceBalanceCard(lawyer, state),
                        SizedBox(height: 20.h),

                        // --- Comments Section Card ---
                        _buildCommentsCard(lawyer),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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

  Widget _buildSpecializationsCard(List<dynamic> specializations) {
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
                  "مجال التخصص",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                horizontalSpace(12.w),
                Icon(Icons.gavel, color: AppColors.primaryColor, size: 24.sp),
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
                        spec.toString(),
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

  Widget _buildPriceBalanceCard(Lawyer lawyer, LawyerProfileState state) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "سعر الخدمة",
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              '${lawyer.price ?? 0} جنية',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (state.netPrice != null) ...[
              SizedBox(height: 8.h),
              Text(
                "السعر بعد الخصم: ${state.netPrice!.toStringAsFixed(2)} جنية",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الرصيد الحالي',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${lawyer.balance?.toStringAsFixed(2) ?? "0.00"} جنية',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsCard(Lawyer lawyer) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.rate_review_outlined,
                  color: AppColors.primaryColor,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    "التعليقات",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (lawyer.feedback != null && lawyer.feedback!.isNotEmpty) ...[
              SizedBox(
                height: 320.h,
                child: ListView.builder(
                  itemCount: lawyer.feedback!.length,
                  itemBuilder: (context, index) {
                    final feedbackMap = lawyer.feedback![index];
                    String formattedDate = '';
                    final createdAtTimestamp = feedbackMap['createdAt'];
                    if (createdAtTimestamp is Timestamp) {
                      formattedDate = DateFormat(
                        'yyyy-MM-dd – kk:mm',
                      ).format(createdAtTimestamp.toDate());
                    } else if (createdAtTimestamp is String) {
                      formattedDate = createdAtTimestamp;
                    }
                    final rating = feedbackMap['rating'] ?? 0;

                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!, width: 1),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: AppColors.primaryColor
                                      .withOpacity(0.1),
                                  child: Icon(
                                    Icons.person,
                                    color: AppColors.primaryColor,
                                    size: 20.sp,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        feedbackMap['nameClient'] ??
                                            'مستخدم مجهول',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          ...List.generate(
                                            5,
                                            (index) => Icon(
                                              index < rating
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.amber,
                                              size: 16.sp,
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            '${rating.toString()}',
                                            style: TextStyle(
                                              color: Colors.orange[700],
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey[200]!,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                feedbackMap['description'] ?? 'تعليق غير متوفر',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[700],
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: Column(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 48.sp,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'لا توجد تعليقات متاحة',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'لم يتم إضافة أي تعليقات بعد',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
