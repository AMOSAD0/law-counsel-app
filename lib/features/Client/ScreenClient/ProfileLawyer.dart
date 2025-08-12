import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/ProfileBackground.dart';
import 'package:law_counsel_app/features/Consultion/UI/AddConsultion.dart';
import 'package:intl/intl.dart';

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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("الصفحة الشخصية", style: AppTextStyles.font18WhiteNormal),
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.btnColor),
      ),
      body: Stack(
        children: [
          const Profilebackground(),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        (lawyerData!['profileImageUrl'] != null &&
                            lawyerData!['profileImageUrl']
                                .toString()
                                .isNotEmpty)
                        ? NetworkImage(lawyerData!['profileImageUrl'])
                        : AssetImage(AppAssets.defaultImgProfile)
                              as ImageProvider,
                  ),
                  SizedBox(height: 12.h),

                  Text(
                    lawyerData!['name'] ?? 'بدون اسم',
                    style: AppTextStyles.font20PrimarySemiBold,
                  ),
                  SizedBox(height: 5.h),
                  Text("محامي", style: AppTextStyles.font16primaryColorNormal),
                  SizedBox(height: 12.h),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      ":نبذة عني",
                      style: AppTextStyles.font20PrimarySemiBold,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      lawyerData!['aboutMe'] ?? '',
                      style: AppTextStyles.font16GrayNormal,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "التخصصات",
                      style: AppTextStyles.font20PrimarySemiBold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(
                      spacing: 8,
                      children:
                          List<String>.from(
                                lawyerData!['specializations'] ?? [],
                              )
                              .map(
                                (spec) => Chip(
                                  label: Text(spec),
                                  backgroundColor: AppColors.btnColor,
                                  labelStyle: AppTextStyles.font16WhiteNormal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'الإنجازات',
                          style: AppTextStyles.font20PrimaryNormal,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${lawyerData!['achievements'] ?? 0}',
                          style: AppTextStyles.font16GrayNormal,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0.sp,
                            vertical: 10.0.sp,
                          ),
                          child: Text(
                            '${lawyerData!['price'] ?? 0} جنية',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      ConsultationButton(lawyerId: lawyerData!['id']),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  Align(
                    alignment: Alignment.centerRight,
                    child: ListTile(
                      leading: const Icon(Icons.star, color: Colors.amber),
                      title: Text(
                        'التقييم: ${((lawyerData!['rating'] ?? 5.0) as num).toStringAsFixed(1)}',
                        style: AppTextStyles.font20PrimarySemiBold,
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                   verticalSpace(20),
                             SizedBox(
  height: 300.h,  
  child: (lawyerData!['feedback'] != null &&
          (lawyerData!['feedback'] as List).isNotEmpty)
      ? ListView.builder(
          itemCount: (lawyerData!['feedback'] as List).length,
          itemBuilder: (context, index) {
            final feedbackMap =
                Map<String, dynamic>.from(lawyerData!['feedback'][index]);

            String formattedDate = '';
            final createdAtTimestamp = feedbackMap['createdAt'];
            if (createdAtTimestamp != null &&
                createdAtTimestamp is Timestamp) {
              final date = createdAtTimestamp.toDate();
              formattedDate =
                  DateFormat('yyyy-MM-dd – kk:mm').format(date);
            } else if (createdAtTimestamp != null &&
                createdAtTimestamp is String) {
              formattedDate = createdAtTimestamp;
            }

            return Card(
              margin: EdgeInsets.symmetric(vertical: 6.h),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feedbackMap['nameClient'] ?? 'مستخدم مجهول',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'التقييم: ${feedbackMap['rating']?.toString() ?? 'غير متوفر'}',
                      style: TextStyle(
                        color: Colors.orange[700],
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      feedbackMap['description'] ?? 'تعليق غير متوفر',
                      style: TextStyle(fontSize: 14.sp),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      formattedDate,
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
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
            style: AppTextStyles.font16primaryColorNormal,
            textAlign: TextAlign.center,
          ),
        ),
),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
