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
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text(state.error!));
          }
          if (state.lawyerData == null) {
            return const Center(child: Text('لم يتم العثور على بيانات'));
          }

          final lawyer = Lawyer.fromJson(state.lawyerData!);

          return Scaffold(
            backgroundColor: AppColors.whiteColor,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 130.h,
                      color: AppColors.primaryColor,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 70),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 60.r,
                              backgroundImage: NetworkImage(
                                (lawyer.profileImageUrl?.isEmpty ?? true)
                                    ? 'https://i.pravatar.cc/300'
                                    : lawyer.profileImageUrl!,
                              ),
                            ),
                            verticalSpace(8),
                            Text(
                              lawyer.name,
                              style: AppTextStyles.font24PrimarySemiBold,
                            ),
                            Text(
                              'محامي',
                              style: AppTextStyles.font20PrimarySemiBold,
                            ),
                            verticalSpace(12),
                            PublicButton(
                              text: 'تعديل الملف الشخصي',
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, Routes.editProfileLawyer);
                              },
                            ),
                            verticalSpace(20),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 380.h),
                          _buildSection(
                            icon: Icons.info_outline,
                            title: "نبذة عني",
                            child: Text(
                              lawyer.aboutMe ?? 'لا توجد معلومات متاحة',
                              style: AppTextStyles.font16primaryColorNormal
                                  .copyWith(color: Colors.grey[800]),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          _buildSection(
                            icon: Icons.gavel,
                            title: "مجال التخصص",
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: List<Widget>.from(
                                (lawyer.specializations as List<dynamic>).map(
                                  (tag) => _buildTag(tag.toString()),
                                ),
                              ),
                            ),
                          ),
                          _buildSection(
                            icon: Icons.attach_money,
                            title: "سعر الخدمة",
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Chip(
                                  backgroundColor: AppColors.primaryColor,
                                  label: Text(
                                    "${lawyer.price ?? 0} جنية",
                                    style: AppTextStyles.font16WhiteNormal,
                                  ),
                                ),
                                if (state.netPrice != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      "السعر بعد الخصم: ${state.netPrice!.toStringAsFixed(2)} جنية",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey[600],
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                Text(
                                  'الرصيد الحالي: ${lawyer.balance?.toStringAsFixed(2) ?? "0.00"} جنية',
                                  style: AppTextStyles
                                      .font16primaryColorNormal
                                      .copyWith(color: Colors.grey[800]),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          ),
                          _buildSection(
                            icon: Icons.emoji_events_outlined,
                            title: "الإنجازات",
                            child: Text(
                              lawyer.achievements ?? 'لا توجد معلومات متاحة',
                              style: AppTextStyles.font16primaryColorNormal
                                  .copyWith(color: Colors.grey[800]),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          _buildSection(
                            icon: Icons.comment_outlined,
                            title: "التعليقات",
                            child: (lawyer.feedback != null &&
                                    lawyer.feedback!.isNotEmpty)
                                ? ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: lawyer.feedback!.length,
                                    itemBuilder: (context, index) {
                                      final feedbackMap =
                                          lawyer.feedback![index];
                                      String formattedDate = '';
                                      final createdAtTimestamp =
                                          feedbackMap['createdAt'];
                                      if (createdAtTimestamp is Timestamp) {
                                        formattedDate = DateFormat(
                                                'yyyy-MM-dd – kk:mm')
                                            .format(createdAtTimestamp.toDate());
                                      } else if (createdAtTimestamp
                                          is String) {
                                        formattedDate = createdAtTimestamp;
                                      }
                                      final rating =
                                          feedbackMap['rating'] ?? 0;

                                      return Card(
                                        elevation: 2,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 6.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(12.w),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                feedbackMap['nameClient'] ??
                                                    'مستخدم مجهول',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.sp,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                              SizedBox(height: 6.h),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children:
                                                    List.generate(5, (star) {
                                                  return Icon(
                                                    star < rating
                                                        ? Icons.star
                                                        : Icons.star_border,
                                                    color: Colors.orange,
                                                    size: 18.sp,
                                                  );
                                                }),
                                              ),
                                              SizedBox(height: 6.h),
                                              Text(
                                                feedbackMap['description'] ??
                                                    'تعليق غير متوفر',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Colors.grey[800],
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                              SizedBox(height: 6.h),
                                              Text(
                                                formattedDate,
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.grey[600],
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: Text(
                                      'لا توجد تعليقات متاحة',
                                      style: AppTextStyles
                                          .font16primaryColorNormal
                                          .copyWith(color: Colors.grey[600]),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: AppTextStyles.font20PrimarySemiBold,
              ),
              const SizedBox(width: 8),
              Icon(icon, color: AppColors.primaryColor, size: 22),
            ],
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Chip(
      backgroundColor: AppColors.primaryColor,
      label: Text(
        text,
        style: AppTextStyles.font16WhiteNormal,
      ),
    );
  }
}
