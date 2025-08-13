


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/widgets/FeedbackSheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget buildFeedbackCard(Map<String, dynamic> lawyerData) {
    Future<void> openFeedbackSheet(
    BuildContext context,
    String lawyerId,
    String nameLawyer,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid') ?? '';

    String nameClient = 'مستخدم مجهول';
    if (uid.isNotEmpty) {
      final userDoc = await FirebaseFirestore.instance
          .collection('clients')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        nameClient = userDoc.data()?['name'] ?? 'مستخدم مجهول';
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FeedbackSheet(
        lawyerId: lawyerId,
        nameClient: nameClient,
        clientId: uid,
        nameLawyer: nameLawyer,
      ),
    );
  }
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('lawyers')
          .doc(lawyerData['id'])
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('لا توجد بيانات للمحامي'));
        }

        final lawyerDoc = snapshot.data!.data() as Map<String, dynamic>;
        final feedbackList = lawyerDoc['feedback'] as List? ?? [];

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
                        "تعليقات العملاء",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add_comment_outlined,
                        color: AppColors.primaryColor,
                        size: 24.sp,
                      ),
                      onPressed: () {
                        openFeedbackSheet(
                          context,
                          lawyerDoc['id'],
                          lawyerDoc['name'],
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                if (feedbackList.isNotEmpty) ...[
                  SizedBox(
                    height: 320.h,
                    child: ListView.builder(
                      itemCount: feedbackList.length,
                      itemBuilder: (context, index) {
                        final feedbackMap = Map<String, dynamic>.from(
                          feedbackList[index],
                        );

                        String formattedDate = '';
                        final createdAtTimestamp = feedbackMap['createdAt'];
                        if (createdAtTimestamp != null &&
                            createdAtTimestamp is Timestamp) {
                          final date = createdAtTimestamp.toDate();
                          formattedDate = DateFormat(
                            'yyyy-MM-dd – kk:mm',
                          ).format(date);
                        } else if (createdAtTimestamp != null &&
                            createdAtTimestamp is String) {
                          formattedDate = createdAtTimestamp;
                        }

                        return Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
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
                                          // جلب اسم العميل Live من users collection
                                          FutureBuilder<DocumentSnapshot>(
                                            future: FirebaseFirestore.instance
                                                .collection('clients')
                                                .doc(feedbackMap['clientId'])
                                                .get(),
                                            builder: (context, userSnapshot) {
                                              String clientName =
                                                  'مستخدم مجهول';
                                              if (userSnapshot.hasData &&
                                                  userSnapshot.data!.exists) {
                                                final userData =
                                                    userSnapshot.data!.data()
                                                        as Map<String, dynamic>;
                                                clientName =
                                                    userData['name'] ??
                                                    'مستخدم مجهول';
                                              }
                                              return Text(
                                                clientName,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.sp,
                                                  color: AppColors.primaryColor,
                                                ),
                                              );
                                            },
                                          ),
                                          Row(
                                            children: [
                                              ...List.generate(
                                                5,
                                                (index) => Icon(
                                                  index <
                                                          (feedbackMap['rating'] ??
                                                              5)
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  color: Colors.amber,
                                                  size: 16.sp,
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                              Text(
                                                '${feedbackMap['rating']?.toString() ?? '5'}',
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
                                    feedbackMap['description'] ??
                                        'تعليق غير متوفر',
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
                          'كن أول من يعلق على هذا المحامي',
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
      },
    );
  }

